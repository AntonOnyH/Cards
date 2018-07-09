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
    
    
    
    
    
    private var registerKey: String?
    
    private func auth() {
        if isRegistered {
            currentSession = .existingUser
            handleID()
            if passcode == currentUserInfo() {
                showCardsViewController()
            } else {
                // Wrong password
            }
        } else {
            currentSession = .newUser
            registerAttempt()
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
    
    private func resetPassItems() {
        for dot in dots {
            dot.alpha = 0.4
        }
        passcode = ""
    }
    
    private var isRegistered: Bool {
        return currentUserInfo() != nil
    }
    
    private var currentSession: Session = .newUser {
        didSet {
            style()
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

    @IBOutlet weak var dotOne: UIImageView!
    @IBOutlet weak var dotTwo: UIImageView!
    @IBOutlet weak var dotThree: UIImageView!
    @IBOutlet weak var dotFour: UIImageView!
    
    private var dots: [UIImageView] = []

    
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
        handleID()
    }
    
    private func showCardsViewController() {
        guard let vc = storyboard?.instantiateViewController(withIdentifier: "CardViewController") else { return }
        navigationController?.pushViewController(vc, animated: true)
    }
    
    
    
    func handleID() {
        let context = LAContext()
        var error: NSError?
        if context.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: &error) {
            let reason = "Identify yourself!"
            
            context.evaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, localizedReason: reason) {
                [unowned self] (success, authenticationError) in
                
                DispatchQueue.main.async {
                    if success {
                        self.showCardsViewController()
                    } else {
                        // error
                    }
                }
            }
        } else {
            // no biometry
        }
    }
    
    private func style() {
        switch currentSession {
        case .existingUser:
            title = NSLocalizedString("Login", comment: "")
        case .newUser:
            title = NSLocalizedString("Register", comment: "")
        }
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
