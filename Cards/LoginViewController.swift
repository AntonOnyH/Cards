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

    override func viewDidLoad() {
        super.viewDidLoad()
        title = NSLocalizedString("Auth", comment: "")
        navigationController?.navigationBar.prefersLargeTitles = true

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
    
    
}
