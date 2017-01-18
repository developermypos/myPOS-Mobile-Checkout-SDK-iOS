//
//  Article.swift
//  MobilePaymentSDK
//
//  Created by Valio Cholakov on 1/10/17.
//  Copyright © 2017 Intercard Finance AD. All rights reserved.
//

import UIKit

public class Article: NSObject {
    
    // MARK: Properties
    
    public private(set) var name: String = ""
    public private(set) var price: Double = 0.0
    public private(set) var quantity: Int = 0
    
    // MARK: Initialziers
    
    public init(name: String, price: Double, quantity: Int) {
        super.init()
        
        self.name     = name
        self.price    = price
        self.quantity = quantity
    }
    
    
    // MARK: Public Methods
    
    func formattedData(number: Int) -> [String : String] {
        return [
            "\(ICParameters.article)_\(number)"  : self.name,
            "\(ICParameters.price)_\(number)"    : self.price.formatted,
            "\(ICParameters.quantity)_\(number)" : String(self.quantity),
            "\(ICParameters.amount)_\(number)"   : self.amount,
            "\(ICParameters.currency)_\(number)" : ICMobilePaymentManager.shared.currency
        ]
    }
    
    var amount: String {
        return String.init(format: "%.02f", self.price * Double(self.quantity))
    }
    
    
    // MARK: Description
    
    public override var description: String {
        return "Article {\r" +
               "    name = \(self.name)\r" +
               "    price = \(self.price)\r" +
               "    quantity = \(self.quantity)\r" +
               "}"
    }
    
    public override var debugDescription: String {
        return self.description
    }
}
