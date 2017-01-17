//
//  UpdateStoredCardViewController.swift
//  MobilePaymentSDK
//
//  Created by Valio Cholakov on 12/29/16.
//  Copyright © 2016 Intercard Finance AD. All rights reserved.
//

import UIKit

public class UpdateStoredCardViewController: UINavigationController {

    // MARK: Variables/Constants
    
    var cardToken: String = ""
    var verificationAmount: Double = 0.0
    weak var storeCardDelegate: StoreCardDelegate?
    
    
    // MARK: Initializers/Deinitializer
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    public init(cardToken: String, verificationAmount: Double, delegate: StoreCardDelegate?) {
        super.init(nibName: nil, bundle: nil)
        
        self.cardToken          = cardToken
        self.storeCardDelegate  = delegate
        self.verificationAmount = verificationAmount
        
        self.customInit()
    }
    
    deinit {
        self.storeCardDelegate = nil
    }
    
    
    // MARK: Controller Methods
    
    public override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        if ICMobilePaymentManager.shared.isInitialized {
            return
        }
        
        ICLogger.log("SDK not initialized")
        self.storeCardDelegate?.updateStoredCardFailed(error: MobilePaymentSDKError.notInitialized)
        self.dismiss(animated: true, completion: nil)
    }
    
    
    // MARK: Private Methods
    
    private func customInit() {
        guard let storeCardController = ICUtil.updateStoredCardController else {
            return
        }
        
        storeCardController.token                  = self.cardToken
        storeCardController.storeCardDelegate      = self.storeCardDelegate
        storeCardController.cardVerificationAmount = self.verificationAmount.formatted
        
        self.viewControllers = [storeCardController]
    }
}
