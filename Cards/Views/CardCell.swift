//
//  CardCell.swift
//  Cards
//
//  Created by Hugo Prinsloo on 2018/05/12.
//  Copyright © 2018 Hugo. All rights reserved.
//

import Foundation
import UIKit

protocol CardCellDelegate: class {
    func cardCelldidRequestAddPersonalName(for card: Card?)
}

class CardCell: UITableViewCell {
    
    var mode: Mode = .light {
        didSet {
            switch mode {
            case .light:
                numberLabel.textColor = UIColor.CardColor.pearlWhite
                titleLabel.textColor = UIColor.CardColor.pearlWhite
                expiryLabel.textColor = UIColor.CardColor.pearlWhite.withAlphaComponent(0.5)
                cvvLabel.textColor = UIColor.CardColor.pearlWhite.withAlphaComponent(0.5)
            case .dark:
                cvvLabel.textColor = .darkGray
                expiryLabel.textColor = .darkGray
                numberLabel.textColor = .darkGray
                titleLabel.textColor = .darkGray
            }
        }
    }
    
    weak var delegate: CardCellDelegate?
    
    var showPattern: Bool? {
        didSet {
            guard let show = showPattern else { return }
            let a: CGFloat = show ? 0.1 : 0
            patternImageView.alpha = a
        }
    }
    
    private let logoImageView: UIImageView = {
        let i = UIImageView()
        i.translatesAutoresizingMaskIntoConstraints = false
        i.contentMode = .scaleAspectFit
        i.tintColor = UIColor.CardColor.pearlWhite
        return i
    }()
    
    private let patternImageView: UIImageView = {
        let i = UIImageView()
        i.translatesAutoresizingMaskIntoConstraints = false
        i.contentMode = .scaleAspectFill
        i.tintColor = .black
        i.alpha = 0.2
        return i
    }()

    
    private let cardView: UIView = {
        let i = UIView()
        i.translatesAutoresizingMaskIntoConstraints = false
        i.contentMode = .scaleAspectFit
        i.layer.cornerRadius = 8
        i.clipsToBounds = true
        return i
    }()
    
    private let bankTypeImageView: UIImageView = {
        let i = UIImageView()
        i.translatesAutoresizingMaskIntoConstraints = false
        i.contentMode = .scaleAspectFit
        i.tintColor = UIColor.CardColor.pearlWhite
        return i
    }()
    
    private let gradientView = GradientView()
    
    private let expiryLabel: UILabel = {
        let l = UILabel()
        l.font = UIFont.systemFont(ofSize: 14, weight: .medium)
        l.translatesAutoresizingMaskIntoConstraints = false
        l.textColor = UIColor.CardColor.pearlWhite.withAlphaComponent(0.2)
        l.textAlignment = .right
        return l
    }()
    
    private let cvvLabel: UILabel = {
        let l = UILabel()
        l.font = UIFont.systemFont(ofSize: 14, weight: .medium)
        l.translatesAutoresizingMaskIntoConstraints = false
        l.textColor = UIColor.CardColor.pearlWhite.withAlphaComponent(0.2)
        return l
    }()
    
    
    //TODO: Make provate
     let numberLabel: UILabel = {
        let l = UILabel()
        l.font = UIFont.systemFont(ofSize: 24, weight: .medium)
        l.translatesAutoresizingMaskIntoConstraints = false
        l.textColor = UIColor.white.withAlphaComponent(0.5)
        return l
    }()
    
    
    private let titleLabel: UILabel = {
        let l = UILabel()
        l.translatesAutoresizingMaskIntoConstraints = false
        l.textColor = .white
        l.font = UIFont.boldSystemFont(ofSize: 21)
        l.numberOfLines = 3
        return l
    }()
    
    private let customNameLabel: CardNameLabel = {
        let nL = CardNameLabel()
        nL.translatesAutoresizingMaskIntoConstraints = false
        nL.backgroundColor = UIColor(white: 155/255, alpha: 0.6)
        nL.font = UIFont.systemFont(ofSize: 12, weight: .light)
        nL.textColor = UIColor.CardColor.pearlWhite.withAlphaComponent(0.5)
        nL.textAlignment = .right
        nL.text = "CardNameLabel"
        nL.layer.cornerRadius = 4
        nL.clipsToBounds = true
        return nL

    }()
    
    private var card: Card?
    
    func configure(with card: Card) {
        self.card = card
        setupCustomNameLabel()
        setViewsVisibelity(for: card.cardType)
        mode = .light
        titleLabel.text = card.name
        if case .bank = card.cardType {
            bankTypeImageView.image = card.bankType.image
            expiryLabel.text = "Valid Thru: \(card.expiry)"
            numberLabel.text = card.cardNumber.inserting(separator: " ", every: 4)
            cvvLabel.text = "\(card.cvv)"
        } else {
            logoImageView.image = #imageLiteral(resourceName: "ShopCart")
            numberLabel.text = card.cardNumber
        }
    }
    
    private func setupCustomNameLabel() {
        guard let card = card, let customName = card.personalName else { return }
        if customName.isEmpty {
            customNameLabel.text = NSLocalizedString("Add personal name", comment: "")
        } else {
            customNameLabel.text = customName
        }
    }

    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }
    
    private func setup() {
        customNameLabel.isUserInteractionEnabled = true
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleCustomLabelTapped))
        customNameLabel.addGestureRecognizer(tapGesture)
        
        backgroundColor = .clear
        addConstraints()
        addCornerRadius()
        
        patternImageView.image = #imageLiteral(resourceName: "Pattern1")
    }
    
    @objc func handleCustomLabelTapped() {
        delegate?.cardCelldidRequestAddPersonalName(for: self.card)
    }
    
    private func setViewsVisibelity(for type: Card.CardType) {
        switch type {
        case .bank:
            cvvLabel.isHidden = false
            bankTypeImageView.isHidden = false
            expiryLabel.isHidden = false
            logoImageView.isHidden = true
            gradientView.topColor = UIColor.GradiantColor.gradLight
            gradientView.bottomColor = UIColor.GradiantColor.gradDark
        case .store:
            cvvLabel.isHidden = true
            bankTypeImageView.isHidden = true
            expiryLabel.isHidden = true
            logoImageView.isHidden = false
            gradientView.topColor = UIColor.CardColor.blue
            gradientView.bottomColor = UIColor.CardColor.navy
        }
    }
    
    private func addConstraints() {
        contentView.addSubview(cardView)
        addGradient()
        cardView.addSubview(patternImageView)
        cardView.addSubview(numberLabel)
        cardView.addSubview(titleLabel)
        cardView.addSubview(bankTypeImageView)
        cardView.addSubview(expiryLabel)
        cardView.addSubview(cvvLabel)
        cardView.addSubview(logoImageView)
        cardView.addSubview(customNameLabel)
        patternImageView.fillSuperview()
        
        
        cardView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16).isActive = true
        cardView.topAnchor.constraint(equalTo: topAnchor, constant: 8).isActive = true
        cardView.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        cardView.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        
        numberLabel.leadingAnchor.constraint(equalTo: cardView.leadingAnchor, constant: 16).isActive = true
        numberLabel.trailingAnchor.constraint(lessThanOrEqualTo: cardView.trailingAnchor, constant: -8).isActive = true
        numberLabel.centerYAnchor.constraint(equalTo: cardView.centerYAnchor, constant: -10).isActive = true
        
        cvvLabel.leadingAnchor.constraint(equalTo: numberLabel.leadingAnchor).isActive = true
        cvvLabel.topAnchor.constraint(equalTo: numberLabel.bottomAnchor, constant: 8).isActive = true
        
        expiryLabel.trailingAnchor.constraint(equalTo: numberLabel.trailingAnchor).isActive = true
        expiryLabel.centerYAnchor.constraint(equalTo: cvvLabel.centerYAnchor).isActive = true
        
        titleLabel.leadingAnchor.constraint(equalTo: cardView.leadingAnchor, constant: 16).isActive = true
        titleLabel.bottomAnchor.constraint(equalTo: cardView.bottomAnchor, constant: -16).isActive = true
        titleLabel.trailingAnchor.constraint(equalTo: logoImageView.leadingAnchor).isActive = true
        
        bankTypeImageView.trailingAnchor.constraint(equalTo: cardView.trailingAnchor, constant: -12).isActive = true
        bankTypeImageView.bottomAnchor.constraint(equalTo: cardView.bottomAnchor, constant: -12).isActive = true
        bankTypeImageView.widthAnchor.constraint(equalToConstant: 70).isActive = true
        bankTypeImageView.heightAnchor.constraint(equalToConstant: 30).isActive = true
        
        logoImageView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -32).isActive = true
        logoImageView.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        logoImageView.widthAnchor.constraint(equalToConstant: 70).isActive = true
        logoImageView.heightAnchor.constraint(equalToConstant: 70).isActive = true
        
        customNameLabel.trailingAnchor.constraint(equalTo: cardView.trailingAnchor, constant: -10).isActive = true
        customNameLabel.topAnchor.constraint(equalTo: cardView.topAnchor, constant: 10).isActive = true
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

private extension Array {
    func randomItem() -> Element? {
        if isEmpty { return nil }
        let index = Int(arc4random_uniform(UInt32(self.count)))
        return self[index]
    }
}

class CardNameLabel: UILabel {
    private var topInset: CGFloat = 2.0
    private var bottomInset: CGFloat = 2.0
    private var leftInset: CGFloat = 5.0
    private var rightInset: CGFloat = 5.0
    
    override func drawText(in rect: CGRect) {
        let insets = UIEdgeInsets(top: topInset, left: leftInset, bottom: bottomInset, right: rightInset)
        super.drawText(in: UIEdgeInsetsInsetRect(rect, insets))
    }
    
    override var intrinsicContentSize: CGSize {
        get {
            var contentSize = super.intrinsicContentSize
            contentSize.height += topInset + bottomInset
            contentSize.width += leftInset + rightInset
            return contentSize
        }
    }
}
