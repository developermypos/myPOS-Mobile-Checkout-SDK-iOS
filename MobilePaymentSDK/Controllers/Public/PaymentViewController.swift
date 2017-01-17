//
//  PaymentViewController.swift
//  MobilePaymentSDK
//
//  Created by Valio Cholakov on 12/29/16.
//  Copyright © 2016 Intercard Finance AD. All rights reserved.
//

import UIKit

public class PaymentViewController: UINavigationController {
    
    // MARK: Variables/Constants
    
    weak var paymentDelegate: PaymentDelegate?
    
    private var articles: [Article] = []
    private var orderId: String = ""
    private var cardToken: String?
    
    
    // MARK: Initializers/Deinitializer
    
    public init(articles: [Article], orderId: String, delegate: PaymentDelegate?) {
        super.init(nibName: nil, bundle: nil)
        
        self.orderId         = orderId
        self.articles        = articles
        self.paymentDelegate = delegate
        
        self.customInit()
    }
    
    public convenience init(articles: [Article], orderId: String, cardToken: String, delegate: PaymentDelegate?) {
        self.init(articles: articles, orderId: orderId, delegate: delegate)
        
        self.cardToken = cardToken
        self.customInit()
    }
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    deinit {
        self.paymentDelegate = nil
    }
    
    
    // MARK: Controller Methods
    
    public override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        if ICMobilePaymentManager.shared.isInitialized {
            return
        }
        
        ICLogger.log("SDK not initialized")
        self.paymentDelegate?.paymentFailed(error: MobilePaymentSDKError.notInitialized)
        self.dismiss(animated: true, completion: nil)
    }
    
    
    // MARK: Private Methods
    
    private func customInit() {
        guard let paymentController = ICUtil.paymentController else {
            return
        }
        
        paymentController.orderId                = self.orderId
        paymentController.articles               = self.articles
        paymentController.cardToken              = self.cardToken
        paymentController.paymentDelegate        = self.paymentDelegate
        paymentController.cardVerificationAmount = ICUtil.articlesTotalAmount(self.articles)
        
        self.viewControllers = [paymentController]
    }
}
