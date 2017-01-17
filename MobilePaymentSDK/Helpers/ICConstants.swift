//
//  ICConstants.swift
//  MobilePaymentSDK
//
//  Created by Valio Cholakov on 12/15/16.
//  Copyright © 2016 Intercard Finance AD. All rights reserved.
//

import UIKit

struct ICConstants {
    
    static let signaturePadding: SecPadding = .PKCS1
    
    static let communicationTimeout: TimeInterval = 30.0
    
    static let separatorHeight: CGFloat = 1.0
    static let textFieldInsets: CGFloat = 4.0
    
    static let ipcVersion             = "1.2"
    static let outputFormat           = "json"
    static let source                 = "2"
    static let errorDomain            = "mobilePaymentSDKErrorDomain"
    static let storyboardName         = "Storyboard"
    static let localizationsTable     = "MobilePaymentSDK"
    static let channel                = "2"
    static let contentType            = "Content-Type"
    static let urlEncodedContentType  = "application/x-www-form-urlencoded"
    static let customerIdent          = "Store\(ICMobilePaymentManager.shared.sid ?? "")"
    static let sdkVersion: String     = {
        guard let infoDictionary = Bundle(for: ICBaseManager.self).infoDictionary else {
            return ""
        }
        
        guard let version = infoDictionary["CFBundleShortVersionString"] as? String else {
            return ""
        }
        
        return version
    }()
}

struct ICColors {
    
    static let enabled        = "0077C1"
    static let disabled       = "7ABAE5"
    static let separator      = "DADADA"
    static let backgroundGray = "F9F9F9"
}

struct ICMethods {
    
    static let refund               = "IPCRefund"
    static let purchase             = "IPCIAPurchase"
    static let reversal             = "IPCReversal"
    static let storeCard            = "IPCIAStoreCard"
    static let getCardData          = "IPCIATdsBin"
    static let updateStoredCard     = "IPCIAStoredCardUpdate"
    static let getTransactionStatus = "IPCIAGetTxnStatus"
}

struct ICParameters {
    
    static let mid               = "MID"
    static let bin               = "BIN"
    static let pan               = "PAN"
    static let cvc               = "CVC"
    static let eci               = "ECI"
    static let avv               = "AVV"
    static let xid               = "XID"
    static let sid               = "SID"
    static let data              = "data"
    static let price             = "Price"
    static let amount            = "Amount"
    static let source            = "source"
    static let method            = "IPCMethod"
    static let status            = "Status"
    static let channel           = "Channel"
    static let version           = "version"
    static let orderId           = "OrderID"
    static let article           = "Article"
    static let cardType          = "CardType"
    static let walletId          = "WalletID"
    static let quantity          = "Quantity"
    static let keyIndex          = "KeyIndex"
    static let currency          = "Currency"
    static let language          = "IPCLanguage"
    static let signature         = "Signature"
    static let cartItems         = "CartItems"
    static let cardToken         = "CardToken"
    static let ipcVersion        = "IPCVersion"
    static let customName        = "CustomName"
    static let is3DSecure        = "Enabled3DS"
    static let DSecureBin        = "3ds_bin"
    static let embossName        = "CardholderName"
    static let expiryDate        = "ExpDate"
    static let walletNumber      = "walletnumber"
    static let outputFormat      = "OutputFormat"
    static let statusMessage     = "StatusMsg"
    static let customerIdent     = "CustomerIdent"
    static let transactionRef    = "IPC_Trnref"
    static let cardVerification  = "CardVerification"
    static let billingDescriptor = "BillingDescriptor"
    static let transactionStatus = "TrnStatus"
    static let transactionRef2   = "TrnRef"
}

struct IC3DSParameters {
    
    static let pan               = "pan"
    static let mid               = "mid"
    static let bin               = "bin"
    static let avv               = "avv"
    static let eci               = "eci"
    static let xid               = "xid"
    static let cavv              = "cavv"
    static let amount            = "amount"
    static let status            = "status"
    static let walletId          = "wallet_id"
    static let currency          = "currency"
    static let expiryYear        = "exp_y"
    static let expiryMonth       = "exp_m"
    static let billingDescriptor = "billing_descriptor"
}

struct httpMethod {
    
    static let get  = "GET"
    static let post = "POST"
}

struct ICUrls {
    static let api    = "https://devs.icards.eu/mypos.eu/branches/ipc_ia/vmp/checkout"
    static let secure = "https://devs.icards.eu/mypos_tdsgateway/"
}

struct ICCardType {
    
    static let mastercard   = "1"
    static let maestro      = "2"
    static let visa         = "3"
    static let visaElectron = "4"
    static let vpay         = "5"
    static let jcb          = "6"
}
