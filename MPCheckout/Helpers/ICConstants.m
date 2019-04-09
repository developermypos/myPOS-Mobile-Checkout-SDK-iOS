//
//  ICConstants.m
//  MPCheckout
//
//  Created by Valio Cholakov on 1/30/17.
//  Copyright © 2017 Intercard Finance AD. All rights reserved.
//

#import "ICConstants.h"

@implementation ICConstants

SecPadding const kSignaturePadding = kSecPaddingPKCS1;

NSTimeInterval const kCommunicationTimeout = 30.0f;

CGFloat const kSeparatorHeight     = 1.0f;
CGFloat const kTextFieldInsets     = 4.0f;
CGFloat const kNavigationBarHeight = 64.0f;

NSString * const kIPCVersion         = @"1.3";
NSString * const kOutputFormat       = @"json";
NSString * const kSource             = @"2";
NSString * const kCardVerification   = @"2";
NSString * const kErrorDomain        = @"MPCheckoutErrorDomain";
NSString * const kStoryboardName     = @"Storyboard";
NSString * const kLocalizationsTable = @"MPCheckout";
NSString * const kContentType        = @"Content-Type";
NSString * const kContentLength      = @"Content-Length";
NSString * const kURLEncoded         = @"application/x-www-form-urlencoded";

#pragma mark - Tags

NSString * const kPrivateKeyTag  = @"26f1315c-ebff-4ab6-av92-a7f732d24b9b";
NSString * const kCertificateTag = @"b7e3865f-ff74-4cca-999d-c293d929fec7";

#pragma mark - Response Statuses

NSInteger const ICResponseStatusOK                    = 0;
NSInteger const ICSecureResponseStatusOK              = 0;
NSInteger const ICSecureResponseStatusParamError      = 1;
NSInteger const ICSecureResponseStatusOtherParamError = 2;

#pragma mark - Colors

NSString * const ICColorEnabled        = @"0077C1";
NSString * const ICColorDisabled       = @"7ABAE5";
NSString * const ICColorSeparator      = @"DADADA";
NSString * const ICColorBackgroundGray = @"F9F9F9";

#pragma mark - Methods

NSString * const ICMethodRefund               = @"IPCRefund";
NSString * const ICMethodPurchase             = @"IPCIAPurchase";
NSString * const ICMethodReversal             = @"IPCReversal";
NSString * const ICMethodStoreCard            = @"IPCIAStoreCard";
NSString * const ICMethodGetCardData          = @"IPCIATdsBin";
NSString * const ICMethodUpdateStoredCard     = @"IPCIAStoredCardUpdate";
NSString * const ICMethodGetTransactionStatus = @"IPCIAGetTxnStatus";

#pragma mark - Parameters

NSString * const ICParameterMID                  = @"MID";
NSString * const ICParameterBIN                  = @"BIN";
NSString * const ICParameterPAN                  = @"PAN";
NSString * const ICParameterCVC                  = @"CVC";
NSString * const ICParameterECI                  = @"ECI";
NSString * const ICParameterAVV                  = @"AVV";
NSString * const ICParameterXID                  = @"XID";
NSString * const ICParameterSID                  = @"SID";
NSString * const ICParameterData                 = @"data";
NSString * const ICParameterPrice                = @"Price";
NSString * const ICParameterAmount               = @"Amount";
NSString * const ICParameterSource               = @"source";
NSString * const ICParameterMethod               = @"IPCMethod";
NSString * const ICParameterStatus               = @"Status";
NSString * const ICParameterVersion              = @"version";
NSString * const ICParameterOrderId              = @"OrderID";
NSString * const ICParameterArticle              = @"Article";
NSString * const ICParameterCardType             = @"CardType";
NSString * const ICParameterWalletId             = @"WalletID";
NSString * const ICParameterQuantity             = @"Quantity";
NSString * const ICParameterKeyIndex             = @"KeyIndex";
NSString * const ICParameterCurrency             = @"Currency";
NSString * const ICParameterLanguage             = @"IPCLanguage";
NSString * const ICParameterSignature            = @"Signature";
NSString * const ICParameterCartItems            = @"CartItems";
NSString * const ICParameterCardToken            = @"CardToken";
NSString * const ICParameterIPCVersion           = @"IPCVersion";
NSString * const ICParameterCustomName           = @"CustomName";
NSString * const ICParameterEmbossName           = @"CardholderName";
NSString * const ICParameterExpiryDate           = @"ExpDate";
NSString * const ICParameterIs3DEnabled          = @"Enabled3DS";
NSString * const ICParameter3DSecureBin          = @"3ds_bin";
NSString * const ICParameterWalletNumber         = @"Walletnumber";
NSString * const ICParameterOutputFormat         = @"OutputFormat";
NSString * const ICParameterStatusMessage        = @"StatusMsg";
NSString * const ICParameterTransactionRef       = @"IPC_Trnref";
NSString * const ICParameterTransactionType      = @"TxnType";
NSString * const ICParameterCardVerification     = @"CardVerification";
NSString * const ICParameterBillingDescriptor    = @"BillingDescriptor";
NSString * const ICParameterTransactionStatus    = @"TrnStatus";
NSString * const ICParameterTransactionReference = @"TrnRef";

#pragma mark - 3DS Parameters

NSString * const IC3DSParameterPAN         = @"pan";
NSString * const IC3DSParameterMID         = @"mid";
NSString * const IC3DSParameterBIN         = @"bin";
NSString * const IC3DSParameterAVV         = @"avv";
NSString * const IC3DSParameterECI         = @"eci";
NSString * const IC3DSParameterXID         = @"xid";
NSString * const IC3DSParameterCAVV        = @"cavv";
NSString * const IC3DSParameterAmount      = @"amount";
NSString * const IC3DSParameterStatus      = @"status";
NSString * const IC3DSParameterWalletId    = @"wallet_id";
NSString * const IC3DSParameterCurrency    = @"currency";
NSString * const IC3DSParameterExpiryYear  = @"exp_y";
NSString * const IC3DSParameterExpiryMonth = @"exp_m";
NSString * const IC3DSParameterBillingDesc = @"billing_descriptor";

#pragma mark - Notifications

NSString * const ICNotificationThemeChanged = @"ThemeChanged";

#pragma mark - Controller Identifier

NSString * const ICControllerIdentifierPayment          = @"Payment";
NSString * const ICControllerIdentifierStoreCard        = @"StoreCard";
NSString * const ICControllerIdentifierUpdateStoredCard = @"UpdateStoredCard";

#pragma mark - HTTP Methods

NSString * const ICHTTPMethodGET  = @"GET";
NSString * const ICHTTPMethodPOST = @"POST";

#pragma mark - URLs

NSString * const ICSandboxApiUrl      = @"http://devs.mypos.com/mypos.eu/trunk/public/vmp/checkout-test/";
NSString * const ICSandbox3DSecureUrl = @"https://devs.icards.eu/mypos_tdsgateway/";

NSString * const ICProductionApiUrl      = @"https://www.mypos.eu/vmp/checkout";
NSString * const ICProduction3DSecureUrl = @"https://leupay.eu/tds/";

#pragma mark - Card Types

NSString * const ICCardTypeMastercard   = @"1";
NSString * const ICCardTypeMaestro      = @"2";
NSString * const ICCardTypeVisa         = @"3";
NSString * const ICCardTypeVisaElectron = @"4";
NSString * const ICCardTypeVPay         = @"5";
NSString * const ICCardTypeJCB          = @"6";

@end
