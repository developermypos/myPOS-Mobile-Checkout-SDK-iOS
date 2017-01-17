//
//  ICBaseViewController.swift
//  MobilePaymentSDK
//
//  Created by Valio Cholakov on 12/29/16.
//  Copyright © 2016 Intercard Finance AD. All rights reserved.
//

import UIKit
import MobilePaymentSDKUtils

class ICBaseViewController: UIViewController {
    
    // MARK: Initialziers
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    
    // MARK: Controller Methods
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.addListeners()
        self.localize()
        self.applyTheme()
    }
    
    @objc func applyTheme() {
        // Should be implemeted by inheriting controllers
    }
    
    func localize() {
        // Should be implemeted by inheriting controllers
    }
    
    deinit {
        self.removeListeners()
    }
    
    
    // MARK: Public Methods
    
    func showLoadingHUD() {
        self.hideLoadingHUD()
        
        guard let view = self.navigationController?.view else {
            return
        }
        
        MBProgressHUD.showAdded(to: view, animated: true)
    }
    
    func hideLoadingHUD() {
        guard let view = self.navigationController?.view else {
            return
        }
        
        MBProgressHUD.hide(for: view, animated: true)
    }
    
    
    // MARK: Private Methods
    
    private func addListeners() {
        NotificationCenter.default.addObserver(self, selector: #selector(applyTheme), name: ICNotifications.themeChanged, object: nil)
    }
    
    private func removeListeners() {
        NotificationCenter.default.removeObserver(self, name: ICNotifications.themeChanged, object: nil)
    }
}
