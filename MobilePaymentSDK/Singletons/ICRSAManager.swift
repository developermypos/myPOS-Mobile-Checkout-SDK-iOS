//
//  ICRSAManager.swift
//  MobilePaymentSDK
//
//  Created by Valio Cholakov on 1/3/17.
//  Copyright © 2017 Intercard Finance AD. All rights reserved.
//

import UIKit
import Security
import MobilePaymentSDKUtils

class ICRSAManager: ICBaseManager {
    
    // MARK: Singleton
    
    static let shared = ICRSAManager()
    
    
    // MARK: Public Methods
    
    func signString(_ str: String?) -> String? {
        guard let string = str else {
            ICLogger.log("Cannot sign nil")
            return nil
        }
        
        ICLogger.logDebug("Base64 data to sign: \(string)")
        
        guard let privateKey = ICMobilePaymentManager.shared.privateKey else {
            ICLogger.log("Could not load private key")
            return nil
        }
        
        do {
            let clear  = try ClearMessage(string: string, using: .utf8)
            let signed = try clear.signed(with: privateKey, digestType: .sha256)
            
            return signed.base64String
        } catch {
            ICLogger.logDebug("Error: \(error)")
        }
        
        return nil
    }
    
    func signatureIsValid(_ str: String?, plain: String?) -> Bool {
        guard let signed      = str,
              let plainString = plain else {
                ICLogger.logDebug("Cannot validate nil signature")
                return false
        }
        
        guard let publicKey = ICMobilePaymentManager.shared.publicKey else {
            ICLogger.logDebug("Could not get public key")
            return false
        }
        
        return CryptoUtil.signatureIsValid(signed, plain: plainString, publicKey: publicKey)
    }
    
    func encryptedString(_ str: String?) -> String? {
        guard let string = str else {
            ICLogger.logDebug("Cannot encyrpt nil")
            return nil
        }
        
        guard let publicKey = ICMobilePaymentManager.shared.publicKey else {
            ICLogger.log("Could not get public key")
            return nil
        }
        
        guard let encryptedData = CryptoUtil.encryptString(string, with: publicKey, padding: .PKCS1) else {
            ICLogger.logDebug("Encryption failed")
            return nil
        }
        
        return encryptedData.base64EncodedString()
    }
    
    func decryptedString(_ str: String?) -> String? {
        guard let string = str else {
            return nil
        }
        
        guard let privateKey = ICMobilePaymentManager.shared.privateKey else {
            ICLogger.log("Could not load private key")
            return nil
        }
        
        do {
            let encrypted = try EncryptedMessage(base64Encoded: string)
            let decrypted = try encrypted.decrypted(with: privateKey, padding: .PKCS1)
            let plain     = try decrypted.string(encoding: .utf8)
            
            return plain
        } catch {
            ICLogger.logDebug("Error: \(error)")
        }
        
        return nil
    }
}
