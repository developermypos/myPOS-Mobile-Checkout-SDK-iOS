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

+ (void)initializeWithAccountNumber:(NSString *)accountNumber
                            storeId:(NSString *)storeId
                           currency:(Currency)currency
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
                           currency:(Currency)currency
                        certificate:(NSString *)certificate
                         privateKey:(NSString *)privateKey
                             bundle:(NSBundle *)bundle
                           keyIndex:(NSInteger)keyIndex
                          isSandbox:(BOOL)isSandbox {
    
    [ICLogger log:@"Initializing..."];
    [[ICMobilePaymentManager sharedManager] setWalletNumber:accountNumber
                                                    storeId:storeId
                                                   currency:currency
                                                  publicKey:certificate
                                                 privateKey:privateKey
                                                     bundle:bundle ? : [NSBundle mainBundle]
                                                   language:@"en"
                                                   keyIndex:keyIndex > 0 ? keyIndex : 1
                                                  inSandbox:isSandbox];
    [ICLogger log:[[ICMobilePaymentManager sharedManager] isInitialized] ? @"Initialized" : @"Initialization failed"];
}

+ (void)applyTheme:(MPCheckoutTheme *)theme {
    [[ICThemeManager sharedTheme] setTheme:theme];
}

+ (void)getOrderStatus:(NSString *)orderId
       transactionType:(TransactionType)transactionType
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
    
    [[ICCommunicationManager sharedManager] makeRefundFor:ICFormatterAmount(amount) transactionRef:transactionRef orderId:orderId completion:completion failure:failure];
}

@end
