//
//  ICStoreCardViewController.swift
//  MobilePaymentSDK
//
//  Created by Valio Cholakov on 12/29/16.
//  Copyright © 2016 Intercard Finance AD. All rights reserved.
//

import UIKit

class ICStoreCardViewController: ICCardViewController {
    
    // MARK: Variables
    
    weak var delegate: StoreCardDelegate?
    

    // MARK: Controller Methods
    
    override func applyTheme() {
        super.applyTheme()
        
    }
    
    override func localize() {
        super.localize()
        
        self.navigationItem.title = ICLocalization.localized("Store card")
        self.confirmButton.title  = ICLocalization.localized("Save")
    }
    
    
    // MARK: 3DSecure Delegate
    
    override func didReceive3DSecureResponse(_ response: NSDictionary) {
        super.didReceive3DSecureResponse(response)
        
        guard let card      = self.card,
              let extraData = self.extraData else {
                return
        }
        
        self.showLoadingHUD()
        
        ICCommunicationManager.shared.storeCard(pan: card.pan,
                                                expiryDate: card.expiryDate,
                                                cvc: card.cvc,
                                                embossName: card.embossName,
                                                customName: card.customName,
                                                amount: self.cardVerificationAmount,
                                                extraData: extraData,
                                                completed: self.storeCardCompleted,
                                                failed: self.storeCardFailed)
    }
    
    
    // MARK: Helpers
    
    private var storeCardCompleted: ((String) -> Void) {
        return { (cardToken) in
            self.dismiss(completion: { 
                self.storeCardDelegate?.didStoreCard(cardToken: cardToken, customName: self.card?.customName ?? "")
            })
        }
    }
    
    private var storeCardFailed: ((MobilePaymentSDKError) -> Void) {
        return { (error) in
            self.dismiss(completion: { 
                self.storeCardDelegate?.storeCardFailed(error: error)
            })
        }
    }
}
