//
//  LoginViewController.swift
//  Cards
//
//  Created by Hugo Prinsloo on 2018/05/07.
//  Copyright © 2018 Hugo. All rights reserved.
//

import UIKit
import LocalAuthentication

class LoginViewController: UIViewController {
    
    private var passCode: [Int] = [] {
        didSet {
            if passCode.count < 5 {
                dots[passCode.count - 1].alpha = 1
            }
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
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setBackgroundColor()
        title = NSLocalizedString("Cards", comment: "")
        navigationController?.navigationBar.prefersLargeTitles = true
        
        dots = [dotOne, dotTwo, dotThree, dotFour]
        handleID()
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
    
    private func add(_ number: Int) {
        passCode.append(number)
    }
    
    
    
}

extension LoginViewController {
    
    @IBAction func handleNumberOneButtonTapped(_ sender: UIButton) {
        add(1)
    }
    
    @IBAction func handleNumberTwoButtonTapped(_ sender: UIButton) {
        add(2)
    }
    
    @IBAction func handleNumberThreeButtonTapped(_ sender: UIButton) {
        add(3)

    }
    
    @IBAction func handleNumberFourButtonTapped(_ sender: UIButton) {
        add(4)

    }
    
    @IBAction func handleNumberFiveButtonTapped(_ sender: UIButton) {
        add(5)

    }
    
    @IBAction func handleNumberSixButtonTapped(_ sender: UIButton) {
        add(6)

    }
    
    @IBAction func handleNumberSevenButtonTapped(_ sender: UIButton) {
        add(7)

    }
    
    @IBAction func handleNumberEightButtonTapped(_ sender: UIButton) {
        add(8)

    }
    
    @IBAction func handleNumberNineButtonTapped(_ sender: UIButton) {
        add(9)

    }
    
    @IBAction func handleNumberZeroButtonTapped(_ sender: UIButton) {
        add(0)
    }
    
}
