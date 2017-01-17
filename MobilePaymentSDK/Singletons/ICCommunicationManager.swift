//
//  ICCommunicationManager.swift
//  MobilePaymentSDK
//
//  Created by Valio Cholakov on 12/29/16.
//  Copyright © 2016 Intercard Finance AD. All rights reserved.
//

import UIKit
import MobilePaymentSDKUtils

class ICCommunicationManager: ICBaseManager {
    
    // MARK: Properties
    
    private let _operationQueue     = OperationQueue()
    private let _communicationQueue = DispatchQueue(label: "com.ipay.MobilePaymentSDK-communication", qos: .default, attributes: .concurrent, autoreleaseFrequency: .inherit, target: nil)
    
    
    // MARK: Singleton
    
    static let shared = ICCommunicationManager()
    
    
    // MARK: Public Methods
    
    func makePurchase(for articles: [Article],
                      orderId: String,
                      cardToken: String,
                      completed: @escaping (_ transactionRef: String) -> Void,
                      failed: @escaping (_ error: MobilePaymentSDKError) -> Void) {
        
        let cardData: [String : String] = [
            ICParameters.cardToken     : cardToken,
            ICParameters.customerIdent : ICConstants.customerIdent
        ]
        
        self.makePurchase(articles: articles, orderId: orderId, cardData: cardData, completed: completed, failed: failed)
    }
    
    func makePurchase(for articles: [Article],
                      orderId: String,
                      card: ICCard,
                      cardData: [String : String],
                      completed: @escaping (_ transactionRef: String) -> Void,
                      failed: @escaping (_ error: MobilePaymentSDKError) -> Void) {
        
        guard let pan        = card.pan.encrypted,
              let cvc        = card.cvc.encrypted,
              let expiryDate = card.expiryDate.encrypted else {
                failed(self.unknownError)
                ICLogger.logDebug("Internal error")
              return
        }
        
        var fullCardData: [String : String] = [
            ICParameters.pan        : pan,
            ICParameters.cvc        : cvc,
            ICParameters.expiryDate : expiryDate,
            ICParameters.customName : card.customName,
            ICParameters.embossName : card.embossName
        ]
        
        fullCardData.append(cardData)
        
        self.makePurchase(articles: articles, orderId: orderId, cardData: fullCardData, completed: completed, failed: failed)
    }
    
    func makeReversal(for transactionRef: String,
                      completed: @escaping (_ transactionRef: String) -> Void,
                      failed: @escaping (_ error: MobilePaymentSDKError) -> Void) {
        
        let command = ICReversalCommand(transactionRef: transactionRef)
        self.sendCommand(command, completion: self.financeOperationCompletion(completed: completed, failed: failed))
    }
    
    func makeRefund(for amount: String,
                    transactionRef: String,
                    completed: @escaping (_ transactionRef: String) -> Void,
                    failed: @escaping (_ error: MobilePaymentSDKError) -> Void) {
        
        let command = ICRefundCommand(transactionRef: transactionRef, amount: amount)
        self.sendCommand(command, completion: self.financeOperationCompletion(completed: completed, failed: failed))
    }
    
    func storeCard(pan: String,
                   expiryDate: String,
                   cvc: String,
                   embossName: String,
                   customName: String,
                   amount: String,
                   extraData: [String : String],
                   completed: @escaping (_ cardToken: String) -> Void,
                   failed: @escaping (_ error: MobilePaymentSDKError) -> Void) {
        
        let command = ICStoreCardCommand(pan: pan,
                                         cvc: cvc,
                                         expiryDate: expiryDate,
                                         embossName: embossName,
                                         customName: customName,
                                         amount: amount,
                                         extraData: extraData)
        
        self.sendCommand(command, completion: self.cardOperationCompletion(completed: completed, failed: failed))
    }
    
    func updateStoredCard(token: String,
                          pan: String,
                          expiryDate: String,
                          cvc: String,
                          embossName: String,
                          customName: String,
                          amount: String,
                          extraData: [String : String],
                          completed: @escaping (_ cardToken: String) -> Void,
                          failed: @escaping (_ error: MobilePaymentSDKError) -> Void) {
        
        let command = ICUpdateStoredCardCommand(token: token,
                                                pan: pan,
                                                cvc: cvc,
                                                expiryDate: expiryDate,
                                                embossName: embossName,
                                                customName: customName,
                                                amount: amount,
                                                extraData: extraData)
        
        self.sendCommand(command, completion: self.cardOperationCompletion(completed: completed, failed: failed))
    }
    
    func getCardData(pan: String,
                     completed: @escaping (_ cardData: [String : Any]) -> Void,
                     failed: @escaping (_ error: MobilePaymentSDKError) -> Void) {
        
        let parameters: [String] = [
            ICParameters.mid,
            ICParameters.bin,
            ICParameters.cardType,
            ICParameters.walletId,
            ICParameters.is3DSecure,
            ICParameters.billingDescriptor
        ]
        
        let command = ICGetCardDataCommand(pan: pan)
        self.sendCommand(command, completion: self.operationCompletion(paramNames: parameters, completed: completed, failed: failed))
    }
    
    func getTransactionStatusFor(order orderId: String,
                                 completed: @escaping (_ data: [String : Any]) -> Void,
                                 failed: @escaping (_ error: MobilePaymentSDKError) -> Void) {
        
        let command = ICGetTransactionStatusCommand(orderId: orderId)
        self.sendCommand(command, completion: self.operationCompletion(paramNames: [ICParameters.transactionStatus, ICParameters.transactionRef2], completed: completed, failed: failed))
    }
    
    
    // MARK: Private Methods
    
    private func sendCommand(_ command: ICBaseCommand, completion: @escaping (_ response: Any?) -> Void) {
        _communicationQueue.async {           
            guard let signature = ICUtil.signedData(command.data) else {
                ICLogger.logDebug("Could not sign data")
                DispatchQueue.main.async { completion(self.communicationError) }
                return
            }
            
            let requestData = command.data.formData.appending("&\(ICParameters.signature)=\(signature.urlEncoded())")
            
            ICLogger.log(command.requestInfo)
            ICLogger.logDebug("Request: \(ICUrls.api)?\(requestData)")
            
            guard let body = requestData.data(using: .utf8) else {
                ICLogger.logDebug("Invalid request data")
                DispatchQueue.main.async { completion(self.communicationError) }
                return
            }
            
            let request   = ICURLRequest(body: body)
            let operation = ICHttpOperation(request: request, onSuccess: { (response) in
                completion(response)
            }, onError: { (error) in
                completion(error)
            })
            
            self._operationQueue.addOperation(operation)
        }
    }
    
    
    // MARK: Helpers
    
    private func makePurchase(articles: [Article],
                              orderId: String,
                              cardData: [String : String],
                              completed: @escaping (_ transactionRef: String) -> Void,
                              failed: @escaping (_ error: MobilePaymentSDKError) -> Void) {
        var amount: Double = 0.0
        var extraData: [String : String] = [
            ICParameters.orderId   : orderId,
            ICParameters.cartItems : String(articles.count)
        ]
        
        for (index, article) in articles.enumerated() {
            amount += article.amount.double
            
            extraData.append(article.formattedData(number: index + 1))
        }
        
        extraData.append(cardData)
        
        let command = ICPurchaseCommand(amount: amount.formatted, extraData: extraData)
        self.sendCommand(command, completion: self.financeOperationCompletion(completed: completed, failed: failed))
    }
    
    
    private func financeOperationCompletion(completed: @escaping (_ transactionRef: String) -> Void,
                                            failed: @escaping (_ error: MobilePaymentSDKError) -> Void) -> ((Any) -> Void) {
        return self.operationCompletion(paramName: ICParameters.transactionRef, completed: completed, failed: failed)
    }
    
    private func cardOperationCompletion(completed: @escaping (_ cardToken: String) -> Void,
                                         failed: @escaping (_ error: MobilePaymentSDKError) -> Void) -> ((Any) -> Void) {
        return self.operationCompletion(paramName: ICParameters.cardToken, completed: completed, failed: failed)
    }
    
    private func operationCompletion(paramName: String,
                                     completed: @escaping (_ data: String) -> Void,
                                     failed: @escaping (_ error: MobilePaymentSDKError) -> Void) -> ((Any) -> Void) {
        return { (response) in
            if let error = response as? MobilePaymentSDKError {
                failed(error)
                return
            }
            
            guard let data = response as? NSDictionary else {
                failed(self.communicationError)
                return
            }
            
            guard let parameter = data[paramName] as? String else {
                failed(self.communicationError)
                return
            }
            
            completed(parameter)
        }
    }
    
    private func operationCompletion(paramNames: [String],
                                     completed: @escaping (_ data: [String : Any]) -> Void,
                                     failed: @escaping (_ error: MobilePaymentSDKError) -> Void) -> ((Any) -> Void) {
        return { (response) in
            if let error = response as? MobilePaymentSDKError {
                failed(error)
                return
            }
            
            guard let data = response as? NSDictionary else {
                failed(self.communicationError)
                return
            }
            
            guard let status = data[ICParameters.status] as? Int else {
                failed(self.communicationError)
                return
            }
            
            if status != ICResponseStatus.ok {
                failed(self.communicationError)
                return
            }
            
            var parameters: [String : Any] = [:]
            
            for paramName in paramNames {
                parameters[paramName] = data[paramName]
            }
            
            completed(parameters)
        }
    }
    
    private var communicationError: MobilePaymentSDKError {
        return MobilePaymentSDKError.communicationError
    }
    
    private var unknownError: MobilePaymentSDKError {
        return MobilePaymentSDKError.undefinedError
    }
}
