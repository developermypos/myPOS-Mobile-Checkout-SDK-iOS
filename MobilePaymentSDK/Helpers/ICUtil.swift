//
//  ICUtil.swift
//  MobilePaymentSDK
//
//  Created by Valio Cholakov on 12/29/16.
//  Copyright © 2016 Intercard Finance AD. All rights reserved.
//

import UIKit
import MobilePaymentSDKUtils

public enum Currency: String {
    case hrk = "HRK"
    case czk = "CZK"
    case dkk = "DKK"
    case huf = "HUF"
    case isk = "ISK"
    case nok = "NOK"
    case sek = "SEK"
    case chf = "CHF"
    case gbp = "GBP"
    case usd = "USD"
    case ron = "RON"
    case bgn = "BGN"
    case eur = "EUR"
    case pln = "PLN"
    case unknown = ""
}

public enum TransactionType: Int {
    case refund
    case purchase
}

private enum ICControllerIdentifier: String {
    case payment          = "Payment"
    case storeCard        = "StoreCard"
    case updateStoredCard = "UpdateStoredCard"
}

struct ICUtil {
    
    // MARK: Constants
    
    static private let kContentType        = "Content-Type"
    static private let kContentLength      = "Content-Length"
    static private let kURLEncodedType     = "application/x-www-form-urlencoded"
    
    
    // MARK: Public Methods
    
    static var paymentController: ICPaymentViewController? {
        return self.controller(identifier: .payment) as? ICPaymentViewController
    }
    
    static var storeCardController: ICStoreCardViewController? {
        return self.controller(identifier: .storeCard) as? ICStoreCardViewController
    }
    
    static var updateStoredCardController: ICUpdateStoredCardViewController? {
        return self.controller(identifier: .updateStoredCard) as? ICUpdateStoredCardViewController
    }
    
    static func signedData(_ data: [String : String]) -> String? {
        var dataToSign = ""
        
        for (_, value) in data {
            dataToSign = "\(dataToSign)-\(value)"
        }
        
        dataToSign = dataToSign.substring(from: 1)
        
        ICLogger.logDebug("Data to sign: \(dataToSign)")
        
        return ICRSAManager.shared.signString(dataToSign.base64Encoded())
    }
    
    static func cardValidationURLRequest(card: ICCard, cardData: [String : Any], amount: String) -> URLRequest? {
        guard let mid         = cardData[ICParameters.mid] as? String,
              let bin         = cardData[ICParameters.bin] as? String,
              let billingDesc = cardData[ICParameters.billingDescriptor] as? String else {
                ICLogger.log("Missing card data. Verification failed")
                return nil
        }
        
        let json: [String : String] = [
            IC3DSParameters.pan         : card.pan,
            IC3DSParameters.expiryYear  : card.expiryYear,
            IC3DSParameters.expiryMonth : card.expiryMonth
        ]
        
        var jsonData: Data?
        
        ICLogger.logDebug("3DS - JSON: \(json)")
        
        do {
            jsonData = try JSONSerialization.data(withJSONObject: json, options: .prettyPrinted)
        } catch {
            ICLogger.logDebug("Error while parsing json")
            return nil
        }
        
        guard let data = jsonData else {
            ICLogger.logDebug("Error while parsing json")
            return nil
        }
        
        guard let jsonString = String(data: data, encoding: .utf8) else {
            ICLogger.logDebug("Error while parsing bytes to string")
            return nil
        }
        
        guard let encryptedData = jsonString.encrypted else {
            ICLogger.logDebug("Internal error during encryption")
            return nil
        }
        
        guard let walletId = cardData[ICParameters.walletId] as? String else {
            ICLogger.logDebug("3DS - Wallet id not found")
            return nil
        }
        
        let body = "\(ICParameters.data)=\(encryptedData.urlEncoded())&" +
                   "\(IC3DSParameters.walletId)=\(walletId.urlEncoded())&" +
                   "\(ICParameters.sid.lowercased())=\(ICMobilePaymentManager.shared.sid.urlEncoded())&" +
                   "\(ICParameters.source)=\(ICConstants.source.urlEncoded())&" +
                   "\(IC3DSParameters.mid)=\(mid.urlEncoded())&" +
                   "\(IC3DSParameters.bin)=\(bin.urlEncoded())&" +
                   "\(IC3DSParameters.billingDescriptor)=\(billingDesc.urlEncoded())&" +
                   "\(IC3DSParameters.amount)=\(amount.urlEncoded())&" +
                   "\(IC3DSParameters.currency)=\(ICMobilePaymentManager.shared.currency.urlEncoded())"
        
//        ICLogger.log("3DS - body: \(body)")
        
        guard let url = URL(string: ICUrls.secure) else {
            ICLogger.logDebug("Invalid communication URL")
            return nil
        }
        
        guard let httpBody = body.data(using: .utf8) else {
            ICLogger.logDebug("Could not get bytes of body")
            return nil
        }
        
        var request = URLRequest(url: url)
        
        request.httpMethod = httpMethod.post
        request.httpBody   = httpBody
        
        request.setValue(kURLEncodedType,        forHTTPHeaderField: kContentType)
        request.setValue(String(httpBody.count), forHTTPHeaderField: kContentLength)
        
        return request
    }
    
    static func articlesTotalAmount(_ articles: [Article]) -> String {
        var amount: Double = 0.0
        
        for article in articles {
            amount += article.amount.double
        }
        
        return amount.formatted
    }
    
    
    // MARK: Private Methods
    
    private static func controller(identifier: ICControllerIdentifier) -> UIViewController {
        let bundle     = Bundle(for: ICMobilePaymentManager.self)
        let storyboard = UIStoryboard(name: ICConstants.storyboardName, bundle: bundle)
        let controller = storyboard.instantiateViewController(withIdentifier: identifier.rawValue)
        
        return controller
    }
}
