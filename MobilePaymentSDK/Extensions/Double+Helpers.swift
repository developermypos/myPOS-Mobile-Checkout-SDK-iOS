//
//  Double+Helpers.swift
//  MobilePaymentSDK
//
//  Created by Valio Cholakov on 1/10/17.
//  Copyright © 2017 Intercard Finance AD. All rights reserved.
//

import Foundation

extension Double {
    
    // MARK: Public Methods
    
    var formatted: String {
        return String.init(format: "%.02f", self)
    }
}
