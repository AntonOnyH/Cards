//
//  CardViewController.swift
//  Cards
//
//  Created by Hugo Prinsloo on 2018/04/29.
//  Copyright © 2018 Hugo. All rights reserved.
//

import UIKit
import LocalAuthentication
import Mixpanel

class CardsViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    
    private let cardManager = CardManager()
    private let segmentView = CardTypeSegmentView()
    
    private var shouldNotShowPattern: Bool {
        return UserDefaults.standard.bool(forKey: "shouldNotShowPattern")
    }
    
    // The only working solution to get rid of the line between the navigationBar & segment
    // https://stackoverflow.com/a/34453029/4940845
    private var navBarLine: UIImageView?

    override func viewDidLoad() {
        super.viewDidLoad()
        setBackgroundColor()
        Mixpanel.sharedInstance()?.track("CardFeed - Viewed")
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(CardCell.self, forCellReuseIdentifier: "Cell")
        tableView.separatorInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        configureNavigationBar()
        let longPress = UILongPressGestureRecognizer(target: self, action: #selector(handleLongPress(_:)))
        tableView.addGestureRecognizer(longPress)
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        cardManager.fetch()
        tableView.reloadData()
        
        navBarLine = findHairlineImageViewUnderView(view: navigationController?.navigationBar)
        navBarLine?.isHidden = true
    }
    
    private func configureNavigationBar() {
        title = NSLocalizedString("Cards", comment: "")
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationController?.navigationBar.tintColor = .gray
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Add", style: .done, target: self, action: #selector(handleAddButtonTapped))
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Settings", style: .plain, target: self, action: #selector(handleSettingsButtonTapped))
    }
    
    @objc private func handleAddButtonTapped() {
        if let vc = storyboard?.instantiateViewController(withIdentifier: "NewCardController") as? NewCardViewController {
            vc.cardManager = self.cardManager
            vc.newCardDelegate = self
            let nav = UINavigationController(rootViewController: vc)
            navigationController?.present(nav, animated: true)
        }
    }

    
    @objc private func handleSettingsButtonTapped() {
        if let vc = storyboard?.instantiateViewController(withIdentifier: "SettingsViewController") as? SettingsViewController {
            let nav = UINavigationController(rootViewController: vc)
            navigationController?.present(nav, animated: true)
        }
    }
    
    @objc func handleLongPress(_ gestureRecognizer: UILongPressGestureRecognizer) {
        guard gestureRecognizer.state == .began else { return }
        let location = gestureRecognizer.location(in: tableView)
        guard let indexPath = tableView.indexPathForRow(at: location), let cell = tableView.cellForRow(at: indexPath) as? CardCell else {
            return
        }
        
        presentMoreOptions(index: indexPath.row, fromView: cell)
    }
    
    fileprivate func presentMoreOptions(index: Int, fromView: CardCell?) {
        let alert = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        let deleteAction = UIAlertAction(title: NSLocalizedString("Delete", comment: ""), style: .destructive) { [weak self] _ in
            if let card = self?.cardManager.cardAtIndex(index) {
                self?.cardManager.delete(card, completion: {
                    self?.tableView.reloadData()
                })
            }
        }
        
        let cancelAction = UIAlertAction(title: NSLocalizedString("Cancel", comment: ""), style: .cancel, handler: nil)
        let copyAction = UIAlertAction(title: NSLocalizedString("Copy number", comment: ""), style: .default) { (Action) in
            if let cardNumber = fromView?.numberLabel.text {
                let numberWithNoSpacing = cardNumber.components(separatedBy: .whitespaces).joined()
                let pasteboard = UIPasteboard.general
                pasteboard.string = numberWithNoSpacing
            }
        }

        alert.addAction(copyAction)
        alert.addAction(deleteAction)
        alert.addAction(cancelAction)
        
        if let v = fromView {
            alert.popoverPresentationController?.sourceView = v
            alert.popoverPresentationController?.sourceRect = v.bounds
        }
        
        present(alert, animated: true, completion: nil)
    }
}

extension CardsViewController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return cardManager.numberOfCards()
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! CardCell
        cell.delegate = self
        let item = cardManager.cardAtIndex(indexPath.row)
        cell.configure(with: item)
        return cell
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if let cell = cell as? CardCell {
            cell.showPattern = shouldNotShowPattern
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 230
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        segmentView.delegate = self
        return segmentView
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 30
    }
}

extension CardsViewController: CardTypeSegmentViewDelegate {
    func cardTypeSegmentView(_ cardTypeSegmentView: CardTypeSegmentView, didChangeCardType type: Card.CardType) {
        cardManager.type = type
        tableView.reloadData()
    }
}

extension CardsViewController:NewCardViewConstrollerDelegate{
    func newCardViewController(newCardViewController: NewCardViewController, didAddCard type: Card.CardType) {
        segmentView.currentSegment = type
    }
}

extension CardsViewController: CardCellDelegate {
    func cardCelldidRequestAddPersonalName(for card: Card?) {
        guard let card = card else { return }
        let alert = UIAlertController(title: "Personal Name", message: "", preferredStyle: .alert)
        alert.addTextField { (textField) in
            print("Yolo")
        }
        
        alert.addAction(UIAlertAction(title: NSLocalizedString("Save", comment: ""), style: .default, handler: { [weak self] _ in
            if let personalName = alert.textFields?.first?.text {
                self?.cardManager.addPersonalName(card, personalName: personalName, completion: {
                self?.tableView.reloadData()
                })
            }
            print("Saved")
        }))
        
        alert.addAction(UIAlertAction(title: NSLocalizedString("Cancel", comment: ""), style: .destructive, handler: { _ in
            print("Cancel")
        }))

        
        present(alert, animated: true)
    }
    
    func findHairlineImageViewUnderView(view: UIView?) -> UIImageView? {
        guard let view = view else { return nil }
        if view.isKind(of: UIImageView.classForCoder()) && view.bounds.height <= 1 {
            return view as? UIImageView
        }
        for subView in view.subviews {
            if let imageView = findHairlineImageViewUnderView(view: subView) {
                return imageView
            }
        }
        return nil
    }
}




