//
//  CardManager.swift
//  Cards
//
//  Created by Hugo Prinsloo on 2018/05/11.
//  Copyright © 2018 Hugo. All rights reserved.
//

import Foundation
import SwiftKeychainWrapper

enum CardType {
    case store
    case bank
}

protocol CardProvider {
    func numberOfCards() -> Int
    func cardAt(_ index: Int) -> CardTheme
}


struct Card: Codable {
    let name: String
    let cardNumber: String
    let expiry: String
    let cvv: String
    
    let cardType: CardType
    
    enum CardType: Int, Codable {
        case bank, store
    }
}

struct CardManager {
    var cards: [Card] = []
    
    func addCard(_ card: Card) {
        let encoder = JSONEncoder()
        encoder.outputFormatting = .prettyPrinted
        let jsonData = try! encoder.encode(card)
        let cardToStore = String(data: jsonData, encoding: .utf8)
        
        let saveSuccessful: Bool = KeychainWrapper.standard.set(jsonData, forKey: "Card")
        
        if saveSuccessful {
            print("Success")
        }
        
    }
    
}


//let c = [Card(name: "foo", cardNumber: "123", cardType: .bank), Card(name: "Fred", cardNumber: "123345", cardType: .store)]
//
//let encoder = JSONEncoder()
//encoder.outputFormatting = .prettyPrinted
//let jsonData = try! encoder.encode(c)
//let s = String(data: jsonData, encoding: .utf8)
//
//let cards:[Card] = try! JSONDecoder().decode([Card].self, from: s!.data(using: .utf8)!)
//cards.count
