//
//  AppDelegate.swift
//  Mobile Payment Test
//
//  Created by Valio Cholakov on 12/15/16.
//  Copyright © 2016 Intercard Finance AD. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        MPCheckout.initialize(withAccountNumber: "61938166610",
                              storeId: "000000000000010",
                              currency: .EUR,
                              certificate: "public_cert",
                              privateKey: "private_key",
                              bundle: .main,
                              keyIndex: 1,
                              isSandbox: true)
        
        return true
    }
}

