//
//  NewCardViewController.swift
//  Cards
//
//  Created by Hugo Prinsloo on 2018/05/09.
//  Copyright © 2018 Hugo. All rights reserved.
//

import UIKit

 protocol NewCardDelegate{
    
    func didAddCard(type: Card.CardType)
    
}

enum Mode {
    case light
    case dark
}

enum BankType: Int, Codable {
    case visa
    case masterCard
    case unknown
    
    var image: UIImage {
        switch self {
        case .visa:
            return #imageLiteral(resourceName: "visa logo 1.1")
        case .masterCard:
            return #imageLiteral(resourceName: "masterCard logo 1.1")
        case .unknown:
            return UIImage()
        }
    }
}

enum CardTheme: Int, Codable {
    case black
    case gray
    case criene
    case pearl
    case yolo
    case alpha
    
    var color: UIColor {
        switch self {
        case .black:
            return UIColor.CardColor.black
        case .gray:
            return UIColor.CardColor.darkGray
        case .criene:
            return UIColor.CardColor.criene
        case .pearl:
            return UIColor.CardColor.pearlWhite
        case .yolo:
            return UIColor.CardColor.yoloYellow
        case .alpha:
            return UIColor.CardColor.black
        }
    }
    
    var mode: Mode {
        switch self {
        case .black, .gray, .criene, .alpha:
            return .dark
        case .pearl, .yolo:
            return .light
        }
    }
}


class NewCardViewController: UIViewController {
    
    @IBOutlet weak var saveButton: UIButton!
    @IBOutlet weak var logoImageView: UIImageView!
    @IBOutlet weak var segmentControl: UISegmentedControl!
    @IBOutlet weak var cardNumberTextField: UITextField!
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var expiryDateTextField: UITextField!
    @IBOutlet weak var cvcTextField: UITextField!
    @IBOutlet weak var stackView: UIStackView!
    
    var cardManager: CardManager?
    var newCardDelegate: NewCardDelegate?

    override func viewDidLoad() {
        super.viewDidLoad()
        setBackgroundColor()
        
        nameTextField.delegate = self
        cardNumberTextField.delegate = self
        expiryDateTextField.delegate = self
        expiryDateTextField.delegate = self
        cvcTextField.delegate = self
        
        showFields(for: .bank)
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(handleLogoImageViewTapped))
        logoImageView.isUserInteractionEnabled = true
        logoImageView.addGestureRecognizer(tap)
        
        configureNavigationBar()
        style()
    }
    
    private func configureNavigationBar() {
        title = NSLocalizedString("New card", comment: "")
        navigationController?.navigationBar.tintColor = .white
        navigationController?.navigationBar.barStyle = .black
        navigationController?.navigationBar.barTintColor = UIColor.BackgroundColor.extraDark
        navigationController?.navigationBar.isTranslucent = false
        
        let button = UIButton()
        button.tintColor = .gray
        button.setImage(#imageLiteral(resourceName: "closeIcon"), for: .normal)
        button.imageView?.contentMode = .scaleAspectFit
        button.addTarget(self, action: #selector(handleDismissButtonTapperd), for: .touchUpInside)
        let barItem = UIBarButtonItem(customView: button)
        barItem.customView?.widthAnchor.constraint(equalToConstant: 22).isActive = true
        barItem.customView?.heightAnchor.constraint(equalToConstant: 22).isActive = true
        
        navigationItem.leftBarButtonItem = barItem
    }

    private func style() {
        saveButton.layer.cornerRadius = 8
    }
    
    @objc private func handleDismissButtonTapperd() {
        navigationController?.dismiss(animated: true)
    }


    @IBAction func handleSegmentChanged(_ sender: UISegmentedControl) {
        let type: CardType = sender.selectedSegmentIndex == 0 ? .bank : .store
        showFields(for: type)
    }
    
    @IBAction func handleSaveButtonTapped(_ sender: UIButton) {
        var logo: String? = nil
        if case .store = cardType() {
            logo = logoImageView.image!.asString()
        }
        let c = Card(name: nameTextField.text!, cardNumber: cardNumberTextField.text!, expiry: expiryDateTextField.text!, cvv: cvcTextField.text!, bankType: bankType(), cardTheme: .alpha, logo: logo ?? "", cardType: cardType())
        cardManager?.addCard(c, completion: {
            newCardDelegate?.didAddCard(type: cardType())
            dismiss(animated: true)
        })
    }
    
    private func cardType() -> Card.CardType {
        let selectedItem = segmentControl.selectedSegmentIndex
        let types: [Card.CardType] = [.bank, .store]
        return types[selectedItem]
    }
    
    private func bankType() -> BankType {
        let firstChar = Array(cardNumberTextField.text ?? "")[0]
        if firstChar == "5" {
            return .masterCard
        }
        if firstChar == "4" {
            return .visa
        }
        return .unknown
    }
    
    private func showFields(for type: CardType) {
        switch type {
        case .bank:
            logoImageView.isHidden = true
            nameTextField.isHidden = false
            expiryDateTextField.isHidden = false
            cvcTextField.isHidden = false
        case .store:
            logoImageView.isHidden = true
            nameTextField.isHidden = false
            expiryDateTextField.isHidden = true
            cvcTextField.isHidden = true
        }
    }
    
    @objc func handleLogoImageViewTapped() {
        presentImagePicker()
    }
    
    private func presentImagePicker() {
        if UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.photoLibrary){
            let imagePicker = UIImagePickerController()
            imagePicker.delegate = self
            imagePicker.allowsEditing = true
            imagePicker.sourceType = UIImagePickerControllerSourceType.photoLibrary
            self.present(imagePicker, animated: true, completion: nil)
        }
    }
}

extension NewCardViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        if let pickedImage = info[UIImagePickerControllerOriginalImage] as? UIImage {
            logoImageView.image = pickedImage
        }
        picker.dismiss(animated: true, completion: nil)
    }
}

extension NewCardViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == expiryDateTextField {
           return cvcTextField.becomeFirstResponder()
        }
        textField.resignFirstResponder()
        return true
    }
}


