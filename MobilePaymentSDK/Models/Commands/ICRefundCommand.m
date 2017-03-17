//
//  ICRefundCommand.m
//  MobilePaymentSDK
//
//  Created by Valio Cholakov on 1/31/17.
//  Copyright © 2017 Intercard Finance AD. All rights reserved.
//

#import "ICRefundCommand.h"

@implementation ICRefundCommand

#pragma mark - Initialziers

- (instancetype)initWithTransactionRef:(NSString *)transactionRef orderId:(NSString *)orderId amount:(NSString *)amount {
    if (self = [super init]) {
        [_data setObject:amount                                            forKey:ICParameterAmount];
        [_data setObject:orderId                                           forKey:ICParameterOrderId];
        [_data setObject:transactionRef                                    forKey:ICParameterTransactionRef];
        [_data setObject:ICMethodRefund                                    forKey:ICParameterMethod];
        [_data setObject:[[ICMobilePaymentManager sharedManager] currency] forKey:ICParameterCurrency];
    }
    
    return self;
}

#pragma mark - Abstract Methods

- (NSString *)requestInfo {
    NSString *amount         = [_data objectForKey:ICParameterAmount];
    NSString *currency       = [_data objectForKey:ICParameterCurrency];
    NSString *transactionRef = [_data objectForKey:ICParameterTransactionRef];
    
    if (!amount || !currency || !transactionRef) {
        return [super requestInfo];
    }
    
    return [NSString stringWithFormat:@"Refund request for %@ %@ from transaction %@ has been sent",
            amount, currency, transactionRef];
}

- (NSString *)responseInfo {
    NSString *amount         = [_data objectForKey:ICParameterAmount];
    NSString *currency       = [_data objectForKey:ICParameterCurrency];
    NSString *transactionRef = [_data objectForKey:ICParameterTransactionRef];
    
    if (!amount || !currency || !transactionRef) {
        return [super responseInfo];
    }
    
    return [NSString stringWithFormat:@"Refund request for %@ %@ from transaction %@ has been received",
            amount, currency, transactionRef];
}

@end
