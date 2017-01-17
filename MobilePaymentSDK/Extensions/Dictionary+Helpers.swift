//
//  Dictionary+Helpers.swift
//  MobilePaymentSDK
//
//  Created by Valio Cholakov on 1/3/17.
//  Copyright © 2017 Intercard Finance AD. All rights reserved.
//

import Foundation
import MobilePaymentSDKUtils

extension Dictionary {
    
    // MARK: Public Methods
    
    mutating func append(_ dictionary: Dictionary) {
        for (key, value) in dictionary {
            let _ = autoreleasepool(invoking: {
                self.updateValue(value, forKey: key)
            })
        }
    }
    
    var formData: String {
        var formData = ""
        
        for (key, value) in self {
            guard let safeKey   = key   as? String,
                let safeValue = value as? String
                else {
                    continue
            }
            
            formData += "&\(safeKey)=\(safeValue.urlEncoded())"
        }
        
        return formData.substring(from: 1)
    }
}
