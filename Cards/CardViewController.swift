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

class CardViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    
    private let cardManager = CardManager()
    
    private let segmentView = CardTypeSegmentView()

        
    override func viewDidLoad() {
        super.viewDidLoad()
        setBackgroundColor()
        Mixpanel.sharedInstance()?.track("CardFeed - Viewed")
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(CardCell.self, forCellReuseIdentifier: "Cell")
        tableView.separatorInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        
        cardManager.fetch()
        configureNavigationBar()
        
        let longPress = UILongPressGestureRecognizer(target: self, action: #selector(handleLongPress(_:)))
        tableView.addGestureRecognizer(longPress)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tableView.reloadData()
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
            let nav = UINavigationController(rootViewController: vc)
            navigationController?.present(nav, animated: true)
        }
    }

    
    @objc private func handleSettingsButtonTapped() {
        let alert = UIAlertController(title: "Coming Soon", message: "Settings will launch soon", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Dismiss", style: .default, handler: { (_) in
            alert.dismiss(animated: true, completion: nil)
        }))
        
        present(alert, animated: true)
    }
    
    @objc func handleLongPress(_ gestureRecognizer: UILongPressGestureRecognizer) {
        guard gestureRecognizer.state == .began else { return }
        let location = gestureRecognizer.location(in: tableView)
        guard let indexPath = tableView.indexPathForRow(at: location), let cell = tableView.cellForRow(at: indexPath) else {
            return
        }
        
        presentMoreOptions(index: indexPath.row, fromView: cell)
    }
    
    fileprivate func presentMoreOptions(index: Int, fromView: UIView?) {
        
        let alert = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        let action = UIAlertAction(title: NSLocalizedString("Delete", comment: "removing file"), style: .destructive) { [weak self] _ in
            if let card = self?.cardManager.cardAtIndex(index) {
                self?.cardManager.delete(card, completion: {
                    self?.tableView.reloadData()
                })
            }
        }
        alert.addAction(action)
        
        let cancelAction = UIAlertAction(title: NSLocalizedString("Cancel", comment: ""), style: .cancel, handler: nil)
        alert.addAction(cancelAction)
        
        if let v = fromView {
            alert.popoverPresentationController?.sourceView = v
            alert.popoverPresentationController?.sourceRect = v.bounds
        }
        
        present(alert, animated: true, completion: nil)
    }

}

extension CardViewController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return cardManager.numberOfCards()
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! CardCell
        let item = cardManager.cardAtIndex(indexPath.row)
        cell.configure(with: item)
        return cell
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
}

extension CardViewController: CardTypeSegmentViewDelegate {
    func cardTypeSegmentView(_ cardTypeSegmentView: CardTypeSegmentView, didChangeCardType type: Card.CardType) {
        cardManager.type = type
        tableView.reloadData()
    }
}



