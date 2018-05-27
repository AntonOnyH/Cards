//
//  CardManager.swift
//  Cards
//
//  Created by Hugo Prinsloo on 2018/05/11.
//  Copyright © 2018 Hugo. All rights reserved.
//

import Foundation
import SwiftKeychainWrapper
import Mixpanel

enum CardType {
    case store
    case bank
}

protocol CardService {
    func numberOfCards() -> Int
    func cardAtIndex(_ index: Int) -> Card
    func addCard(_ card: Card, completion: () -> Void)
    func deleteCardAtIndex(_ index: Int, completion: () -> Void)
}


struct Card: Codable {
    let name: String
    let cardNumber: String
    let expiry: String
    let cvv: String
    let bankType: BankType
    let cardTheme: CardTheme
    let logo: String
    let cardType: CardType
    
    enum CardType: Int, Codable {
        case bank, store
    }
}


class CardManager: CardService {
    
    private var cards: [Card] = []
    
    var type: Card.CardType = .bank
    
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
        let c = cards.filter({ $0.cardType == type })
        return c.count
    }
    
    func cardAtIndex(_ index: Int) -> Card {
        let c = cards.filter({ $0.cardType == type })
        return c[index]
    }
    
    func addCard(_ card: Card, completion: () -> Void) {
        cards.append(card)
        saveCardsToKeychain {
            completion()
        }

    }
    
     func deleteCardAtIndex(_ index: Int, completion: () -> Void) {
        cards.remove(at: index)
        deleteCard {
            saveCardsToKeychain(completion: {
                completion()
            })
        }
    }
    
    private func saveCardsToKeychain(completion: () -> Void) {
        let encoder = JSONEncoder()
        encoder.outputFormatting = .prettyPrinted
        let jsonData = try! encoder.encode(cards)
        let saveSuccessful: Bool = KeychainWrapper.standard.set(jsonData, forKey: "Cards")
        
        if saveSuccessful {
            completion()
            Mixpanel.sharedInstance()?.track("Card added")
        } else {
            print("Failed to save cards")
        }
    }
    
    private func deleteCard(completion: () -> Void) {
        let removedSuccess = KeychainWrapper.standard.removeObject(forKey: "Cards")
        if removedSuccess {
            completion()
        }
    }
    
}
