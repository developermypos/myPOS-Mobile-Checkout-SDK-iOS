//
//  UserDefaults+Helpers.swift
//  Mobile Payment Test
//
//  Created by Valio Cholakov on 1/16/17.
//  Copyright © 2017 Intercard Finance AD. All rights reserved.
//

import UIKit

extension UserDefaults {
    
    // MARK: Cards
    
    static func cards() -> [ICCard]? {
        guard let cardsData = UserDefaults.standard.data(forKey: ICConstants.cards) else {
            return nil
        }
        
        return self.unarchivedCards(cardsData)
    }
    
    static func addCard(_ card: ICCard) {
        var cards = [card]
        
        if let oldCards = self.cards() {
            cards.append(contentsOf: oldCards)
        }
        
        self.saveCards(cards)
    }
    
    static func deleteCard(_ card: ICCard) {
        var cards = self.cards() ?? []
        
        if let oldCardIndex = cards.index(where: { (oldCard) -> Bool in
            return oldCard.token == card.token
        }) {
            cards.remove(at: oldCardIndex)
        }
        
        self.saveCards(cards)
    }
    
    private static func saveCards(_ cards: [ICCard]) {
        UserDefaults.standard.setValue(self.archivedCards(cards), forKey: ICConstants.cards)
    }
    
    private static func archivedCards(_ cards: [ICCard]) -> Data {
        return NSKeyedArchiver.archivedData(withRootObject: cards)
    }
    
    private static func unarchivedCards(_ cardsData: Data) -> [ICCard]? {
        return NSKeyedUnarchiver.unarchiveObject(with: cardsData) as? [ICCard]
    }
    
    
    // MARK: Orders
    
    static func orders() -> [String]? {
        return UserDefaults.standard.array(forKey: ICConstants.orders) as? [String]
    }
    
    static func addOrder(_ order: String) {
        var orders = [order]
        
        if let oldOrders = self.orders() {
            orders.append(contentsOf: oldOrders)
        }
        
        self.saveOrders(orders)
    }
    
    static func deleteOrder(_ order: String) {
        var orders = self.orders() ?? []
        
        if let oldOrderIndex = orders.index(of: order) {
            orders.remove(at: oldOrderIndex)
        }
        
        self.saveOrders(orders)
    }
    
    private static func saveOrders(_ orders: [String]) {
        UserDefaults.standard.set(orders, forKey: ICConstants.orders)
    }
    
    
    // MARK: Transactions
    
    static func transactions() -> [ICTransaction]? {
        guard let transactionsData = UserDefaults.standard.data(forKey: ICConstants.transactions) else {
            return nil
        }
        
        return self.unarchivedTransactions(transactionsData)
    }
    
    static func addTransaction(_ transaction: ICTransaction) {
        var transactions = [transaction]
        
        if let oldTransactions = self.transactions() {
            transactions.append(contentsOf: oldTransactions)
        }
        
        self.saveTransactions(transactions)
    }
    
    static func deleteTransaction(_ transaction: ICTransaction) {
        var transactions = self.transactions() ?? []
        
        if let oldTransactionIndex = transactions.index(of: transaction) {
            transactions.remove(at: oldTransactionIndex)
        }
        
        self.saveTransactions(transactions)
    }
    
    private static func saveTransactions(_ transactions: [ICTransaction]) {
        UserDefaults.standard.setValue(self.archivedTransactions(transactions), forKey: ICConstants.transactions)
    }
    
    private static func archivedTransactions(_ transactions: [ICTransaction]) -> Data {
        return NSKeyedArchiver.archivedData(withRootObject: transactions)
    }
    
    private static func unarchivedTransactions(_ transactionsData: Data) -> [ICTransaction]? {
        return NSKeyedUnarchiver.unarchiveObject(with: transactionsData) as? [ICTransaction]
    }
}
