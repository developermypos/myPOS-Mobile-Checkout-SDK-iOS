//
//  MobilePaymentSDK.swift
//  MobilePaymentSDK
//
//  Created by Valio Cholakov on 12/15/16.
//  Copyright © 2016 Intercard Finance AD. All rights reserved.
//

import UIKit
import MobilePaymentSDKUtils

public struct MobilePaymentSDK {
    
    ///
    /// Initializes the SDK and logs whether the process was successful.
    ///
    /// - parameter clientNumber:  The client's unique number.
    /// - parameter storeId:       The store's id.
    /// - parameter currency:      The currency in which all operations will be executed.
    /// - parameter certificate:   The name of the certificate file without the extension, which MUST be .der.
    /// - parameter privateKey:    The name of the private key file wihtout the extension, which MUST be .pem.
    /// - parameter bundle:        The bundle in which to search for the ceritifcate, private key and localization file. By default, the SDK will use the main Bundle.
    /// - parameter language:      Sets the SDK's language. Default value is "en".
    /// - parameter keyIndex:      The index of the key generated from the website.
    /// 
    
    public static func initialize(clientNumber: String,
                                  storeId: String,
                                  currency: Currency,
                                  certificate: String,
                                  privateKey: String,
                                  bundle: Bundle = Bundle.main,
                                  language: String = "en",
                                  keyIndex: Int = 1) {
        
        ICLogger.log("Initializing...")
        
        ICMobilePaymentManager.shared.setWallet(number: clientNumber, 
                                                sid: storeId,
                                                currency: currency,
                                                publicKey: certificate,
                                                privateKey: privateKey,
                                                bundle: bundle,
                                                language: language,
                                                keyIndex: keyIndex)
        
        ICLogger.log(ICMobilePaymentManager.shared.isInitialized ? "Initialized" : "Initialization failed")
    }
    
    
    ///
    /// Provides the ability to set a custom theme for the UI.
    ///
    /// - parameter theme: The MobilePaymentTheme to apply.
    ///
    
    public static func applyTheme(_ theme: MobilePaymentTheme) {
        ICThemeManager.shared.theme = theme
    }
    
    
    ///
    /// Gets the transaction status of a specific order.
    ///
    /// - parameter orderId:         The order's id.
    /// - parameter transactionType: The transaction's type. Purchase, Refund, etc.
    /// - parameter completed:       On success block returning a dictionary of transaction data - status and reference.
    /// - parameter failed:          On error block with error object for more details.
    ///
    
    public static func getOrderStatusFor(_ orderId: String,
                                         transactionType: TransactionType,
                                         completed: @escaping (_ transactionStatus: Int, _ transactionReference: String) -> Void,
                                         failed: @escaping (_ error: MobilePaymentSDKError) -> Void) {
        
        if !ICMobilePaymentManager.shared.isInitialized {
            failed(MobilePaymentSDKError.notInitialized)
            return
        }
        
        ICCommunicationManager.shared.getTransactionStatusFor(order: orderId, transactionType: transactionType, completed: { (transactionData) in
            let status    = transactionData[ICParameters.transactionStatus] as? Int    ?? -1
            let reference = transactionData[ICParameters.transactionRef2]   as? String ?? ""
            
            completed(status, reference)
        }, failed: failed)
    }
    
    
    ///
    /// Refunds an amount from a prevously made transaction.
    ///
    /// - parameter transactionRef: The transactions reference.
    /// - parameter amount:         The amount to refund.
    /// - parameter completed:      On success block returning the transaction's reference.
    /// - parameter failed:         On error block with error object for more details.
    ///
    
    public static func refundTransaction(_ transactionRef: String,
                                         amount: Double,
                                         completed: @escaping (_ transactionRef: String) -> Void,
                                         failed: @escaping (_ error: MobilePaymentSDKError) -> Void) {
        
        if !ICMobilePaymentManager.shared.isInitialized {
            failed(MobilePaymentSDKError.notInitialized)
            return
        }
        
        ICCommunicationManager.shared.makeRefund(for: amount.formatted, transactionRef: transactionRef, completed: completed, failed: failed)
    }
    
    
    ///
    /// Makes reversal of a prevously made transaction.
    ///
    /// - parameter transactionRef: The transactions reference.
    /// - parameter completed:      On success block returning the transaction's reference.
    /// - parameter failed:         On error block with error object for more details.
    ///
    
    static func reverseTransacton(transactionRef: String,
                                         completed: @escaping (_ transactionRef: String) -> Void,
                                         failed: @escaping (_ error: MobilePaymentSDKError) -> Void) {
        
        if !ICMobilePaymentManager.shared.isInitialized {
            failed(MobilePaymentSDKError.notInitialized)
            return
        }
        
        ICCommunicationManager.shared.makeReversal(for: transactionRef, completed: completed, failed: failed)
    }
}
