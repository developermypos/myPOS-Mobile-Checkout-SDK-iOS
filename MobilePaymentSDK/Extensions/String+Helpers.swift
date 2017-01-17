//
//  String+Helpers.swift
//  MobilePaymentSDK
//
//  Created by Valio Cholakov on 1/3/17.
//  Copyright © 2017 Intercard Finance AD. All rights reserved.
//

import Foundation

extension String {
    
    // MARK: Public Methods
    
    var length: Int {
        return self.characters.count
    }
    
    var int: Int {
        return (self as NSString).integerValue
    }
    
    var float: Float {
        return (self as NSString).floatValue
    }
    
    var double: Double {
        return (self as NSString).doubleValue
    }
    
    var encrypted: String? {
        return ICRSAManager.shared.encryptedString(self)
    }
    
    var decrypted: String? {
        return ICRSAManager.shared.decryptedString(self)
    }
    
    var signature: String? {
        return ICRSAManager.shared.signString(self)
    }
    
    var urlDecoded: String {
        return self.removingPercentEncoding ?? ""
    }
    
    func isValidSignature(of plainText: String) -> Bool {
        return ICRSAManager.shared.signatureIsValid(self, plain: plainText)
    }
    
    func substring(to: Int) -> String {
        let index = self.index(self.startIndex, offsetBy: to)
        return self.substring(to: index)
    }
    
    func substring(from: Int) -> String {
        let index = self.index(self.startIndex, offsetBy: from)
        return self.substring(from: index)
    }
    
    func substring(from: Int, to: Int) -> String {
        let start = self.index(self.startIndex, offsetBy: from)
        let end   = self.index(self.endIndex,   offsetBy: to)
        let range = start..<end
        
        return self.substring(with: range)
    }
}
