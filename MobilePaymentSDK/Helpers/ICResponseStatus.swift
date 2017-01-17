//
//  ICResponseStatus.swift
//  MobilePaymentSDK
//
//  Created by Valio Cholakov on 12/15/16.
//  Copyright © 2016 Intercard Finance AD. All rights reserved.
//

import UIKit

struct ICResponseStatus {
    
    static let ok = 0
}

struct SecureResponseStatus {
    
    static let ok              = 0
    static let paramError      = 1
    static let otherParamError = 2
}
