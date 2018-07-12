//
//  LoginViewController.swift
//  Cards
//
//  Created by Hugo Prinsloo on 2018/05/07.
//  Copyright © 2018 Hugo. All rights reserved.
//

import UIKit
import SwiftKeychainWrapper
import LocalAuthentication
import Mixpanel

class LoginViewController: UIViewController {
    
    private enum Session {
        case newUser
        case existingUser
    }
    
    private var passcode: String = "" {
        didSet {
            print("Count \(passcode.count)")
            if passcode.count < 5 && passcode.count != 0 {
                dots[passcode.count - 1].alpha = 1
            }
            if passcode.count == 4 {
                auth()
            }
        }
    }
    private let smartAuthManager = SmartAuthManager()
    private var registerKey: String?
    
    private var isRegistered: Bool {
        return currentUserInfo() != nil
    }
    
    private var currentSession: Session = .newUser {
        didSet {
            style()
        }
    }
    
    @IBOutlet weak var dotOne: UIImageView!
    @IBOutlet weak var dotTwo: UIImageView!
    @IBOutlet weak var dotThree: UIImageView!
    @IBOutlet weak var dotFour: UIImageView!
    @IBOutlet weak var oneButton: UIButton!
    @IBOutlet weak var twoButton: UIButton!
    @IBOutlet weak var threeButton: UIButton!
    @IBOutlet weak var fourButton: UIButton!
    @IBOutlet weak var fiveButton: UIButton!
    @IBOutlet weak var sixButton: UIButton!
    @IBOutlet weak var sevenButton: UIButton!
    @IBOutlet weak var eightButton: UIButton!
    @IBOutlet weak var nineButton: UIButton!
    @IBOutlet weak var zeroButton: UIButton!
    @IBOutlet weak var biometricButton: UIButton!
    @IBOutlet weak var resetButton: UIButton!
    private var dots: [UIImageView] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setBackgroundColor()
    
        navigationController?.navigationBar.prefersLargeTitles = true
        dots = [dotOne, dotTwo, dotThree, dotFour]
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        auth()
    }
    

    @IBAction func handleLoginButtonTapped(_ sender: UIButton) {
        promptForSmartAuth()
    }
    
    private func showCardsViewController() {
        guard let vc = storyboard?.instantiateViewController(withIdentifier: "CardViewController") else { return }
        navigationController?.pushViewController(vc, animated: true)
    }
    
    private func auth() {
        if isRegistered {
            currentSession = .existingUser
            validatePasscode()
            
        } else {
            currentSession = .newUser
            registerAttempt()
        }
    }
    
    private func validatePasscode() {
        if passcode.isEmpty {
            promptForSmartAuth()
            return
        }
        if passcode == currentUserInfo() {
            showCardsViewController()
        } else {
            let alert = UIAlertController(title: NSLocalizedString("Incorrect password", comment: ""), message: "", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: NSLocalizedString("Try again", comment: ""), style: .default, handler: { [weak self] _ in
                self?.resetPassItems()
                alert.dismiss(animated: true)
            }))
            
            present(alert, animated: true)
        }
    }
    
    private func registerAttempt() {
        guard !passcode.isEmpty else { return }
        if registerKey == nil {
            registerKey = passcode
            title = NSLocalizedString("Repeat", comment: "")
            resetPassItems()
        } else {
            if registerKey == passcode {
                setUserInfo()
            }
        }
    }
    
    private func currentUserInfo() -> String? {
        return KeychainWrapper.standard.string(forKey: "userInfoCardPrivate")
    }
    
    private func setUserInfo() {
        let savedUserInfo = KeychainWrapper.standard.set(passcode, forKey: "userInfoCardPrivate")
        if savedUserInfo {
            showCardsViewController()
        } else {
            print("Failed to register user")
            Mixpanel.sharedInstance()?.track("Failed to register user")
            //present failure screen
        }
    }
    
    
    private func resetPassItems() {
        for dot in dots {
            dot.alpha = 0.4
        }
        passcode = ""
    }
    
    func promptForSmartAuth() {
        smartAuthManager.requestSmartAuth { [weak self] state in
            switch state {
            case .success:
                DispatchQueue.main.async {
                    self?.showCardsViewController()
                }
            case .failed:
                break
            case .unavailable:
                break
            }
        }
    }
    
    private func style() {
        biometricButton.tintColor = UIColor.cardsTintColor
        switch currentSession {
        case .existingUser:
            title = NSLocalizedString("Login", comment: "")
        case .newUser:
            title = NSLocalizedString("Register", comment: "")
            hideSmartAuthButton()
        }
        resetButton.alpha = 0
        if !smartAuthManager.smartAuthIsActive {
            hideSmartAuthButton()
        }
    }
    
    private func hideSmartAuthButton() {
        biometricButton.isEnabled = false
        biometricButton.alpha = 0
    }
    
    private func add(_ number: String?) {
        guard let num = number else {
            return
        }
        passcode = passcode + num
    }
    
    @IBAction func handleNumberButtonTapped(_ sender: UIButton) {
        add(sender.titleLabel?.text)
    }

}

extension LoginViewController {
    
    
}
