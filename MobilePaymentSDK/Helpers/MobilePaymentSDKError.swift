//
//  MobilePaymentSDKError.swift
//  MobilePaymentSDK
//
//  Created by Valio Cholakov on 12/15/16.
//  Copyright © 2016 Intercard Finance AD. All rights reserved.
//

import UIKit

public struct MobilePaymentSDKError {
    
    // MARK: Enums
    
    public enum status: Int {
        case sdkNotInitialized        = -6
        case signatureValidationError = -5
        case communicationError       = -4
        case invalidInputParameters   = -3
        case apiError                 = -2
        case timeout                  = -1
        case success                  = 0
        case invalidSid               = 4
        case invalidParameters        = 5
        case invalidAmount            = 9
        case insufficientFunds        = 13
        case transactionNotPermitted  = 14
        case limitExceeded            = 15
        case inactiveAccount          = 17
        case invalidAccount           = 18
        case accountLimitExceeded     = 19
        case undefined                = 99
    }
    
    // MARK: Properties
    
    private(set) var status: status?
    
    
    // MARK: Initialziers
    
    init(status: status?) {
        self.status = status
    }
    
    
    // MARK: Public Methods
    
    public var message: String {
        guard let status = self.status else {
            return "Communication error"
        }
        
        switch status {
        case .timeout:
            return "Request timed out"
            
        case .success:
            return "N/A"
            
        case .invalidSid:
            return "Invalid Store Id"
            
        case .invalidInputParameters,
             .invalidParameters:
            return "Invalid parameters"
            
        case .invalidAmount:
            return "Invalid amount"
            
        case .insufficientFunds:
            return "Insufficient funds"
            
        case .transactionNotPermitted:
            return "Transaction not permitted"
            
        case .limitExceeded:
            return "Limit exceeded"
            
        case .inactiveAccount:
            return "Inactive account"
            
        case .invalidAccount:
            return "Invalid account"
            
        case .accountLimitExceeded:
            return "Account limit exceeded"
            
        case .undefined:
            return "Undefined"
            
        case .sdkNotInitialized:
            return "SDK not initialized"
            
        case .signatureValidationError:
            return "Signature validation failed. Check your public certificate"
            
        case .communicationError:
            return "Communication error"
            
        case .apiError:
            return "API error"
        }
    }
    
    static let notInitialized: MobilePaymentSDKError = {
        return MobilePaymentSDKError(status: .sdkNotInitialized)
    }()
    
    static let communicationError: MobilePaymentSDKError = {
        return MobilePaymentSDKError(status: nil)
    }()
    
    static let undefinedError: MobilePaymentSDKError = {
        return MobilePaymentSDKError(status: .undefined)
    }()
}
