//
//  ICUpdateStoredCardViewController.swift
//  MobilePaymentSDK
//
//  Created by Valio Cholakov on 1/12/17.
//  Copyright © 2017 Intercard Finance AD. All rights reserved.
//

import UIKit

class ICUpdateStoredCardViewController: ICCardViewController {
    
    // MARK: Variables
    
    var token: String = ""
    

    // MARK: Controller Methods
    
    override func applyTheme() {
        super.applyTheme()
        
    }
    
    override func localize() {
        super.localize()
        
        self.navigationItem.title = ICLocalization.localized("Update stored card")
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
        
        ICCommunicationManager.shared.updateStoredCard(token: self.token,
                                                       pan: card.pan,
                                                       expiryDate: card.expiryDate,
                                                       cvc: card.cvc,
                                                       embossName: card.embossName,
                                                       customName: card.customName,
                                                       amount: self.cardVerificationAmount,
                                                       extraData: extraData,
                                                       completed: self.updateCardCompleted,
                                                       failed: self.updateCardFailed)
    }
    
    
    // MARK: Helpers
    
    private var updateCardCompleted: ((String) -> Void) {
        return { (cardToken) in
            self.dismiss(completion: { 
                self.storeCardDelegate?.didUpdateStoredCard(cardToken: cardToken, customName: self.card?.customName ?? "")
            })
        }
    }
    
    private var updateCardFailed: ((MobilePaymentSDKError) -> Void) {
        return { (error) in
            self.dismiss(completion: { 
                self.storeCardDelegate?.updateStoredCardFailed(error: error)
            })
        }
    }
}
