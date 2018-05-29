//
//  CardCell.swift
//  Cards
//
//  Created by Hugo Prinsloo on 2018/05/12.
//  Copyright © 2018 Hugo. All rights reserved.
//

import Foundation
import UIKit

class CardCell: UITableViewCell {
    
    var mode: Mode = .light {
        didSet {
            switch mode {
            case .light:
                numberLabel.textColor = UIColor(named: "C4") ?? .white
                titleLabel.textColor = UIColor(named: "C4") ?? .white
                expiryLabel.textColor = UIColor(named: "C4")?.withAlphaComponent(0.5) ?? .white
                cvvLabel.textColor = UIColor(named: "C4")?.withAlphaComponent(0.5) ?? .white
            case .dark:
                cvvLabel.textColor = .darkGray
                expiryLabel.textColor = .darkGray
                numberLabel.textColor = .darkGray
                titleLabel.textColor = .darkGray
            }
        }
    }
    
    private let logoImageView: UIImageView = {
        let i = UIImageView()
        i.translatesAutoresizingMaskIntoConstraints = false
        i.contentMode = .scaleAspectFit
        i.tintColor = UIColor(named: "C4")
        return i
    }()
    
    let cardView: UIView = {
        let i = UIView()
        i.translatesAutoresizingMaskIntoConstraints = false
        i.contentMode = .scaleAspectFit
        i.layer.cornerRadius = 8
        i.clipsToBounds = true
        return i
    }()
    
    let bankTypeImageView: UIImageView = {
        let i = UIImageView()
        i.translatesAutoresizingMaskIntoConstraints = false
        i.contentMode = .scaleAspectFit
        i.tintColor = UIColor(named: "C4")
        return i
    }()
    
    let gradientView = GradientView()
    
    let expiryLabel: UILabel = {
        let l = UILabel()
        l.font = UIFont.systemFont(ofSize: 16, weight: .regular)
        l.translatesAutoresizingMaskIntoConstraints = false
        l.textColor = UIColor(named: "C4")?.withAlphaComponent(0.2)
        return l
    }()
    
    let cvvLabel: UILabel = {
        let l = UILabel()
        l.font = UIFont.systemFont(ofSize: 12, weight: .regular)
        l.translatesAutoresizingMaskIntoConstraints = false
        l.textColor = UIColor(named: "C4")?.withAlphaComponent(0.2)
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
    
    func configure(with card: Card) {
        setViewsVisibelity(for: card.cardType)
        mode = .light
        titleLabel.text = card.name
        if case .bank = card.cardType {
            bankTypeImageView.image = card.bankType.image
            expiryLabel.text = card.expiry
            numberLabel.text = card.cardNumber.inserting(separator: " ", every: 4)
            cvvLabel.text = "CVV: \(card.cvv)"
        } else {
            logoImageView.image = #imageLiteral(resourceName: "ShopCart")
            numberLabel.text = card.cardNumber
        }
    }
    
    private func setViewsVisibelity(for type: Card.CardType) {
        switch type {
        case .bank:
            cvvLabel.isHidden = false
            bankTypeImageView.isHidden = false
            expiryLabel.isHidden = false
            logoImageView.isHidden = true
            gradientView.topColor = UIColor(named: "CardC1") ?? .white
            gradientView.bottomColor = UIColor(named: "CardC2") ?? .white

        case .store:
            cvvLabel.isHidden = true
            bankTypeImageView.isHidden = true
            expiryLabel.isHidden = true
            logoImageView.isHidden = false
            gradientView.topColor = UIColor(named: "ShopCardC1") ?? .white
            gradientView.bottomColor = UIColor(named: "ShopCardC2") ?? .white
        }
    }
    
    private func setup() {
        backgroundColor = .clear
        addConstraints()
        addCornerRadius()
    }
    
    private func addConstraints() {
        contentView.addSubview(cardView)
        addGradient()
        cardView.addSubview(numberLabel)
        cardView.addSubview(titleLabel)
        cardView.addSubview(bankTypeImageView)
        cardView.addSubview(expiryLabel)
        cardView.addSubview(cvvLabel)
        cardView.addSubview(logoImageView)
        
        cardView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16).isActive = true
        cardView.topAnchor.constraint(equalTo: topAnchor, constant: 8).isActive = true
        cardView.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        cardView.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        
        numberLabel.leadingAnchor.constraint(equalTo: cardView.leadingAnchor, constant: 16).isActive = true
        numberLabel.centerXAnchor.constraint(equalTo: cardView.centerXAnchor).isActive = true
        numberLabel.centerYAnchor.constraint(equalTo: cardView.centerYAnchor, constant: -10).isActive = true
        
        expiryLabel.leadingAnchor.constraint(equalTo: numberLabel.leadingAnchor).isActive = true
        expiryLabel.topAnchor.constraint(equalTo: numberLabel.bottomAnchor, constant: 8).isActive = true
        
        cvvLabel.trailingAnchor.constraint(equalTo: cardView.trailingAnchor, constant: -16).isActive = true
        cvvLabel.centerYAnchor.constraint(equalTo: titleLabel.centerYAnchor).isActive = true
        
        titleLabel.leadingAnchor.constraint(equalTo: cardView.leadingAnchor, constant: 16).isActive = true
        titleLabel.centerXAnchor.constraint(equalTo: cardView.centerXAnchor).isActive = true
        titleLabel.bottomAnchor.constraint(equalTo: cardView.bottomAnchor, constant: -16).isActive = true
        
        bankTypeImageView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -32).isActive = true
        bankTypeImageView.topAnchor.constraint(equalTo: topAnchor, constant: 24).isActive = true
        bankTypeImageView.widthAnchor.constraint(equalToConstant: 70).isActive = true
        bankTypeImageView.heightAnchor.constraint(equalToConstant: 50).isActive = true
        
        logoImageView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -32).isActive = true
        logoImageView.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        logoImageView.widthAnchor.constraint(equalToConstant: 70).isActive = true
        logoImageView.heightAnchor.constraint(equalToConstant: 70).isActive = true
        
    }
    
    private func addCornerRadius() {
        cardView.layer.cornerRadius = 8
        cardView.clipsToBounds = true
    }
}

extension CardCell {
    private func addGradient() {
        gradientView.translatesAutoresizingMaskIntoConstraints = false
        cardView.insertSubview(gradientView, aboveSubview: cardView)
        gradientView.fillSuperview()
    }
}
