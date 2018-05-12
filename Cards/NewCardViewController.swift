//
//  NewCardViewController.swift
//  Cards
//
//  Created by Hugo Prinsloo on 2018/05/09.
//  Copyright © 2018 Hugo. All rights reserved.
//

import UIKit

enum Mode {
    case light
    case dark
}

enum BankType: Int, Codable {
    case visa
    case masterCard
    
    var image: UIImage {
        switch self {
        case .visa:
            return #imageLiteral(resourceName: "visa logo")
        case .masterCard:
            return #imageLiteral(resourceName: "masterCard logo")
        }
    }
}

enum CardTheme: Int, Codable {
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


class NewCardViewController: UIViewController {
    
    @IBOutlet weak var bankTypeSegment: UISegmentedControl!
    @IBOutlet weak var segmentControl: UISegmentedControl!
    @IBOutlet weak var cardNumberTextField: UITextField!
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var expiryDateTextField: UITextField!
    @IBOutlet weak var cvcTextField: UITextField!
    @IBOutlet weak var stackView: UIStackView!
    
    var cardManager: CardManager?

    override func viewDidLoad() {
        super.viewDidLoad()
        nameTextField.delegate = self
        cardNumberTextField.delegate = self
        expiryDateTextField.delegate = self
        expiryDateTextField.delegate = self
        cvcTextField.delegate = self
    }

    @IBAction func handleSegmentChanged(_ sender: UISegmentedControl) {
        let type: CardType = sender.selectedSegmentIndex == 0 ? .bank : .store
        showFields(for: type)
    }
    
    @IBAction func handleSaveButtonTapped(_ sender: UIButton) {
        
        let c = Card(name: nameTextField.text!, cardNumber: cardNumberTextField.text!, expiry: expiryDateTextField.text!, cvv: cvcTextField.text!, bankType: bankType(), cardTheme: .pearl, cardType: .bank)
        cardManager?.addCard(c, completion: {
            dismiss(animated: true)
            
        })
    }
    
    private func bankType() -> BankType {
        let selectedItem = bankTypeSegment.selectedSegmentIndex
        let types: [BankType] = [.visa, .masterCard]
        return types[selectedItem]
    }
    
    private func showFields(for type: CardType) {
        switch type {
        case .bank:
            nameTextField.isHidden = false
            expiryDateTextField.isHidden = false
            cvcTextField.isHidden = false
        case .store:
            nameTextField.isHidden = true
            expiryDateTextField.isHidden = true
            cvcTextField.isHidden = true
        }
    }
}

extension NewCardViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}
