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
    
    static func cards() -> [MPCard]? {
        guard let cardsData = UserDefaults.standard.data(forKey: MPConstants.cards) else {
            return nil
        }
        
        return self.unarchivedCards(cardsData)
    }
    
    static func addCard(_ card: MPCard) {
        var cards = [card]
        
        if let oldCards = self.cards() {
            cards.append(contentsOf: oldCards)
        }
        
        self.saveCards(cards)
    }
    
    static func deleteCard(_ card: MPCard) {
        var cards = self.cards() ?? []
        
        if let oldCardIndex = cards.index(where: { (oldCard) -> Bool in
            return oldCard.token == card.token
        }) {
            cards.remove(at: oldCardIndex)
        }
        
        self.saveCards(cards)
    }
    
    private static func saveCards(_ cards: [MPCard]) {
        UserDefaults.standard.setValue(self.archivedCards(cards), forKey: MPConstants.cards)
    }
    
    private static func archivedCards(_ cards: [MPCard]) -> Data {
        return NSKeyedArchiver.archivedData(withRootObject: cards)
    }
    
    private static func unarchivedCards(_ cardsData: Data) -> [MPCard]? {
        return NSKeyedUnarchiver.unarchiveObject(with: cardsData) as? [MPCard]
    }
    
    
    // MARK: Orders
    
    static func orders() -> [String]? {
        return UserDefaults.standard.array(forKey: MPConstants.orders) as? [String]
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
        UserDefaults.standard.set(orders, forKey: MPConstants.orders)
    }
    
    
    // MARK: Transactions
    
    static func transactions() -> [MPTransaction]? {
        guard let transactionsData = UserDefaults.standard.data(forKey: MPConstants.transactions) else {
            return nil
        }
        
        return self.unarchivedTransactions(transactionsData)
    }
    
    static func addTransaction(_ transaction: MPTransaction) {
        var transactions = [transaction]
        
        if let oldTransactions = self.transactions() {
            transactions.append(contentsOf: oldTransactions)
        }
        
        self.saveTransactions(transactions)
    }
    
    static func deleteTransaction(_ transaction: MPTransaction) {
        var transactions = self.transactions() ?? []
        
        if let oldTransactionIndex = transactions.index(of: transaction) {
            transactions.remove(at: oldTransactionIndex)
        }
        
        self.saveTransactions(transactions)
    }
    
    private static func saveTransactions(_ transactions: [MPTransaction]) {
        UserDefaults.standard.setValue(self.archivedTransactions(transactions), forKey: MPConstants.transactions)
    }
    
    private static func archivedTransactions(_ transactions: [MPTransaction]) -> Data {
        return NSKeyedArchiver.archivedData(withRootObject: transactions)
    }
    
    private static func unarchivedTransactions(_ transactionsData: Data) -> [MPTransaction]? {
        return NSKeyedUnarchiver.unarchiveObject(with: transactionsData) as? [MPTransaction]
    }
}
