//
//  SmartAuthManager.swift
//  Cards
//
//  Created by Hugo Prinsloo on 2018/07/11.
//  Copyright © 2018 Hugo. All rights reserved.
//

import Foundation
import LocalAuthentication

class SmartAuthManager {
    
    enum State {
        case success
        case failed
        case unavailable
    }
    
    var shouldUseSmartAuth: Bool {
        return UserDefaults.standard.bool(forKey: "shouldUseSmartAuth")
    }
    
    func requestSmartAuth(completion: @escaping (_ state: State) -> Void) {
        UserDefaults.standard.register(defaults: ["shouldUseSmartAuth" : true])
        guard shouldUseSmartAuth else { return }
        let context = LAContext()
        var error: NSError?
        if context.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: &error) {
            let reason = "Identify yourself!"
            context.evaluatePolicy(LAPolicy.deviceOwnerAuthenticationWithBiometrics, localizedReason: reason) { [weak self] (success, error) in
                if success {
                    self?.setShouldUseSmartAuth(true)
                    completion(.success)
                } else {
                    completion(.failed)
                }
            }
        } else {
            completion(.unavailable)
        }
    }
    
    func setShouldUseSmartAuth(_ on: Bool) {
        UserDefaults.standard.set(on, forKey: "shouldUseSmartAuth")
    }
}
