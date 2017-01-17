//
//  ICCardView.swift
//  MobilePaymentSDK
//
//  Created by Valio Cholakov on 1/12/17.
//  Copyright © 2017 Intercard Finance AD. All rights reserved.
//

import UIKit
import MobilePaymentSDKUtils

class ICCardView: UIView, UITextFieldDelegate, BSKeyboardControlsDelegate {
    
    // MARK: Outlets
    
    @IBOutlet private weak var scrollView: TPKeyboardAvoidingScrollView!
    @IBOutlet private weak var panLabel: UILabel!
    @IBOutlet private weak var panTextField: ICThemedTextField!
    @IBOutlet private weak var expiryDateLabel: UILabel!
    @IBOutlet private weak var expiryDateTextField: ICThemedTextField!
    @IBOutlet private weak var cvcLabel: UILabel!
    @IBOutlet private weak var cvcTextField: ICThemedTextField!
    @IBOutlet private weak var embossNameLabel: UILabel!
    @IBOutlet private weak var embossNameTextField: ICThemedTextField!
    @IBOutlet private weak var customNameLabel: UILabel!
    @IBOutlet private weak var customNameTextField: ICThemedTextField!
    
    
    // MARK: Variables/Constants
    
    weak var delegate: ICCardViewDelete?
    private let _keyboardControls = BSKeyboardControls()
    
    
    // MARK: Public Methods
    
    class func cardViewWithFrame(_ frame: CGRect, delegate: ICCardViewDelete?) -> ICCardView? {
        guard let cardView = self.cardViewFromNib else {
            return nil
        }
        
        cardView.delegate = delegate
        
        cardView.customInit()
        cardView.localize()
        cardView.applyTheme()
        
        return cardView
    }
    
    var pan: String {
        return self.panTextField.text ?? ""
    }
    
    var cvc: String {
        return self.cvcTextField.text ?? ""
    }
    
    var expiryDate: String {
        return self.expiryDateTextField.text ?? ""
    }
    
    var embossName: String {
        return self.embossNameTextField.text ?? ""
    }
    
    var customName: String {
        return self.customNameTextField.text ?? ""
    }
    
    
    // MARK: Private Methods
    
    private func customInit() {
        let fields = [self.panTextField, self.expiryDateTextField, self.cvcTextField, self.embossNameTextField, self.customNameTextField]
        
        for field in fields {
            field?.delegate = self
        }
        
        _keyboardControls.fields   = fields
        _keyboardControls.delegate = self
    }
    
    private func localize() {
        self.panLabel.text        = ICLocalization.localized("Card number")
        self.expiryDateLabel.text = ICLocalization.localized("Expiry date")
        self.cvcLabel.text        = ICLocalization.localized("CVC")
        self.embossNameLabel.text = ICLocalization.localized("Emboss name")
        self.customNameLabel.text = ICLocalization.localized("Custom name")
        
        self.panTextField.placeholder        = ICLocalization.localized("Enter card number")
        self.cvcTextField.placeholder        = ICLocalization.localized("Enter CVC code")
        self.embossNameTextField.placeholder = ICLocalization.localized("Enter name on card")
        self.customNameTextField.placeholder = ICLocalization.localized("Enter custom name")
    }
    
    private func applyTheme() {
        
    }
    
    private static var cardViewFromNib: ICCardView? {
        guard let nibs = Bundle(for: ICCardView.self).loadNibNamed(String(describing: ICCardView.classForCoder()), owner: nil, options: nil) else {
            return nil
        }
        
        guard let cardView = nibs.first as? ICCardView else {
            return nil
        }
        
        return cardView
    }
    
    
    // MARK: Text Field Delegate
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField.isEqual(self.embossNameTextField) {
            _ = self.customNameTextField.becomeFirstResponder()
        } else if textField.isEqual(self.customNameTextField) {
            textField.resignFirstResponder()
        }
        
        return false
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        _keyboardControls.activeField = textField
        
        self.scrollView.scrollToActiveTextField()
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        _keyboardControls.activeField = nil
    }
    
    
    // MARK: Keyboard Controls Delegate
    
    func keyboardControlsDonePressed(_ keyboardControls: BSKeyboardControls) {
        keyboardControls.activeField?.resignFirstResponder()
    }
    
    func keyboardControls(_ keyboardControls: BSKeyboardControls!, selectedField field: UIView!, in direction: BSKeyboardControlsDirection) {
        field.becomeFirstResponder()
    }
}

protocol ICCardViewDelete: NSObjectProtocol {
    
}
