//
//  ICThemedTextField.swift
//  MobilePaymentSDK
//
//  Created by Valio Cholakov on 12/29/16.
//  Copyright © 2016 Intercard Finance AD. All rights reserved.
//

import UIKit

class ICThemedTextField: UITextField  {
    
    // MARK: Properties
    
    fileprivate var _bottomBorder: CALayer?
    
    open var placeholderAlignment: NSTextAlignment? {
        didSet { self.redrawPlaceholder() }
    }
    
    open var placeholderColor: UIColor? {
        didSet { self.redrawPlaceholder() }
    }
    
    open var placeholderFontSize: CGFloat? {
        didSet { self.redrawPlaceholder() }
    }
    
    open var borderColor: UIColor? {
        didSet { self.redrawPlaceholder() }
    }
    
    
    // MARK: Initializers
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.customInit()
    }
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)!
        
        self.customInit()
    }
    
    
    // MARK: Overrides
    
    override func becomeFirstResponder() -> Bool {
        return super.becomeFirstResponder()
    }
    
    override func resignFirstResponder() -> Bool {
        let outcome = super.resignFirstResponder()
        
        if (outcome) {
            // Maybe format text?
        }
        
        return outcome
    }
    
    override func drawPlaceholder(in rect: CGRect) {
        guard let placeholder = self.placeholder else {
            return
        }
        
        var xOrigin: CGFloat = 0.0
        
        let placeholderFont = ICThemeManager.shared.lightFont(self.placeholderFontSize ?? self.theme.placeholderFontSize)
        
        let textStyle           = NSMutableParagraphStyle()
        textStyle.lineBreakMode = .byWordWrapping
        
        let attributes = [
            NSFontAttributeName            : placeholderFont,
            NSParagraphStyleAttributeName  : textStyle,
            NSForegroundColorAttributeName : self.placeholderColor ?? self.theme.placeholderColor
        ]
        
        let placeholderSize = (placeholder as NSString).boundingRect(with: CGSize(width: rect.size.width,
                                                                                  height: rect.size.height),
                                                                     options: [.usesFontLeading, .usesLineFragmentOrigin],
                                                                     attributes: attributes,
                                                                     context: nil).size
        
        let alignment = self.placeholderAlignment ?? self.theme.placeholderAlignment
        
        if alignment == .left {
            xOrigin = ICConstants.textFieldInsets
        }
        else if alignment == .center {
            xOrigin = (rect.size.width - placeholderSize.width) / 2
        }
        else if alignment == .right {
            xOrigin = rect.size.width - placeholderSize.width - ICConstants.textFieldInsets
        }
        
        let placeholderRect = CGRect(x: xOrigin,
                                     y: (rect.size.height - placeholderSize.height) / 2,
                                     width: placeholderSize.width,
                                     height: placeholderSize.height)
        
        (placeholder as NSString).draw(in: placeholderRect, withAttributes: attributes)
    }
    
    override func draw(_ rect: CGRect) {
        if _bottomBorder == nil {
            _bottomBorder              = CALayer()
            _bottomBorder!.borderColor = (self.borderColor ?? self.theme.textFieldBorderColor).cgColor
            _bottomBorder!.borderWidth = ICConstants.separatorHeight
            _bottomBorder!.frame       = CGRect(x: 0.0,
                                                y: self.bounds.size.height - ICConstants.separatorHeight,
                                                width: self.bounds.size.width,
                                                height: ICConstants.separatorHeight)
            
            self.layer.addSublayer(_bottomBorder!)
            self.layer.masksToBounds = true
        }
        
        super.draw(rect)
    }
    
    
    // MARK: Private Methods
    
    private func customInit() {
        self.borderStyle              = .none
        self.contentVerticalAlignment = .center
        
        self.font      = self.theme.textFieldFont
        self.textColor = self.theme.textFieldTextColor
    }
    
    private func redrawPlaceholder() {
        guard let placeholder = self.placeholder else {
            return
        }
        
        self.placeholder = nil
        self.placeholder = placeholder
    }
    
    
    // MARK: Helpers
    
    private var theme: MobilePaymentTheme {
        return ICThemeManager.shared.theme
    }
}
