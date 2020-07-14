//
//  MPUtil.swift
//  Mobile Payment Test
//
//  Created by Valio Cholakov on 1/16/17.
//  Copyright © 2020 myPOS AD. All rights reserved.
//

import UIKit

struct MPUtils {
    
    // MARK: Public Methods
    
    static var randomOrderId: String {
        let letters : NSString = "0123456789"
        let len = UInt32(letters.length)
        
        var randomString = ""
        
        for _ in 0 ..< 10 {
            let rand = arc4random_uniform(len)
            var nextChar = letters.character(at: Int(rand))
            randomString += NSString(characters: &nextChar, length: 1) as String
        }
        
        return randomString
    }
    
    static var cards: [MPCard] {
        return UserDefaults.cards() ?? []
    }
    
    static var orders: [String] {
        return UserDefaults.orders() ?? []
    }
    
    static var transactions: [MPTransaction] {
        return UserDefaults.transactions() ?? []
    }
}
