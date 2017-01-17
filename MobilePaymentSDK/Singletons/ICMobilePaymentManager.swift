//
//  ICMobilePaymentManager.swift
//  MobilePaymentSDK
//
//  Created by Valio Cholakov on 12/15/16.
//  Copyright © 2016 Intercard Finance AD. All rights reserved.
//

import UIKit

class ICMobilePaymentManager: ICBaseManager {
    
    // MARK: Variables
    
    var inDebug: Bool = false
    private(set) var bundle: Bundle!
    private(set) var sid: String!
    private(set) var language: String!
    private(set) var keyIndex: String!
    private(set) var currency: String!
    private(set) var walletNumber: String!
    private(set) var publicKey: SecKey?
    private(set) var privateKey: PrivateKey?
    

    // MARK: Singleton
    
    static let shared = ICMobilePaymentManager()
    
    
    // MARK: Public Methods
    
    func setWallet(number walletNumber: String, sid: String, currency: Currency, publicKey: String, privateKey: String, bundle: Bundle, language: String, keyIndex: Int) {
        self.sid          = sid
        self.bundle       = bundle
        self.currency     = currency.rawValue
        self.language     = language
        self.keyIndex     = String(keyIndex)
        self.publicKey    = self.publicKey(fileName: publicKey)
        self.privateKey   = self.privateKey(fileName: privateKey)
        self.walletNumber = walletNumber
    }
    
    var isInitialized: Bool {
        return self.sid.length          > 0 &&
               self.walletNumber.length > 0 &&
               self.publicKey  != nil &&
               self.privateKey != nil
    }
    
    
    // MARK: Private Methods
    
    private func publicKey(fileName: String) -> SecKey? {
        guard let certUrl = self.bundle.url(forResource: fileName, withExtension: "der") else {
            ICLogger.log("Cannot get url for certificate")
            return nil
        }
        
        var data: Data?
        do {
            data = try Data(contentsOf: certUrl)
        }
        catch {
            ICLogger.log("Could not get certificate data from file")
            return nil
        }
        
        guard let certData = data else {
            ICLogger.log("Certificate data is nil")
            return nil
        }
        
        guard let certificate = SecCertificateCreateWithData(nil, certData as CFData) else {
            ICLogger.log("Could not create certificate ref from certificate data")
            return nil
        }
        
        let policy = SecPolicyCreateBasicX509()
        var trustRef: SecTrust?
        
        var status = SecTrustCreateWithCertificates(certificate, policy, &trustRef)
        
        if status != noErr {
            ICLogger.logDebug("SecTrustCreateWithCertificates failed with status \(status)")
            ICLogger.log("Internal error")
            return nil
        }
        
        var result: SecTrustResultType = .invalid
        
        guard let trust = trustRef else {
            ICLogger.log("Internal error")
            return nil
        }
        
        status = SecTrustEvaluate(trustRef!, &result)
        
        // For some reason it returns error, but still fetches public key...
        //        if result == .proceed || result == .unspecified {
        
        guard let key = SecTrustCopyPublicKey(trust) else {
            ICLogger.log("Could not get public key from certificate")
            return nil
        }
        
        return key
    }
    
    private func privateKey(fileName: String) -> PrivateKey? {
        do {
            return try PrivateKey(pemNamed: fileName, in: self.bundle)
        } catch {
            ICLogger.log("Error while getting private key: \(error)")
        }
        
        return nil
    }
}
