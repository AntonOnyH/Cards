//
//  NewCardViewController.swift
//  Cards
//
//  Created by Hugo Prinsloo on 2018/05/09.
//  Copyright © 2018 Hugo. All rights reserved.
//

import UIKit

class NewCardViewController: UIViewController {
    

    @IBOutlet weak var segmentControl: UISegmentedControl!
    @IBOutlet weak var cardNumberTextField: UITextField!
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var expiryDateTextField: UITextField!
    @IBOutlet weak var cvcTextField: UITextField!
    @IBOutlet weak var stackView: UIStackView!

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
        // Save card
        dismiss(animated: true)
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
