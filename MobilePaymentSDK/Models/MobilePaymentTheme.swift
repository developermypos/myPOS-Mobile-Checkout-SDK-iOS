//
//  Theme.swift
//  MobilePaymentSDK
//
//  Created by Valio Cholakov on 12/29/16.
//  Copyright © 2016 Intercard Finance AD. All rights reserved.
//

import UIKit

public struct MobilePaymentTheme {
    
    // MARK: Variables
    
    public var textFieldFont: UIFont
    public var labelTextColor: UIColor
    public var placeholderColor: UIColor
    public var barButtonItemColor: UIColor
    public var textFieldTextColor: UIColor
    public var navigationTitleColor: UIColor
    private(set) var placeholderFontSize: CGFloat
    private(set) var textFieldBorderColor: UIColor
    private(set) var placeholderAlignment: NSTextAlignment
    
    
    // MARK: Initializers
    
    public init() {
        self.textFieldFont        = UIFont.systemFont(ofSize: 14.0)
        self.labelTextColor       = UIColor.defaultTextColor
        self.placeholderColor     = UIColor.lightGray
        self.barButtonItemColor   = UIColor.buttonEnabled
        self.textFieldTextColor   = UIColor.defaultTextColor
        self.placeholderFontSize  = 13.0
        self.textFieldBorderColor = UIColor.gray.withAlphaComponent(0.3)
        self.navigationTitleColor = UIColor.defaultTextColor
        self.placeholderAlignment = .left
    }
}
