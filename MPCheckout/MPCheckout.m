//
//  MPCheckout.m
//  MPCheckout
//
//  Created by Valio Cholakov on 1/31/17.
//  Copyright © 2017 Intercard Finance AD. All rights reserved.
//

#import "MPCheckout.h"

#import "ICUtil.h"
#import "ICLogger.h"
#import "ICHelpers.h"
#import "ICThemeManager.h"
#import "ICMobilePaymentManager.h"
#import "ICCommunicationManager.h"

@implementation MPCheckout

+ (void)initializeInCurrency:(MPCurrency)currency
        withConfigurationKey:(NSString *)configurationKey {
    
    [self initializeInCurrency:currency
          withConfigurationKey:configurationKey
                     isSandbox:NO];
}

+ (void)initializeInCurrency:(MPCurrency)currency
        withConfigurationKey:(NSString *)configurationKey
                   isSandbox:(BOOL)isSandbox {
    
    NSData *decodedData = [[NSData alloc] initWithBase64EncodedString:configurationKey options:0];
    
    if (!decodedData) {
        [ICLogger log:@"Could not parse configuartion key"];
        return;
    }
    
    NSError *error = nil;
    NSDictionary *parameters = [NSJSONSerialization JSONObjectWithData:decodedData options:NSJSONReadingAllowFragments error:&error];
    
    if (error) {
        [ICLogger log:@"Could not parse configuartion key"];
        return;
    }
    
    NSString *storeId       = [parameters objectForKey:@"sid"];
    NSString *accountNumber = [parameters objectForKey:@"cn"];
    NSString *certificate   = [parameters objectForKey:@"pc"];
    NSString *privateKey    = [parameters objectForKey:@"pk"];
    NSString *keyIndex      = [parameters objectForKey:@"idx"];
    
    if (!storeId) {
        [ICLogger log:@"Could not get Store ID from configuartion"];
        return;
    }
    
    if (!accountNumber) {
        [ICLogger log:@"Could not get Client Number from configuartion"];
        return;
    }
    
    if (!certificate) {
        [ICLogger log:@"Could not get Public Certificate from configuartion"];
        return;
    }
    
    if (!privateKey) {
        [ICLogger log:@"Could not get Priavte Key from configuartion"];
        return;
    }
    
    if (!keyIndex) {
        [ICLogger log:@"Could not get Key Index from configuartion"];
        return;
    }
    
    [self initializeWithAccountNumber:accountNumber
                              storeId:storeId
                             currency:currency
                          certificate:certificate
                           privateKey:privateKey
                               bundle:nil
                             keyIndex:[keyIndex integerValue]
                            isSandbox:isSandbox
                 usesConfigurationKey:YES];
}

+ (void)initializeWithAccountNumber:(NSString *)accountNumber
                            storeId:(NSString *)storeId
                           currency:(MPCurrency)currency
                        certificate:(NSString *)certificate
                         privateKey:(NSString *)privateKey
                             bundle:(NSBundle *)bundle
                           keyIndex:(NSInteger)keyIndex {
    
    [self initializeWithAccountNumber:accountNumber
                              storeId:storeId
                             currency:currency
                          certificate:certificate
                           privateKey:privateKey
                               bundle:bundle
                             keyIndex:keyIndex
                            isSandbox:NO];
}

+ (void)initializeWithAccountNumber:(NSString *)accountNumber
                            storeId:(NSString *)storeId
                           currency:(MPCurrency)currency
                        certificate:(NSString *)certificate
                         privateKey:(NSString *)privateKey
                             bundle:(NSBundle *)bundle
                           keyIndex:(NSInteger)keyIndex
                          isSandbox:(BOOL)isSandbox {
    
    [self initializeWithAccountNumber:accountNumber
                              storeId:storeId
                             currency:currency
                          certificate:certificate
                           privateKey:privateKey
                               bundle:bundle
                             keyIndex:keyIndex
                            isSandbox:NO
                 usesConfigurationKey:NO];
}

+ (void)initializeWithAccountNumber:(NSString *)accountNumber
                            storeId:(NSString *)storeId
                           currency:(MPCurrency)currency
                        certificate:(NSString *)certificate
                         privateKey:(NSString *)privateKey
                             bundle:(NSBundle *)bundle
                           keyIndex:(NSInteger)keyIndex
                          isSandbox:(BOOL)isSandbox
               usesConfigurationKey:(BOOL)usesConfigurationKey {
    
    [ICLogger log:@"Initializing..."];
    [[ICMobilePaymentManager sharedManager] setWalletNumber:accountNumber
                                                    storeId:storeId
                                                   currency:currency
                                                  publicKey:certificate
                                                 privateKey:privateKey
                                                     bundle:bundle ? : [NSBundle mainBundle]
                                                   language:@"en"
                                                   keyIndex:keyIndex > 0 ? keyIndex : 1
                                                  inSandbox:isSandbox
                                       usesConfigurationKey:usesConfigurationKey];
    [ICLogger log:[[ICMobilePaymentManager sharedManager] isInitialized] ? @"Initialized" : @"Initialization failed"];
}

+ (void)applyTheme:(MPCheckoutTheme *)theme {
    [[ICThemeManager sharedTheme] setTheme:theme];
}

+ (void)getOrderStatus:(NSString *)orderId
       transactionType:(MPTransactionType)transactionType
            completion:(void (^)(NSInteger status, NSString *transactionRef))completion
               failure:(void (^)(MPCheckoutError *error))failure {
    
    if (![[ICMobilePaymentManager sharedManager] isInitialized]) {
        failure([MPCheckoutError notInitializedError]);
        return;
    }
    
    [[ICCommunicationManager sharedManager] getTransactionStatusForOrder:orderId
                                                         transactionType:transactionType
                                                              completion:completion
                                                                 failure:failure];
}

+ (void)refundTransaction:(NSString *)transactionRef
                fromOrder:(NSString *)orderId
                   amount:(CGFloat)amount
               completion:(void (^)(NSString *transactionRef))completion
                  failure:(void (^)(MPCheckoutError *error))failure {
    
    if (amount <= 0.00 || amount > 999999.00) {
        failure([MPCheckoutError errorWithStatus:MPCheckoutInvalidInputParametersError]);
        return;
    }
    
    if (![[ICMobilePaymentManager sharedManager] isInitialized]) {
        failure([MPCheckoutError notInitializedError]);
        return;
    }
    
    [[ICCommunicationManager sharedManager] makeRefundFor:ICFormatterAmount(amount)
                                           transactionRef:transactionRef
                                                  orderId:orderId
                                               completion:completion
                                                  failure:failure];
}

+ (void)reverseTransaction:(NSString *)transactionRef
                completion:(void (^)(NSString *transactionRef))completion
                   failure:(void (^)(MPCheckoutError *error))failure {
    
    if (![[ICMobilePaymentManager sharedManager] isInitialized]) {
        failure([MPCheckoutError notInitializedError]);
        return;
    }
    
    [[ICCommunicationManager sharedManager] makeReversalForTransaction:transactionRef
                                                            completion:completion
                                                               failure:failure];
}

+ (void)completePreAuthorization:(NSString *)orderId
                       forAmount:(CGFloat)amount
                      inCurrency:(MPCurrency)currency
                      completion:(void (^)(NSString * orderId))completion
                         failure:(void (^)(MPCheckoutError * error))failure {
    
    if (![[ICMobilePaymentManager sharedManager] isInitialized]) {
        failure([MPCheckoutError notInitializedError]);
        return;
    }
    
    [[ICCommunicationManager sharedManager] completePreAuthorization:orderId
                                                           forAmount:amount
                                                          inCurrency:currency
                                                          completion:completion
                                                             failure:failure];
}

+ (void)cancelPreAuthorization:(NSString *)orderId
                    completion:(void (^)(void))completion
                       failure:(void (^)(MPCheckoutError * error))failure {
    
    if (![[ICMobilePaymentManager sharedManager] isInitialized]) {
        failure([MPCheckoutError notInitializedError]);
        return;
    }
    
    [[ICCommunicationManager sharedManager] cancelPreAuthorization:orderId
                                                        completion:completion
                                                           failure:failure];
}

+ (void)getPreAuthorizationStatus:(NSString *)orderId
                       completion:(void (^)(MPPreAuthorizationStatus status, NSString *expiryDate))completion
                          failure:(void (^)(MPCheckoutError *error))failure {
    
    if (![[ICMobilePaymentManager sharedManager] isInitialized]) {
        failure([MPCheckoutError notInitializedError]);
        return;
    }
    
    [[ICCommunicationManager sharedManager] getPreAuthorizationStatus:orderId
                                                           completion:completion
                                                              failure:failure];
}

+ (void)makeAuthorizationForItem:(NSString *)itemName
                      withAmount:(CGFloat)amount
                         orderId:(NSString *)orderId
                       cardToken:(NSString *)cardToken
               completion:(void (^)(NSString *transactionReference))completion
                  failure:(void (^)(MPCheckoutError *error))failure {
    
    if (![[ICMobilePaymentManager sharedManager] isInitialized]) {
        failure([MPCheckoutError notInitializedError]);
        return;
    }
    
    [[ICCommunicationManager sharedManager] makeAuthorizationFor:amount
                                                        itemName:itemName
                                                         orderId:orderId
                                                       cardToken:cardToken
                                                      completion:completion
                                                         failure:failure];
}

+ (void)captureAuthorization:(NSString *)orderId
                   forAmount:(CGFloat)amount
                  completion:(void (^)(NSString *transactionReference))completion
                     failure:(void (^)(MPCheckoutError *error))failure {
    
    if (![[ICMobilePaymentManager sharedManager] isInitialized]) {
        failure([MPCheckoutError notInitializedError]);
        return;
    }
    
    [[ICCommunicationManager sharedManager] captureAuthorizationAmounr:amount
                                                             fromOrder:orderId
                                                            completion:completion
                                                               failure:failure];
}

+ (void)cancelAuthorization:(NSString *)orderId
                 completion:(void (^)(NSString *transactionReference))completion
                    failure:(void (^)(MPCheckoutError *error))failure {
    
    if (![[ICMobilePaymentManager sharedManager] isInitialized]) {
        failure([MPCheckoutError notInitializedError]);
        return;
    }
    
    [[ICCommunicationManager sharedManager] cancelAuthorization:orderId
                                                     completion:completion
                                                        failure:failure];
}

+ (void)listAuthorizationsWithCompletion:(void (^)(NSArray<MPAuthorization *> * authorizations))completion
                                 failure:(void (^)(MPCheckoutError * error))failure {
    
    if (![[ICMobilePaymentManager sharedManager] isInitialized]) {
        failure([MPCheckoutError notInitializedError]);
        return;
    }
    
    [[ICCommunicationManager sharedManager] listAuthorizationsWithCompletion:completion failure:failure];
}

@end
