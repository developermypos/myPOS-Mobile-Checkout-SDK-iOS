//
//  ICApplicationManager.swift
//  MobilePaymentSDK
//
//  Created by Valio Cholakov on 1/9/17.
//  Copyright © 2017 Intercard Finance AD. All rights reserved.
//

import UIKit

class ICApplicationManager: ICBaseManager {
    
    // MARK: Private Variables
    
    fileprivate var _processingCommands = 0
    
    
    // MARK: Singleton
    
    static let shared = ICApplicationManager()

    
    // MARK: Public Methods
    
    func networkActivityDidStart() {
        _processingCommands += 1;
        updateNetworkActivityIndocator();
    }
    
    func networkActivityDidFinish() {
        _processingCommands -= 1;
        updateNetworkActivityIndocator();
    }
    
    
    // MARK: Private Methods
    
    fileprivate func updateNetworkActivityIndocator() {
        if _processingCommands < 0 {
            _processingCommands = 0
        }
        
        UIApplication.shared.isNetworkActivityIndicatorVisible = _processingCommands > 0
    }
}
