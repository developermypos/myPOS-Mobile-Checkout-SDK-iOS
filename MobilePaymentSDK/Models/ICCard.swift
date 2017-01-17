//
//  ICCard.swift
//  MobilePaymentSDK
//
//  Created by Valio Cholakov on 1/11/17.
//  Copyright © 2017 Intercard Finance AD. All rights reserved.
//

import UIKit

class ICCard: NSObject {

    // MARK: Properties
    
    private var _expiryDate: String
    private(set) var pan: String
    private(set) var cvc: String
    private(set) var embossName: String
    private(set) var customName: String
    
    
    // MARK: Initializers
    
    init(pan: String, expiryDate: String, cvc: String, embossName: String, customName: String) {
        self.pan        = pan
        self.cvc        = cvc
        self.embossName = embossName
        self.customName = customName
        _expiryDate     = expiryDate
        
        super.init()
    }
    
    
    // MARK: Public Methods
    
    var expiryMonth: String {
        return _expiryDate.substring(to: 2)
    }
    
    var expiryYear: String {
        return _expiryDate.substring(from: _expiryDate.length - 2)
    }
    
    var expiryDate: String {
        return "\(self.expiryYear)\(self.expiryMonth)"
    }
}
