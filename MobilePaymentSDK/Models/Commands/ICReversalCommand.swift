//
//  ICReversalCommand.swift
//  MobilePaymentSDK
//
//  Created by Valio Cholakov on 1/9/17.
//  Copyright © 2017 Intercard Finance AD. All rights reserved.
//

import UIKit

class ICReversalCommand: ICBaseCommand {

    // MARK: Initialziers
    
    init(transactionRef: String) {
        super.init()
        
        self.data[ICParameters.method]         = ICMethods.reversal
        self.data[ICParameters.transactionRef] = transactionRef
    }
    
    
    // MARK: Public Methods
    
    override var requestInfo: String {
        guard let transactionRef = self.data[ICParameters.transactionRef] else {
            return super.requestInfo
        }
        
        return "Reversal request for transaction \(transactionRef) has been sent"
    }
    
    override var responseInfo: String {
        guard let transactionRef = self.data[ICParameters.transactionRef] else {
            return super.responseInfo
        }
        
        return "Received response for reversal of \(transactionRef)"
    }
}
