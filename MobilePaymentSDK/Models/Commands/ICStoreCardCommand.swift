//
//  ICStoreCardCommand.swift
//  MobilePaymentSDK
//
//  Created by Valio Cholakov on 1/9/17.
//  Copyright © 2017 Intercard Finance AD. All rights reserved.
//

import UIKit

class ICStoreCardCommand: ICBaseCommand {

    // MARK: Initializers
    
    init(pan: String, cvc: String, expiryDate: String, embossName: String, customName: String, amount: String, extraData: [String : String]) {
        super.init()
        
        self.data[ICParameters.pan]              = pan.encrypted
        self.data[ICParameters.cvc]              = cvc.encrypted
        self.data[ICParameters.method]           = ICMethods.storeCard
        self.data[ICParameters.customName]       = customName
        self.data[ICParameters.embossName]       = embossName
        self.data[ICParameters.expiryDate]       = expiryDate.encrypted
        self.data[ICParameters.amount]           = amount
        self.data[ICParameters.currency]         = ICMobilePaymentManager.shared.currency
        self.data[ICParameters.cardVerification] = ICConstants.cardVerification
        self.data.append(extraData)
    }
    
    
    // MARK: Public Methods
    
    override var requestInfo: String {
        guard let customName = self.data[ICParameters.customName] else {
            return super.requestInfo
        }
        
        return "Store card with custom name \(customName) request has been sent"
    }
    
    override var responseInfo: String {
        guard let customName = self.data[ICParameters.customName] else {
            return super.responseInfo
        }
        
        return "Response for store card with custom name \(customName) has been received"
    }
}
