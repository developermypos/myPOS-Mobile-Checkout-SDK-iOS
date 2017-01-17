//
//  ICRefundCommand.swift
//  MobilePaymentSDK
//
//  Created by Valio Cholakov on 1/9/17.
//  Copyright © 2017 Intercard Finance AD. All rights reserved.
//

import UIKit

class ICRefundCommand: ICBaseCommand {

    // MARK: Initialziers
    
    init(transactionRef: String, amount: String) {
        super.init()
        
        self.data[ICParameters.method]         = ICMethods.refund
        self.data[ICParameters.amount]         = amount
        self.data[ICParameters.currency]       = ICMobilePaymentManager.shared.currency
        self.data[ICParameters.transactionRef] = transactionRef
    }
    
    
    // MARK: Public Methods
    
    override var requestInfo: String {
        guard let amount         = self.data[ICParameters.amount],
              let currency       = self.data[ICParameters.currency],
              let transactionRef = self.data[ICParameters.transactionRef] else {
            return super.requestInfo
        }
        
        return "Refund request for \(amount) \(currency) from transaction \(transactionRef) has been sent"
    }
    
    override var responseInfo: String {
        guard let amount         = self.data[ICParameters.amount],
              let currency       = self.data[ICParameters.currency],
              let transactionRef = self.data[ICParameters.transactionRef] else {
                return super.requestInfo
        }
        
        return "Refund response for \(amount) \(currency) from transaction \(transactionRef) has been received"
    }
}
