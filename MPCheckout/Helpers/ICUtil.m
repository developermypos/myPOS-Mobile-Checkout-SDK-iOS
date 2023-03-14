//
//  ICUtil.m
//  MPCheckout
//
//  Created by Valio Cholakov on 1/31/17.
//  Copyright © 2017 Intercard Finance AD. All rights reserved.
//

#import "MPCard.h"
#import "ICUtil.h"
#import "MPCartItem.h"
#import "ICHelpers.h"
#import "ICConstants.h"
#import "ICLogger.h"
#import "ICRSAManager.h"
#import "ICMobilePaymentManager.h"

#import "ICPaymentViewController.h"
#import "ICStoreCardViewController.h"
#import "ICUpdateStoredCardViewController.h"
#import "ICPreAuthorizationViewController.h"

#import "Base64.h"
#import "NSString+Helpers.h"
#import "NSDictionary+Helpers.h"

@implementation ICUtil

#pragma mark - Public Methods

+ (ICPaymentViewController *)paymentController {
    return (ICPaymentViewController *)[self controllerWithIdentifier:ICControllerIdentifierPayment];
}

+ (ICStoreCardViewController *)storeCardController {
    return (ICStoreCardViewController *)[self controllerWithIdentifier:ICControllerIdentifierStoreCard];
}

+ (ICUpdateStoredCardViewController *)updateCardController {
    return (ICUpdateStoredCardViewController *)[self controllerWithIdentifier:ICControllerIdentifierUpdateStoredCard];
}

+ (ICPreAuthorizationViewController *)preAuthorizationController {
    return (ICPreAuthorizationViewController *)[self controllerWithIdentifier:ICControllerIdentifierPreAuthorization];
}

+ (NSString *)signedData:(NSDictionary<NSString *, NSString *> *)data {
    __block NSString *dataToSign = @"";
    
    [[data allValues] enumerateObjectsUsingBlock:^(NSString * _Nonnull value, NSUInteger idx, BOOL * _Nonnull stop) {
        dataToSign = [NSString stringWithFormat:@"%@-%@", dataToSign, value];
    }];
    
    dataToSign = [dataToSign substringFromIndex:1];
    
    [ICLogger logDebug:[NSString stringWithFormat:@"Data to sign: %@", dataToSign]];
    return [[ICRSAManager sharedManager] signString:[dataToSign base64EncodedString]];
}

+ (NSURLRequest *)cardValidationURLRequest:(MPCard *)card
                                  cardData:(NSDictionary *)cardData
                                    amount:(NSString *)amount
                                     email:(NSString *)email {
    NSString *mid         = [cardData objectForKey:ICParameterMID];
    NSString *bin         = [cardData objectForKey:ICParameterBIN];
    NSString *billingDesc = [cardData objectForKey:ICParameterBillingDescriptor];
    
    if (!mid || !bin || !billingDesc) {
        [ICLogger log:@"Verification failed - Missing card data"];
        return nil;
    }
    
    NSDictionary<NSString *, NSString *> *json = @{
                                                   IC3DSParameterPAN         : card.pan,
                                                   IC3DSParameterExpiryYear  : card.expiryYear,
                                                   IC3DSParameterExpiryMonth : card.expiryMonth,
                                                   };
    
//    [ICLogger logDebug:[NSString stringWithFormat:@"3DS - JSON: %@", json]];
    
    NSError *error    = nil;
    NSData  *jsonData = [NSJSONSerialization dataWithJSONObject:json options:NSJSONWritingPrettyPrinted error:&error];
    
    if (error || !jsonData) {
        [ICLogger logDebug:@"Error while parsing json"];
        return nil;
    }
    
    NSString *jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    
    if (!jsonString) {
        [ICLogger logDebug:@"Error while parsing bytes to string"];
        return nil;
    }
    
    NSString *encryptedData = [jsonString encrypted];
    
    if (!encryptedData) {
        [ICLogger logDebug:@"Internal error during encryption"];
        return nil;
    }
    
    NSString *walletId = [cardData objectForKey:ICParameterWalletId];
    
    if (!walletId) {
        [ICLogger logDebug:@"3DS - Wallet id not found"];
        return nil;
    }
    
    NSString *tz = [NSString stringWithFormat: @"%@", [[NSNumber numberWithFloat: [[NSTimeZone localTimeZone] secondsFromGMT] / 60] stringValue]];
    NSString *height = [[NSNumber numberWithFloat:[[UIScreen mainScreen] bounds].size.height] stringValue];
    NSString *width = [[NSNumber numberWithFloat:[[UIScreen mainScreen] bounds].size.width] stringValue];
    NSString *resolution =[NSString stringWithFormat:@"%@x%@", height, width];
    
    NSString *body = [NSString stringWithFormat:@"%@=%@&%@=%@&%@=%@&%@=%@&%@=%@&%@=%@&%@=%@&%@=%@&%@=%@&%@=%@&%@=%@&%@=%@&%@=%@&%@=%@&%@=%@&%@=%@&%@=%@",
                      ICParameterData, [encryptedData urlEncoded],
                      IC3DSParameterWalletId, [walletId urlEncoded],
                      ICParameterSource, [kSource urlEncoded],
                      IC3DSParameterMID, [mid urlEncoded],
                      IC3DSParameterBIN, [bin urlEncoded],
                      IC3DSParameterBillingDesc, [billingDesc urlEncoded],
                      IC3DSParameterAmount, [amount urlEncoded],
                      ICParameterVersion, [kIPCVersion urlEncoded],
                      ICParameterSID.lowercaseString, [[[ICMobilePaymentManager sharedManager] storeId] urlEncoded],
                      IC3DSParameterCurrency, [[[ICMobilePaymentManager sharedManager] currency] urlEncoded],
                      IC3DSParameterVersions, [@"1" urlEncoded],
                      IC3DSParameterEmail, [email urlEncoded],
                      IC3DSParameterLanguage, [[[ICMobilePaymentManager sharedManager] language] urlEncoded],
                      IC3DSParameterResolution, [resolution urlEncoded],
                      IC3DSParameterTimezone, [tz urlEncoded],
                      IC3DSParameterBrLanguage, [[[ICMobilePaymentManager sharedManager] language] urlEncoded],
                      IC3DSParameterLibVersion, [kSDKVersion urlEncoded]];
    
    [ICLogger logDebug:[NSString stringWithFormat:@"3DS - body: %@", body]];
    
    NSURL *url = [NSURL URLWithString:[ICMobilePaymentManager secureUrl]];
    
    if (!url) {
        [ICLogger logDebug:@"Invalid communication URL"];
        return nil;
    }
    
    NSData *httpBody = [body dataUsingEncoding:NSUTF8StringEncoding];
    
    if (!httpBody) {
        [ICLogger logDebug:@"Could not get bytes of body"];
        return nil;
    }
    
//    [ICLogger logDebug:[NSString stringWithFormat:@"Starting 3DSecure request to URL '%@' with body '%@", url, body]];
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    
    [request setHTTPBody:httpBody];
    [request setHTTPMethod:ICHTTPMethodPOST];
    
    [request setValue:kURLEncoded                        forHTTPHeaderField:kContentType];
    [request setValue:ICIntegerToString(httpBody.length) forHTTPHeaderField:kContentLength];
    
    return (NSURLRequest *)request;
}

+ (NSURLRequest *)tdsProcessURLRequest:(NSDictionary *)cardData
                                amount:(NSString *)amount
                                 email:(NSString *)email {
    
    NSString *cardToken = [cardData objectForKey:ICParameterCardToken];
    
    if (!cardToken) {
        [ICLogger logDebug:@"3DS - Card token not found"];
        return nil;
    }
    
    NSString *tz = [NSString stringWithFormat: @"%@", [[NSNumber numberWithFloat: [[NSTimeZone localTimeZone] secondsFromGMT] / 60] stringValue]];
    NSString *height = [[NSNumber numberWithFloat:[[UIScreen mainScreen] bounds].size.height] stringValue];
    NSString *width = [[NSNumber numberWithFloat:[[UIScreen mainScreen] bounds].size.width] stringValue];
    NSString *resolution =[NSString stringWithFormat:@"%@x%@", height, width];
    
    NSDictionary *data = [@{
        ICParameterMethod: [ICMethodTDSProcess urlEncoded],
        ICParameterIPCVersion: [kIPCVersion urlEncoded],
        ICParameterLanguage: [[[ICMobilePaymentManager sharedManager] language] urlEncoded],
        ICParameterSID: [[[ICMobilePaymentManager sharedManager] storeId] urlEncoded],
        @"WalletNumber": [[[ICMobilePaymentManager sharedManager] walletNumber] urlEncoded],
        ICParameterKeyIndex: [ICIntegerToString([[ICMobilePaymentManager sharedManager] keyIndex]) urlEncoded],
        ICParameterOutputFormat: [kOutputFormat urlEncoded],
        ICParameterAmount: [amount urlEncoded],
        ICParameterCurrency: [[[ICMobilePaymentManager sharedManager] currency] urlEncoded],
        @"UseRedirect": [@"1" urlEncoded],
        ICParameterCardToken: [cardToken urlEncoded],
        ICParameterEmail: [email urlEncoded],
        @"BrowserTimezone": [tz urlEncoded],
        @"BrowserLanguage": [[[ICMobilePaymentManager sharedManager] language] urlEncoded],
        ICParameterBaseSource: [@"iOS SDK" urlEncoded],
        @"BrowserScreenResolution": [resolution urlEncoded],
        @"LibVersion": [kSDKVersion urlEncoded]
        }
      mutableCopy];
    
    NSString *signature = [ICUtil signedData:data];
    
    
    if (!signature) {
        [ICLogger logDebug:@"Could not sign data"];
        return nil;
    }
    
    signature = [[signature componentsSeparatedByCharactersInSet:[NSCharacterSet newlineCharacterSet]] componentsJoinedByString:@""];
    
    NSString *body = [NSString stringWithFormat:@"%@&%@=%@",
                             [data formData], ICParameterSignature, [signature urlEncoded]];
    
    [ICLogger logDebug:[NSString stringWithFormat:@"3DS - body: %@", body]];
    
    NSURL *url = [NSURL URLWithString:[ICMobilePaymentManager apiUrl]];
    
    if (!url) {
        [ICLogger logDebug:@"Invalid communication URL"];
        return nil;
    }
    
    NSData *httpBody = [body dataUsingEncoding:NSUTF8StringEncoding];
    
    if (!httpBody) {
        [ICLogger logDebug:@"Could not get bytes of body"];
        return nil;
    }
    
//    [ICLogger logDebug:[NSString stringWithFormat:@"Starting 3DSecure request to URL '%@' with body '%@", url, body]];
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    
    [request setHTTPBody:httpBody];
    [request setHTTPMethod:ICHTTPMethodPOST];
    
    [request setValue:kURLEncoded                        forHTTPHeaderField:kContentType];
    [request setValue:ICIntegerToString(httpBody.length) forHTTPHeaderField:kContentLength];
    
    return (NSURLRequest *)request;
}

+ (NSString *)itemsTotalAmount:(NSArray<MPCartItem *> *)cartItems {
    CGFloat amount = 0.0f;
    
    for (MPCartItem *item in cartItems) {
        @autoreleasepool {
            amount += item.price * item.quantity;
        }
    }
    
    return ICFormatterAmount(amount);
}

#pragma mark - Private Methods

+ (UIViewController *)controllerWithIdentifier:(NSString *)identifier {
    NSBundle         *bundle     = [NSBundle bundleForClass:[ICMobilePaymentManager class]];
    UIStoryboard     *storyboard = [UIStoryboard storyboardWithName:kStoryboardName bundle:bundle];
    UIViewController *controller = [storyboard instantiateViewControllerWithIdentifier:identifier];
    
    return controller;
}

@end
