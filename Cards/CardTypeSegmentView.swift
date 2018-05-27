//
//  CardTypeSegmentView.swift
//  Cards
//
//  Created by Hugo Prinsloo on 2018/05/27.
//  Copyright © 2018 Hugo. All rights reserved.
//

import UIKit

protocol CardTypeSegmentViewDelegate: class {
    func cardTypeSegmentView(_ cardTypeSegmentView: CardTypeSegmentView, didChangeCardType type: Card.CardType)
}

class CardTypeSegmentView: UIView {
    
    private let segment: UISegmentedControl = {
        let s = UISegmentedControl(items: ["Bank", "Store"])
        s.translatesAutoresizingMaskIntoConstraints = false
        return s
    }()
    
    weak var delegate: CardTypeSegmentViewDelegate?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSegment()
        segment.selectedSegmentIndex = 0
        segment.tintColor = UIColor(named: "C4") ?? .white
        backgroundColor = UIColor(named: "SegmentBackgroundColor") ?? .red
    
        segment.layer.borderColor = UIColor(named: "SegmentBackgroundColor")?.cgColor ?? UIColor.red.cgColor
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func addSegment() {
        addSubview(segment)
        segment.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16).isActive = true
        segment.topAnchor.constraint(equalTo: topAnchor, constant: 4).isActive = true
        segment.centerXAnchor.constraint(equalTo: centerXAnchor, constant: 0).isActive = true
        segment.centerYAnchor.constraint(equalTo: centerYAnchor, constant: 0).isActive = true
        
        segment.addTarget(self, action: #selector(handleSegmentChanged(_:)), for: .valueChanged)
        
        
    }
    
    @objc private func handleSegmentChanged(_ sender: UISegmentedControl) {

        let value: Card.CardType = sender.selectedSegmentIndex == 0 ? .bank : .store
        delegate?.cardTypeSegmentView(self, didChangeCardType: value)
    }
}

