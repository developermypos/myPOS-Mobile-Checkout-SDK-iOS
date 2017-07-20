//
//  ICBaseTableViewController.swift
//  Mobile Payment Test
//
//  Created by Valio Cholakov on 1/16/17.
//  Copyright © 2017 Intercard Finance AD. All rights reserved.
//

import UIKit
import MobilePaymentSDK

class ICBaseTableViewController: UITableViewController, PaymentDelegate, StoreCardDelegate {
    
    // MARK: Constants
    
    private let _HUD = JGProgressHUD(style: .dark)

    
    // MARK: Controller Methods

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.applyTheme()
    }
    
    
    // MARK: Payment Delegate
    
    func paymentDidComplete(withReference transactionReference: String) {
        self.showAlertWithText("Payment completed with reference: \(transactionReference)", popToRoot: true)
    }
    
    func paymentDidFailWithError(_ error: MobilePaymentSDKError) {
        self.showAlertWithText("Payment error: \(error.localizedDescription)")
//        self.showAlertWithText("Payment error: \(error.message)")
    }
    
    
    // MARK: Store Card Delegate
    
    func storeCardDidComplete(withToken cardToken: String, forCardWithName cardName: String) {
        self.showAlertWithText("Stored card \(cardName) with token \(cardToken)")
    }
    
    func storeCardDidFailWithError(_ error: MobilePaymentSDKError) {
        self.showAlertWithText("Store card error: \(error.localizedDescription)")
//        self.showAlertWithText("Store card error: \(error.message)")
    }
    
    func updateStoredCardDidComplete(withToken cardToken: String, forCardWithName cardName: String) {
        self.showAlertWithText("Updated stored card \(cardName). New token \(cardToken)")
    }
    
    func updateStoredCardDidFailWithError(_ error: MobilePaymentSDKError) {
        self.showAlertWithText("Update stored card error: \(error.localizedDescription)")
//        self.showAlertWithText("Update stored card error: \(error.message)")
    }
    
    public func didMakePayment(transactionRef: String) {
        self.paymentDidComplete(withReference: transactionRef)
    }
    
    func paymentFailed(error: MobilePaymentSDKError) {
        self.paymentDidFailWithError(error)
    }
    
    public func didStoreCard(cardToken: String, customName: String) {
        self.storeCardDidComplete(withToken: cardToken, forCardWithName: customName)
    }
    
    func storeCardFailed(error: MobilePaymentSDKError) {
        self.storeCardDidFailWithError(error)
    }
    
    func didUpdateStoredCard(cardToken: String, customName: String) {
        self.updateStoredCardDidComplete(withToken: cardToken, forCardWithName: customName)
    }
    
    func updateStoredCardFailed(error: MobilePaymentSDKError) {
        self.updateStoredCardDidFailWithError(error)
    }
    
    
    // MARK: Public Methods
    
    func showLoadingHUD() {
        _HUD?.show(in: self.view)
    }
    
    func hideLoadingHUD() {
        self._HUD?.dismiss()
    }
    
    func showAlertWithText(_ text: String) {
        self.showAlertWithText(text, popToRoot: false)
    }
    
    func showAlertWithText(_ text: String, popToRoot: Bool) {
        let alertController = UIAlertController(title: "Demo", message: text, preferredStyle: .alert)
        let okAction        = UIAlertAction(title: "Ok", style: .default) { (_) in
            if popToRoot {
                _ = self.navigationController?.popToRootViewController(animated: true)
            }
        }
        
        
        alertController.addAction(okAction)
        
        self.present(alertController, animated: true, completion: nil)
    }
    
    
    // MARK: Private Methods
    
    private func applyTheme() {
        let rgb: Float = 247.0 / 255.0
        
        self.tableView.tableFooterView = UIView()
        self.tableView.backgroundColor = UIColor.init(colorLiteralRed: rgb, green: rgb, blue: rgb, alpha: 1.0)
    }
}
