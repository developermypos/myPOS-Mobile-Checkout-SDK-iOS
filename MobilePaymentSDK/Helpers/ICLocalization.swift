//
//  ICLocalization.swift
//  MobilePaymentSDK
//
//  Created by Valio Cholakov on 12/29/16.
//  Copyright © 2016 Intercard Finance AD. All rights reserved.
//

import UIKit

struct ICLocalization {
    
    // MARK: Public Methods
    
    static func localized(_ string: String) -> String {
        return ICMobilePaymentManager.shared.bundle.localizedString(forKey: string, value: string, table: ICConstants.localizationsTable)
    }
}
