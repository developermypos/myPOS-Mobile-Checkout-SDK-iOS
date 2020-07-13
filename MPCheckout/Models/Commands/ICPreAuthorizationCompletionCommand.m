//
//  ICPreAuthorizationCompletionCommand.m
//  MPCheckout
//
//  Created by Valio Cholakov on 9.07.20.
//  Copyright © 2020 Intercard Finance AD. All rights reserved.
//

#import "ICPreAuthorizationCompletionCommand.h"

@implementation ICPreAuthorizationCompletionCommand

#pragma mark - Initializers

- (instancetype)initWithOrderId:(NSString *)orderId amount:(NSString *)amount {
    if (self = [super init]) {
        [_data setObject:ICMethodPreAuthorizationCompletion                forKey:ICParameterMethod];
        [_data setObject:amount                                            forKey:ICParameterAmount];
        [_data setObject:orderId                                           forKey:ICParameterOrderId];
        [_data setObject:[[ICMobilePaymentManager sharedManager] currency] forKey:ICParameterCurrency];
    }
    
    return self;
}

#pragma mark - Abstract Methods

- (NSString *)requestInfo {
    NSString *amount   = [_data objectForKey:ICParameterAmount];
    NSString *orderId  = [_data objectForKey:ICParameterOrderId];
    NSString *currency = [_data objectForKey:ICParameterCurrency];
    
    if (!amount || !orderId || !currency) {
        return [super requestInfo];
    }
    
    return [NSString stringWithFormat:@"Order %@ pre authorization completion request for %@ %@ has been sent",
            orderId, amount, currency];
}

- (NSString *)responseInfo {
    NSString *orderId = [_data objectForKey:ICParameterOrderId];
    
    if (!orderId) {
        return [super responseInfo];
    }
    
    return [NSString stringWithFormat:@"Response for order %@ pre authorization completion request has been received", orderId];
}

@end
