//
//  ICGetTransactionStatusCommand.swift
//  MobilePaymentSDK
//
//  Created by Valio Cholakov on 1/13/17.
//  Copyright © 2017 Intercard Finance AD. All rights reserved.
//

import UIKit

class ICGetTransactionStatusCommand: ICBaseCommand {

    // MARK: Initializers
    
    init(orderId: String) {
        super.init()
        
        self.data[ICParameters.method]  = ICMethods.getTransactionStatus
        self.data[ICParameters.orderId] = orderId
    }
    
    
    // MARK: Public Methods
    
    override var requestInfo: String {
        return "Getting tansaction status"
    }
    
    override var responseInfo: String {
        return "Tansaction status received"
    }
}
