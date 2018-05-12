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

protocol CardService {
    func numberOfCards() -> Int
    func cardAtIndex(_ index: Int) -> Card
    func addCard(_ card: Card, completion: () -> Void)
     func deleteCardAtIndex(_ index: Int) 
}


struct Card: Codable {
    let name: String
    let cardNumber: String
    let expiry: String
    let cvv: String
    let bankType: BankType
    let cardTheme: CardTheme
    
    let cardType: CardType
    
    enum CardType: Int, Codable {
        case bank, store
    }
}

class CardManager: CardService {
    
    private var cards: [Card] = []
    
    func fetch() {
        guard let newCardsData = KeychainWrapper.standard.data(forKey: "Cards") else { return }
        
        do {
            // Decode data to object
            let jsonDecoder = JSONDecoder()
            let cards = try jsonDecoder.decode([Card].self, from: newCardsData)
            self.cards = cards
            print("Fetched success")
        }
        catch {
            print("Fetch failed")
        }
    }
    
    func numberOfCards() -> Int {
        return cards.count
    }
    
    func cardAtIndex(_ index: Int) -> Card {
        return cards[index]
    }
    
    func addCard(_ card: Card, completion: () -> Void) {
        cards.append(card)
        saveCardsToKeychain {
            completion()
        }

    }
    
     func deleteCardAtIndex(_ index: Int) {
        cards.remove(at: index)
    }
    
    private func saveCardsToKeychain(completion: () -> Void) {
        let encoder = JSONEncoder()
        encoder.outputFormatting = .prettyPrinted
        let jsonData = try! encoder.encode(cards)
        let saveSuccessful: Bool = KeychainWrapper.standard.set(jsonData, forKey: "Cards")
        
        if saveSuccessful {
            completion()
        } else {
            print("Failed to save cards")
        }
    }
    
}



//struct CardManager {
//    var cards: [Card] = []
//
//
//    func addCard(_ card: Card) {
//        let encoder = JSONEncoder()
//        encoder.outputFormatting = .prettyPrinted
//        let jsonData = try! encoder.encode(card)
//        let saveSuccessful: Bool = KeychainWrapper.standard.set(jsonData, forKey: "Card")
//
//        if saveSuccessful {
//            print("Success")
//        }
//
//    }
//
//}


//let c = [Card(name: "foo", cardNumber: "123", cardType: .bank), Card(name: "Fred", cardNumber: "123345", cardType: .store)]
//
//let encoder = JSONEncoder()
//encoder.outputFormatting = .prettyPrinted
//let jsonData = try! encoder.encode(c)
//let s = String(data: jsonData, encoding: .utf8)
//
//let cards:[Card] = try! JSONDecoder().decode([Card].self, from: s!.data(using: .utf8)!)
//cards.count
