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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setBackgroundColor()
        Mixpanel.sharedInstance()?.track("CardFeed - Viewed")
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(CardCell.self, forCellReuseIdentifier: "Cell")

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
            navigationController?.present(vc, animated: true)
        }
    }
    
    @objc private func handleSettingsButtonTapped() {
        
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
        let action = UIAlertAction(title: NSLocalizedString("Delete", comment: "removing file"), style: .destructive) { _ in
            self.cardManager.deleteCardAtIndex(index, completion: {
                self.tableView.reloadData()
            })
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
//        cell.cardImageView.backgroundColor = item.cardTheme.color
        cell.mode = .light
        cell.bankTypeImageView.image = item.bankType.image
        cell.expiryLabel.text = item.expiry
        cell.numberLabel.text = item.cardNumber
        cell.titleLabel.text = item.name
        cell.cvvLabel.text = "CVV: \(item.cvv)"
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
       
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 230
    }
    
    
}

