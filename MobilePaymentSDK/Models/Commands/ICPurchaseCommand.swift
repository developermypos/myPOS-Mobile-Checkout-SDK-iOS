//
//  ICPurchaseCommand.swift
//  MobilePaymentSDK
//
//  Created by Valio Cholakov on 1/3/17.
//  Copyright © 2017 Intercard Finance AD. All rights reserved.
//

import UIKit

class ICPurchaseCommand: ICBaseCommand {
    
    // MARK: Initialziers
    
    init(amount: String, extraData: [String : String]) {
        super.init()
        
        self.data[ICParameters.method]   = ICMethods.purchase
        self.data[ICParameters.amount]   = amount
        self.data[ICParameters.currency] = ICMobilePaymentManager.shared.currency
        
        self.data.append(extraData)
    }
    
    
    // MARK: Public Methods
    
    override var requestInfo: String {
        guard let cartItems = self.data[ICParameters.cartItems],
              let amount    = self.data[ICParameters.amount],
              let currency  = self.data[ICParameters.currency],
              let orderId   = self.data[ICParameters.orderId] else {
                return super.requestInfo
        }
        
        return "Order \(orderId) purchase request for \(cartItems) articles for a total of \(amount) \(currency) has been sent"
    }
    
    override var responseInfo: String {
        guard let orderId = self.data[ICParameters.orderId] else {
            return super.responseInfo
        }
        
        return "Response for order \(orderId) purchase request has been received"
    }
}
