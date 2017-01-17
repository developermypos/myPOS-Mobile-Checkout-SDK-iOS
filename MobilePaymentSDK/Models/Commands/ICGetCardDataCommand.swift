//
//  ICGetCardDataCommand.swift
//  MobilePaymentSDK
//
//  Created by Valio Cholakov on 1/9/17.
//  Copyright © 2017 Intercard Finance AD. All rights reserved.
//

import UIKit

class ICGetCardDataCommand: ICBaseCommand {

    // MARK: Initializers
    
    init(pan: String) {
        super.init()
        
        self.data[ICParameters.pan]      = pan.encrypted ?? ""
        self.data[ICParameters.method]   = ICMethods.getCardData
        self.data[ICParameters.currency] = ICMobilePaymentManager.shared.currency
    }
    
    
    // MARK: Public Methods
    
    override var requestInfo: String {
        return "Verifying card..."
    }
}
