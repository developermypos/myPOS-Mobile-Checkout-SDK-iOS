//
//  ICLogger.swift
//  MobilePaymentSDK
//
//  Created by Valio Cholakov on 12/29/16.
//  Copyright © 2016 Intercard Finance AD. All rights reserved.
//

import UIKit

struct ICLogger {
    
    // MARK: Public Methods
    
    static func log(_ msg: String?) {
        guard let message = msg else {
            return
        }
        
        if message.length == 0 {
            return
        }
        
        debugPrint("\(Date()) [Mobile Payment SDK] \(message)")
    }
    
    static func logDebug(_ msg: String?) {
        if !ICMobilePaymentManager.shared.inDebug {
            return
        }
        
        self.log(msg)
    }
}
