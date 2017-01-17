//
//  UIColor+Helpers.swift
//  MobilePaymentSDK
//
//  Created by Valio Cholakov on 12/29/16.
//  Copyright © 2016 Intercard Finance AD. All rights reserved.
//

import UIKit

internal extension UIColor {
    
    // MARK: Public Methods
    
    internal static var buttonEnabled: UIColor {
        return UIColor.withHex(ICColors.enabled)
    }
    
    internal static var buttonDisabled: UIColor {
        return UIColor.withHex(ICColors.disabled)
    }
    
    internal static var navigationBarDefaultColor: UIColor {
        return self.colorWithRGB(247.0 / 255.0)
    }
    
    internal static var backgroundGray: UIColor {
        return self.withHex(ICColors.backgroundGray)
    }
    
    internal static var navigationBarDefaultBackgroundColor: UIColor {
        return self.colorWithRGB(246.0 / 255.0)
    }
    
    internal static var defaultTextColor: UIColor {
        return UIColor.black
    }
    
    internal static var defaultPlaceholderColor: UIColor {
        return UIColor.black
    }
    
    
    // MARK: Private Methods
    
    private class func colorWithRGB(_ rgb: CGFloat) -> UIColor {
        return self.colorWithRGB(rgb, alpha: 1.0)
    }
    
    private class func colorWithRGB(_ rgb: CGFloat, alpha: CGFloat) -> UIColor {
        return UIColor(red: rgb, green: rgb, blue: rgb, alpha: alpha)
    }
}
