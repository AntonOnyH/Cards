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
        Mixpanel.sharedInstance()?.track("CardFeed - Viewed")

        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(CardCell.self, forCellReuseIdentifier: "Cell")

        cardManager.fetch()
        configureNavigationBar()
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
        cell.cardImageView.backgroundColor = item.cardTheme.color
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

class CardCell: UITableViewCell {
        
    var mode: Mode = .light {
        didSet {
            switch mode {
            case .dark:
                numberLabel.textColor = .white
                titleLabel.textColor = .white
                expiryLabel.textColor = .white
                cvvLabel.textColor = .white
            case .light:
                cvvLabel.textColor = .darkGray
                expiryLabel.textColor = .darkGray
                numberLabel.textColor = .darkGray
                titleLabel.textColor = .darkGray
            }
        }
    }
    
    let cardImageView: UIImageView = {
        let i = UIImageView()
        i.translatesAutoresizingMaskIntoConstraints = false
        i.contentMode = .scaleAspectFit
        i.backgroundColor = .gray
        return i
    }()
    
    let bankTypeImageView: UIImageView = {
        let i = UIImageView()
        i.translatesAutoresizingMaskIntoConstraints = false
        i.contentMode = .scaleAspectFit
        return i
    }()
    
    let expiryLabel: UILabel = {
        let l = UILabel()
        l.font = UIFont.systemFont(ofSize: 16, weight: .regular)
        l.translatesAutoresizingMaskIntoConstraints = false
        l.textColor = UIColor.white.withAlphaComponent(0.5)
        return l
    }()
    
    let cvvLabel: UILabel = {
        let l = UILabel()
        l.font = UIFont.systemFont(ofSize: 12, weight: .regular)
        l.translatesAutoresizingMaskIntoConstraints = false
        l.textColor = UIColor.white.withAlphaComponent(0.5)
        return l
    }()

    
    let numberLabel: UILabel = {
        let l = UILabel()
        l.font = UIFont.systemFont(ofSize: 24, weight: .medium)
        l.translatesAutoresizingMaskIntoConstraints = false
        l.textColor = UIColor.white.withAlphaComponent(0.5)
        return l
    }()

    
    let titleLabel: UILabel = {
        let l = UILabel()
        l.translatesAutoresizingMaskIntoConstraints = false
        l.textColor = .white
        l.font = UIFont.boldSystemFont(ofSize: 21)
        return l
    }()
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }
    
    private func setup() {
        backgroundColor = .clear
        addConstraints()
        addCornerRadius()
    }
    
    private func addConstraints() {
        contentView.addSubview(cardImageView)
        cardImageView.addSubview(numberLabel)
        cardImageView.addSubview(titleLabel)
        cardImageView.addSubview(bankTypeImageView)
        cardImageView.addSubview(expiryLabel)
        cardImageView.addSubview(cvvLabel)
        
        cardImageView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16).isActive = true
        cardImageView.topAnchor.constraint(equalTo: topAnchor, constant: 8).isActive = true
        cardImageView.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        cardImageView.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        
        numberLabel.leadingAnchor.constraint(equalTo: cardImageView.leadingAnchor, constant: 16).isActive = true
        numberLabel.centerXAnchor.constraint(equalTo: cardImageView.centerXAnchor).isActive = true
        numberLabel.centerYAnchor.constraint(equalTo: cardImageView.centerYAnchor, constant: -10).isActive = true
        
        expiryLabel.leadingAnchor.constraint(equalTo: numberLabel.leadingAnchor).isActive = true
        expiryLabel.topAnchor.constraint(equalTo: numberLabel.bottomAnchor, constant: 16).isActive = true

        cvvLabel.trailingAnchor.constraint(equalTo: cardImageView.trailingAnchor, constant: -16).isActive = true
        cvvLabel.centerYAnchor.constraint(equalTo: titleLabel.centerYAnchor).isActive = true

        
        
        titleLabel.leadingAnchor.constraint(equalTo: cardImageView.leadingAnchor, constant: 16).isActive = true
        titleLabel.centerXAnchor.constraint(equalTo: cardImageView.centerXAnchor).isActive = true
        titleLabel.bottomAnchor.constraint(equalTo: cardImageView.bottomAnchor, constant: -16).isActive = true
  
        bankTypeImageView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -32).isActive = true
        bankTypeImageView.topAnchor.constraint(equalTo: topAnchor, constant: 24).isActive = true
        bankTypeImageView.widthAnchor.constraint(equalToConstant: 70).isActive = true
        bankTypeImageView.heightAnchor.constraint(equalToConstant: 50).isActive = true

    }
    
    private func addCornerRadius() {
        cardImageView.layer.cornerRadius = 8
        cardImageView.clipsToBounds = true
    }
}
