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
        MobilePaymentSDK.initialize(withAccountNumber: "40418263147",
                                    storeId: "96166",
                                    currency: .EUR,
                                    certificate: "public_cert",
                                    privateKey: "private_key",
                                    bundle: Bundle.main,
                                    keyIndex: 2,
                                    isSandbox: true)
        return true
    }
}

