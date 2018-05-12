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

