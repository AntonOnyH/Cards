//
//  CardViewController.swift
//  Cards
//
//  Created by Hugo Prinsloo on 2018/04/29.
//  Copyright © 2018 Hugo. All rights reserved.
//

import UIKit
import LocalAuthentication

enum Mode {
    case light
    case dark
}


enum CardTheme {
    case black
    case gray
    case criene
    case pearl
    case yolo
    
    var color: UIColor {
        switch self {
        case .black:
            return UIColor(named: "C1") ?? .gray
        case .gray:
            return UIColor(named: "C2") ?? .gray
        case .criene:
            return UIColor(named: "C3") ?? .gray
        case .pearl:
            return UIColor(named: "C4") ?? .gray
        case .yolo:
            return UIColor(named: "C5") ?? .gray
        }
    }
    
    var mode: Mode {
        switch self {
        case .black, .gray, .criene:
            return .dark
        case .pearl, .yolo:
            return .light
        }
    }
}




class CardViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    
    private let cardManager = CardManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
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
        cell.cardImageView.backgroundColor = .red
        cell.mode = .light
        
        cell.numberLabel.text = item.cardNumber
        cell.titleLabel.text = item.name
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
       
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 250
    }
    
    
}

class CardCell: UITableViewCell {
        
    var mode: Mode = .light {
        didSet {
            switch mode {
            case .dark:
                numberLabel.textColor = .white
                titleLabel.textColor = .white
            case .light:
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
    
    let numberLabel: UILabel = {
        let l = UILabel()
        l.translatesAutoresizingMaskIntoConstraints = false
        l.textColor = UIColor.white.withAlphaComponent(0.5)

        return l
    }()
    
    let titleLabel: UILabel = {
        let l = UILabel()
        l.translatesAutoresizingMaskIntoConstraints = false
        l.textColor = .white
        l.font = UIFont.boldSystemFont(ofSize: 28)
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
        
        cardImageView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16).isActive = true
        cardImageView.topAnchor.constraint(equalTo: topAnchor, constant: 16).isActive = true
        cardImageView.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        cardImageView.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        
        numberLabel.leadingAnchor.constraint(equalTo: cardImageView.leadingAnchor, constant: 16).isActive = true
        numberLabel.centerXAnchor.constraint(equalTo: cardImageView.centerXAnchor).isActive = true
        numberLabel.centerYAnchor.constraint(equalTo: cardImageView.centerYAnchor, constant: 50).isActive = true
        
        titleLabel.leadingAnchor.constraint(equalTo: cardImageView.leadingAnchor, constant: 16).isActive = true
        titleLabel.centerXAnchor.constraint(equalTo: cardImageView.centerXAnchor).isActive = true
        titleLabel.centerYAnchor.constraint(equalTo: cardImageView.centerYAnchor, constant: -50).isActive = true
    }
    
    private func addCornerRadius() {
        cardImageView.layer.cornerRadius = 16
        cardImageView.clipsToBounds = true
    }
}
