//
//  ICPaymentViewController.swift
//  MobilePaymentSDK
//
//  Created by Valio Cholakov on 12/29/16.
//  Copyright © 2016 Intercard Finance AD. All rights reserved.
//

import UIKit

class ICPaymentViewController: ICCardViewController {    
    
    // MARK: Variables
    
    var articles: [Article] = []
    var orderId: String = ""
    var cardToken: String?
    

    // MARK: Controller Methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        guard let cardToken = self.cardToken else {
            return
        }
        
        self.contentView.isHidden              = true
        self.navigationItem.rightBarButtonItem = nil
        
        self.showLoadingHUD()
        ICCommunicationManager.shared.makePurchase(for: self.articles,
                                                   orderId: self.orderId,
                                                   cardToken: cardToken,
                                                   completed: self.paymentCompleted,
                                                   failed: self.paymentFailed)
    }
    
    override func applyTheme() {
        super.applyTheme()
        
        
    }
    
    override func localize() {
        super.localize()
        
        self.navigationItem.title = ICLocalization.localized("Payment")
        self.confirmButton.title  = ICLocalization.localized("Pay")
    }
    
    
    // MARK: 3DSecure Delegate
    
    override func didReceive3DSecureResponse(_ response: NSDictionary) {
        super.didReceive3DSecureResponse(response)
        
        guard let card      = self.card,
              let extraData = self.extraData else {
            return
        }
        
        self.showLoadingHUD()
        
        ICCommunicationManager.shared.makePurchase(for: self.articles,
                                                   orderId: self.orderId,
                                                   card: card,
                                                   cardData: extraData,
                                                   completed: self.paymentCompleted,
                                                   failed: self.paymentFailed)
    }
    
    
    // MARK: Helpers
    
    private var paymentCompleted: ((String) -> Void) {
        return { (transactionRef) in
            self.dismiss(completion: { 
                self.paymentDelegate?.didMakePayment(transactionRef: transactionRef)
            })
        }
    }
    
    private var paymentFailed: ((MobilePaymentSDKError) -> Void) {
        return { (error) in
            self.dismiss(completion: { 
                self.paymentDelegate?.paymentFailed(error: MobilePaymentSDKError.communicationError)
            })
        }
    }
}
