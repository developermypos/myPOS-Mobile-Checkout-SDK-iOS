//
//  ICCardViewController.swift
//  MobilePaymentSDK
//
//  Created by Valio Cholakov on 1/12/17.
//  Copyright © 2017 Intercard Finance AD. All rights reserved.
//

import UIKit

class ICCardViewController: ICBaseViewController, IC3DSecureDelegate, ICCardViewDelete {

    // MARK: Outlets
    
    @IBOutlet weak var cancelButton: UIBarButtonItem!
    @IBOutlet weak var confirmButton: UIBarButtonItem!
    @IBOutlet weak var contentView: UIView!
    
    
    // MARK: Variables
    
    var cardView: ICCardView!
    var cardData: [String : Any] = [:]
    var extraData: [String : String]?
    var cardVerificationAmount: String!
    weak var paymentDelegate: PaymentDelegate?
    weak var storeCardDelegate: StoreCardDelegate?
    
    
    // MARK: Constants
    
    let kSecureSegue = "3DSecure"
    
    
    // MARK: Controller Methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.customInit()
    }
    
    override func localize() {
        super.localize()
        
        self.cancelButton.title = ICLocalization.localized("Cancel")
    }
    
    
    // MARK: Deinitialzier (just in case)
    
    deinit {
        self.extraData         = nil
        self.paymentDelegate   = nil
        self.storeCardDelegate = nil
    }
    
    
    // MARK: Navigation
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == kSecureSegue {
            guard let navigationController = segue.destination as? UINavigationController else {
                return
            }
            
            guard let secureController = navigationController.viewControllers.first as? IC3DSecureWebViewController else {
                return
            }
            
            guard let card = self.card else {
                return
            }
            
            guard let urlRequest = ICUtil.cardValidationURLRequest(card: card, cardData: self.cardData, amount: self.cardVerificationAmount) else {
                return
            }
            
            secureController.delegate   = self
            secureController.urlRequest = urlRequest
        }
    }
    
    
    // MARK: Actions
    
    @IBAction func cancel(_ sender: UIBarButtonItem) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func confirm(_ sender: UIBarButtonItem) {
        self.showLoadingHUD()
        ICCommunicationManager.shared.getCardData(pan: self.cardView.pan, completed: self.getCardDataCompleted, failed: self.getCardDataFailed)
    }
    
    
    // MARK: 3DSecure Delegate
    
    func didCancel3DS() {
        ICLogger.log("Card verified failed - canceled by user")
    }
    
    func didReceive3DSecureResponse(_ response: NSDictionary) {
        self.extraData = nil
        
        ICLogger.logDebug("3DS response: \(response)")
        
        guard let status = response[IC3DSParameters.status] as? Int else {
            ICLogger.logDebug("3DS response did not return status")
            return
        }
        
        if status == SecureResponseStatus.paramError || status == SecureResponseStatus.otherParamError {
            ICLogger.log("Invalid card data")
            return
        }
        
        if status != ICResponseStatus.ok {
            ICLogger.logDebug("3DS error")
            return
        }
        
        guard let avv  = response[IC3DSParameters.avv]  as? String,
              let eci  = response[IC3DSParameters.eci]  as? String,
              let xid  = response[IC3DSParameters.xid]  as? String,
              let cavv = response[IC3DSParameters.cavv] as? String else {
                ICLogger.logDebug("Missing avv, eci, xid or cavv")
                return
        }
        
        self.extraData = [
            IC3DSParameters.avv           : avv,
            IC3DSParameters.eci           : eci,
            IC3DSParameters.xid           : xid,
            IC3DSParameters.cavv          : cavv,
            ICParameters.cardType         : self.cardData[ICParameters.cardType] as? String ?? "",
            ICParameters.customerIdent    : ICConstants.customerIdent,
            ICParameters.cardVerification : "1"
        ]
        
        ICLogger.log("Card verified")
    }
    
    
    // MARK: Private Methods
    
    private func customInit() {
        self.contentView.layoutIfNeeded()
        
        guard let cardView = ICCardView.cardViewWithFrame(self.contentView.bounds, delegate: self) else {
            return
        }
        
        self.cardView = cardView
        self.contentView.addSubview(cardView)
    }
    
    internal func dismiss(completion: @escaping (() -> Void)) {
        self.hideLoadingHUD()
        self.dismiss(animated: true, completion: completion)
    }
    
    
    // MARK: Helpers
    
    internal var card: ICCard? {
        return ICCard(pan: self.cardView.pan, expiryDate: self.cardView.expiryDate, cvc: self.cardView.cvc, embossName: self.cardView.embossName, customName: self.cardView.customName)
    }
    
    private var getCardDataCompleted: (([String : Any]) -> Void) {
        return { (cardData) in
            self.hideLoadingHUD()
            
            guard let is3DSecure = cardData[ICParameters.is3DSecure] as? Int,
                  let cardType   = cardData[ICParameters.cardType]   as? String else {
                    
                self.dismiss(completion: { 
                    self.storeCardDelegate?.storeCardFailed(error: MobilePaymentSDKError.communicationError)
                })
                return
            }
            
            if is3DSecure == 1 {
                self.cardData = cardData
                self.performSegue(withIdentifier: self.kSecureSegue, sender: self)
                return
            }
            
            self.didReceive3DSecureResponse([
                IC3DSParameters.status : ICResponseStatus.ok,
                IC3DSParameters.avv    : "",
                IC3DSParameters.eci    : self.cardEci(cardType: cardType),
                IC3DSParameters.xid    : "",
                IC3DSParameters.cavv   : ""
                ]
            )
        }
    }
    
    private var getCardDataFailed: ((MobilePaymentSDKError) -> Void) {
        return { (error) in
            self.dismiss(completion: { 
                self.storeCardDelegate?.storeCardFailed(error: error)
            })
        }
    }
    
    private func cardEci(cardType: String) -> String {
        return String(cardType == ICCardType.mastercard || cardType == ICCardType.maestro ? 0 : 7)
    }
}
