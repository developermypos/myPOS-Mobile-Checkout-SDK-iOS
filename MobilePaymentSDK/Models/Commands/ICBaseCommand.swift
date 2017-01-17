//
//  ICBaseCommand.swift
//  MobilePaymentSDK
//
//  Created by Valio Cholakov on 1/3/17.
//  Copyright © 2017 Intercard Finance AD. All rights reserved.
//

import UIKit

class ICBaseCommand: NSObject {

    // MARK: Comamnd data
    
    internal var data = [String : String]()
    
    
    // MARK: Initializers
    
    override init() {
        super.init()
        
        self.data[ICParameters.sid]          = ICMobilePaymentManager.shared.sid
        self.data[ICParameters.version]      = ICConstants.sdkVersion
        self.data[ICParameters.channel]      = ICConstants.channel
        self.data[ICParameters.language]     = ICMobilePaymentManager.shared.language
        self.data[ICParameters.keyIndex]     = ICMobilePaymentManager.shared.keyIndex
        self.data[ICParameters.ipcVersion]   = ICConstants.ipcVersion
        self.data[ICParameters.outputFormat] = ICConstants.outputFormat
        self.data[ICParameters.walletNumber] = ICMobilePaymentManager.shared.walletNumber
    }
    
    
    // MARK: Public Methods
    
    var requestInfo: String {
        return ""
    }
    
    var responseInfo: String {
        return ""
    }
}
