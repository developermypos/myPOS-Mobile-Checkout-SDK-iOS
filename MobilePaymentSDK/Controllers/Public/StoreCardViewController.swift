//
//  StoreCardViewController.swift
//  MobilePaymentSDK
//
//  Created by Valio Cholakov on 12/29/16.
//  Copyright © 2016 Intercard Finance AD. All rights reserved.
//

import UIKit

public class StoreCardViewController: UINavigationController {

    // MARK: Variables/Constants
    
    var verificationAmount: Double = 0.0
    weak var storeCardDelegate: StoreCardDelegate?
    
    
    // MARK: Initializers/Deinitializer
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    public init(verificationAmount: Double, delegate: StoreCardDelegate?) {
        super.init(nibName: nil, bundle: nil)
        
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
        self.storeCardDelegate?.storeCardFailed(error: MobilePaymentSDKError.notInitialized)
        self.dismiss(animated: true, completion: nil)
    }
    
    
    // MARK: Private Methods
    
    private func customInit() {
        guard let storeCardController = ICUtil.storeCardController else {
            return
        }
        
        storeCardController.storeCardDelegate      = self.storeCardDelegate
        storeCardController.cardVerificationAmount = self.verificationAmount.formatted
        
        self.viewControllers = [storeCardController]
    }
}
