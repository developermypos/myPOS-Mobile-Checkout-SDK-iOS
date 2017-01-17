//
//  MobilePaymentSDKProtocols.swift
//  MobilePaymentSDK
//
//  Created by Valio Cholakov on 1/12/17.
//  Copyright © 2017 Intercard Finance AD. All rights reserved.
//

import Foundation

public protocol PaymentDelegate: NSObjectProtocol {
    
    func didMakePayment(transactionRef: String)
    func paymentFailed(error: MobilePaymentSDKError)
}

public protocol StoreCardDelegate: NSObjectProtocol {
    
    func didStoreCard(cardToken: String, customName: String)
    func storeCardFailed(error: MobilePaymentSDKError)
    
    func didUpdateStoredCard(cardToken: String, customName: String)
    func updateStoredCardFailed(error: MobilePaymentSDKError)
}
