//
//  ICThemeManager.swift
//  MobilePaymentSDK
//
//  Created by Valio Cholakov on 12/29/16.
//  Copyright © 2016 Intercard Finance AD. All rights reserved.
//

import UIKit

class ICThemeManager: ICBaseManager {
    
    // MARK: Enums
    
    enum ICFontStyle {
        case `default`
        case italic
        case medium
        case mediumItalic
        case bold
        case light
        case lightItalic
        case thin
        case thinItalic
    }
    
    enum ICFont: String {
        case Default      = "HelveticaNeue"
        case Bold         = "HelveticaNeue-Bold"
        case Italic       = "HelveticaNeue-Italic"
        case Medium       = "HelveticaNeue-Medium"
        case MediumItalic = "HelveticaNeue-MediumItalic"
        case Light        = "HelveticaNeue-Light"
        case LightItalic  = "HelveticaNeue-LightItalic"
        case Thin         = "HelveticaNeue-Thin"
        case ThinItalic   = "HelveticaNeue-ThinItalic"
    }
    
    enum ICLabelColor: String {
        case Default          = "defaultLabelFontColor"
        case Gray             = "grayLabelFontColor"
        case LightGray        = "lightGrayLabelFontColor"
        case DarkGray         = "darkGrayLabelFontColor"
        case White            = "whiteLabelFontColor"
        case Green            = "greenLabelFontColor"
        case Red              = "redLabelFontColor"
        case Blue             = "blueLabelFontColor"
        case DarkGrayIntro    = "dakrGrayIntroFontColor"
        case DarkRed          = "darkRedFontColor"
        case DarkGreen        = "darkGreenFontColor"
        case PlaceholderLight = "labelColorPlaceholderLight"
        case LeuPayBlue       = "leuPayBlueFontColor"
    }
    
    enum ICTextFieldColor: String {
        case Default     = "textFieldFontColor"
        case Placeholder = "textFieldPlaceholderColor"
        case Gray        = "grayTextFieldFontColor"
        case White       = "whiteTextFieldFontColor"
        case Green       = "greenTextFieldFontColor"
        case Red         = "redTextFieldFontColor"
        case Blue        = "blueTextFieldFontColor"
        case LightGray   = "lightGrayTextFieldFontColor"
    }
    
    enum ICButtonTitleColor: String {
        case Gray        = "grayButtonTitleColor"
        case Blue        = "blueButtonTitleColor"
        case Yellow      = "yellowButtonTitleColor"
        case Highlighted = "highlightedButtonTitleColor"
        case Disabled    = "disabledButtonTitleColor"
        case Selected    = "selectedButtonTitleColor"
        case PureGray    = "grayColor"
    }
    
    enum ICSwitchColor: String {
        case On  = "switchOnTintColor"
        case Off = "switchMainTintColor"
    }
    
    
    // MARK: Variables
    
    var theme: MobilePaymentTheme {
        didSet {
            self.applyTheme()
        }
    }
    
    private let _hexColorsMap: [String : String] = [
        ICTextFieldColor.Default.rawValue       : "5B5B5B",
        ICTextFieldColor.LightGray.rawValue     : "4C4030",
        
        ICButtonTitleColor.Gray.rawValue        : "7D8082",
        ICButtonTitleColor.Blue.rawValue        : "0077C1",
        ICButtonTitleColor.Highlighted.rawValue : "FFFFFF",
        ICButtonTitleColor.Selected.rawValue    : "009EFF",
        ICButtonTitleColor.Disabled.rawValue    : "B2B2B2",
        ICButtonTitleColor.Yellow.rawValue      : "F9CE1F",
        ICButtonTitleColor.PureGray.rawValue    : "777777",
        
        ICLabelColor.Default.rawValue           : "000000",
        ICLabelColor.Gray.rawValue              : "7D8082",
        ICLabelColor.LightGray.rawValue         : "B8B8B8",
        ICLabelColor.DarkGray.rawValue          : "474747",
        ICLabelColor.White.rawValue             : "FFFFFF",
        ICLabelColor.Green.rawValue             : "26CE21",
        ICLabelColor.Red.rawValue               : "E43A2D",
        ICLabelColor.Blue.rawValue              : "0077C1",
        ICLabelColor.DarkGrayIntro.rawValue     : "5B5B5B",
        ICLabelColor.DarkRed.rawValue           : "92393C",
        ICLabelColor.DarkGreen.rawValue         : "407220",
        ICLabelColor.PlaceholderLight.rawValue  : "A6A6A6",
        ICLabelColor.LeuPayBlue.rawValue        : "0077C1",
        
        ICSwitchColor.Off.rawValue              : "7D8082",
        ICSwitchColor.On.rawValue               : "0077C1",
    ]
    
    
    // MARK: Constants
    
    private let kTextFieldFontSize: CGFloat          = 16.0
    private let kButtonFontSize: CGFloat             = 14.0
    private let kLabelMinimumFontSize: CGFloat       = 8.0
    private let kLabelDefaultFontSize: CGFloat       = 14.0
    private let kNavigationBarTitleFontSize: CGFloat = 16.0
    
    
    // MARK: Singleton
    
    static let shared = ICThemeManager()
    
    
    // MARK: Initializers
    
    override init() {
        self.theme = MobilePaymentTheme()
        
        super.init()
    }
    
    
    // MARK: Public Methods
    
    var textFieldDefaultFont: UIFont {
        return self.font(kTextFieldFontSize)
    }
    
    func font(_ size: CGFloat) -> UIFont {
        return self.font(ICFont.Default, size: size)
    }
    
    func italicFont(_ size: CGFloat) -> UIFont {
        return self.font(ICFont.Italic, size: size)
    }
    
    func mediumFont(_ size: CGFloat) -> UIFont {
        return self.font(ICFont.Medium, size: size)
    }
    
    func mediumItalicFont(_ size: CGFloat) -> UIFont {
        return self.font(ICFont.MediumItalic, size: size)
    }
    
    func boldFont(_ size: CGFloat) -> UIFont {
        return self.font(ICFont.Bold, size: size)
    }
    
    func lightFont(_ size: CGFloat) -> UIFont {
        return self.font(ICFont.Light, size: size)
    }
    
    func lightItalicFont(_ size: CGFloat) -> UIFont {
        return self.font(ICFont.LightItalic, size: size)
    }
    
    func thinFont(_ size: CGFloat) -> UIFont {
        return self.font(ICFont.Thin, size: size)
    }
    
    func thinItalicFont(_ size: CGFloat) -> UIFont {
        return self.font(ICFont.ThinItalic, size: size)
    }
    
    var textFieldFontColor: UIColor {
        return self.color(ICTextFieldColor.Default.rawValue)
    }
    
    var textPlaceholderColor: UIColor {
        return self.color(ICTextFieldColor.Placeholder.rawValue)
    }
    
    var redColor: UIColor {
        return self.color(ICLabelColor.Red.rawValue)
    }
    
    var navigatonBarFont: UIFont {
        return self.font(kNavigationBarTitleFontSize)
    }
    
    var defaultColor: UIColor {
        return self.color(ICLabelColor.Default.rawValue)
    }
    
    
    // MARK: Private Methods
    
    private func applyTheme() {
        NotificationCenter.default.post(name: ICNotifications.themeChanged, object: nil)
        
        UITextView.appearance().tintColor         = theme.textFieldTextColor
        UITextField.appearance().tintColor        = theme.textFieldTextColor
        UINavigationBar.appearance().tintColor    = theme.barButtonItemColor
        UIToolbar.appearance().tintColor          = theme.barButtonItemColor

        if #available(iOS 9.0, *) {
            let attributes = [
                NSForegroundColorAttributeName : theme.barButtonItemColor
            ]
            
            UIBarButtonItem.appearance(whenContainedInInstancesOf: [UISearchBar.self]).setTitleTextAttributes(attributes, for: UIControlState())
        }
    }
    
    private func safeColor(_ color: String) -> UIColor {
        let hex = _hexColorsMap[color]
        return hex != nil ? UIColor.withHex(hex!) : UIColor.white
    }
    
    private func font(_ font: ICFont, size: CGFloat) -> UIFont {
        return UIFont(name: font.rawValue, size: size)!
    }
    
    private func color(_ hex: String) -> UIColor {
        return UIColor.withHex(_hexColorsMap[hex]!)
    }
    
    private func font(_ style: ICFontStyle, size: CGFloat) -> UIFont {
        let theme = ICThemeManager.shared
        
        switch (style) {
        case .bold:
            return theme.boldFont(size)
            
        case .italic:
            return theme.italicFont(size)
            
        case .medium:
            return theme.mediumFont(size)
            
        case .mediumItalic:
            return theme.mediumItalicFont(size)
            
        case .light:
            return theme.lightFont(size)
            
        case .lightItalic:
            return theme.lightItalicFont(size)
            
        case .thin:
            return theme.thinFont(size)
            
        case .thinItalic:
            return theme.thinItalicFont(size)
            
        default:
            return theme.font(size)
        }
    }
}
