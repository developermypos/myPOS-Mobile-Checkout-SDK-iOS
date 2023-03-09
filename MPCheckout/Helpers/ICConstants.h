//
//  ICConstants.h
//  MPCheckout
//
//  Created by Valio Cholakov on 1/30/17.
//  Copyright © 2017 Intercard Finance AD. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface ICConstants : NSObject

extern SecPadding const kSignaturePadding;

extern NSTimeInterval const kCommunicationTimeout;

extern CGFloat const kSeparatorHeight;
extern CGFloat const kNavigationBarHeight;

extern NSString * const kPrivateKeyTag;
extern NSString * const kCertificateTag;

extern NSInteger const ICResponseStatusOK;
extern NSInteger const ICSecureResponseStatusOK;
extern NSInteger const ICSecureResponseStatusParamError;
extern NSInteger const ICSecureResponseStatusOtherParamError;

extern NSString * const kIPCVersion;
extern NSString * const kOutputFormat;
extern NSString * const kSource;
extern NSString * const kCardVerification;
extern NSString * const kErrorDomain;
extern NSString * const kStoryboardName;
extern NSString * const kLocalizationsTable;
extern NSString * const kContentType;
extern NSString * const kContentLength;
extern NSString * const kURLEncoded;

extern NSString * const ICColorEnabled;
extern NSString * const ICColorDisabled;
extern NSString * const ICColorSeparator;
extern NSString * const ICColorBackgroundGray;

extern NSString * const ICMethodRefund;
extern NSString * const ICMethodPurchase;
extern NSString * const ICMethodReversal;
extern NSString * const ICMethodStoreCard;
extern NSString * const ICMethodGetCardData;
extern NSString * const ICMethodUpdateStoredCard;
extern NSString * const ICMethodGetTransactionStatus;
extern NSString * const ICMethodPreAuthorization;
extern NSString * const ICMethodPreAuthorizationCompletion;
extern NSString * const ICMethodPreAuthorizationCancellation;
extern NSString * const ICMethodGetPreAuthorizationStatus;
extern NSString * const ICMethodAuthorization;
extern NSString * const ICMethodCaptureAuthorization;
extern NSString * const ICMethodReverseAuthorization;
extern NSString * const ICMethodListAuthorizations;

extern NSString * const ICParameterMID;
extern NSString * const ICParameterBIN;
extern NSString * const ICParameterPAN;
extern NSString * const ICParameterCVC;
extern NSString * const ICParameterECI;
extern NSString * const ICParameterAVV;
extern NSString * const ICParameterXID;
extern NSString * const ICParameterSID;
extern NSString * const ICParameterData;
extern NSString * const ICParameterDate;
extern NSString * const ICParameterPrice;
extern NSString * const ICParameterAmount;
extern NSString * const ICParameterSource;
extern NSString * const ICParameterMethod;
extern NSString * const ICParameterStatus;
extern NSString * const ICParameterVersion;
extern NSString * const ICParameterOrderId;
extern NSString * const ICParameterArticle;
extern NSString * const ICParameterItemName;
extern NSString * const ICParameterCardType;
extern NSString * const ICParameterWalletId;
extern NSString * const ICParameterQuantity;
extern NSString * const ICParameterKeyIndex;
extern NSString * const ICParameterCurrency;
extern NSString * const ICParameterLanguage;
extern NSString * const ICParameterSignature;
extern NSString * const ICParameterCartItems;
extern NSString * const ICParameterCardToken;
extern NSString * const ICParameterIPCVersion;
extern NSString * const ICParameterCustomName;
extern NSString * const ICParameterEmbossName;
extern NSString * const ICParameterExpiryDate;
extern NSString * const ICParameterIs3DEnabled;
extern NSString * const ICParameter3DSecureBin;
extern NSString * const ICParameterWalletNumber;
extern NSString * const ICParameterOutputFormat;
extern NSString * const ICParameterStatusMessage;
extern NSString * const ICParameterAuthorization;
extern NSString * const ICParameterTransactionRef;
extern NSString * const IPCParameterPreAuthStatus;
extern NSString * const ICParameterPreAuthExpDate;
extern NSString * const ICParameterTransactionType;
extern NSString * const ICParameterCardVerification;
extern NSString * const ICParameterBillingDescriptor;
extern NSString * const ICParameterTransactionStatus;
extern NSString * const ICParameterAuthorizationTrnRef;
extern NSString * const ICParameterTransactionReference;
extern NSString * const ICParameterPreAuthorizationStatus;
extern NSString * const ICParameterAutoReverse;
extern NSString * const ICParameterRequestToken;

extern NSString * const IC3DSParameterPAN;
extern NSString * const IC3DSParameterMID;
extern NSString * const IC3DSParameterBIN;
extern NSString * const IC3DSParameterAVV;
extern NSString * const IC3DSParameterECI;
extern NSString * const IC3DSParameterXID;
extern NSString * const IC3DSParameterCAVV;
extern NSString * const IC3DSParameterAmount;
extern NSString * const IC3DSParameterStatus;
extern NSString * const IC3DSParameterWalletId;
extern NSString * const IC3DSParameterCurrency;
extern NSString * const IC3DSParameterExpiryYear;
extern NSString * const IC3DSParameterExpiryMonth;
extern NSString * const IC3DSParameterBillingDesc;
extern NSString * const IC3DSParameterVersions;
extern NSString * const IC3DSParameterEmail;
extern NSString * const IC3DSParameterLanguage;
extern NSString * const IC3DSParameterResolution;
extern NSString * const IC3DSParameterTimezone;
extern NSString * const IC3DSParameterBrLanguage;
extern NSString * const IC3DSParameterLibVersion;
extern NSString * const IC3DSParameterProgramProtocol;
extern NSString * const IC3DSParameterDsTransactionId;

extern NSString * const ICNotificationThemeChanged;

extern NSString * const ICControllerIdentifierPayment;
extern NSString * const ICControllerIdentifierStoreCard;
extern NSString * const ICControllerIdentifierUpdateStoredCard;
extern NSString * const ICControllerIdentifierPreAuthorization;

extern NSString * const ICHTTPMethodGET;
extern NSString * const ICHTTPMethodPOST;

extern NSString * const ICSandboxApiUrl;
extern NSString * const ICSandbox3DSecureUrl;

extern NSString * const ICProductionApiUrl;
extern NSString * const ICProduction3DSecureUrl;

extern NSString * const ICCardTypeMastercard;
extern NSString * const ICCardTypeMaestro;
extern NSString * const ICCardTypeVisa;
extern NSString * const ICCardTypeVisaElectron;
extern NSString * const ICCardTypeVPay;
extern NSString * const ICCardTypeJCB;

@end
