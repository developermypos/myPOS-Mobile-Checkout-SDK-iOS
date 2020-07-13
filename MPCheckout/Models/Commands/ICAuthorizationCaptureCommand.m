//
//  ICAuthorizationCaptureCommand.m
//  MPCheckout
//
//  Created by Valio Cholakov on 10.07.20.
//  Copyright © 2020 Intercard Finance AD. All rights reserved.
//

#import "ICAuthorizationCaptureCommand.h"

@implementation ICAuthorizationCaptureCommand

#pragma mark - Initialziers

- (instancetype)initWithAmount:(NSString *)amount orderId:(NSString *)orderId {
    
    if (self = [super init]) {
        [_data setObject:ICMethodCaptureAuthorization                      forKey:ICParameterMethod];
        [_data setObject:amount                                            forKey:ICParameterAmount];
        [_data setObject:orderId                                           forKey:ICParameterOrderId];
        [_data setObject:[[ICMobilePaymentManager sharedManager] currency] forKey:ICParameterCurrency];
    }
    
    return self;
}

#pragma mark - Abstract Methods

- (NSString *)requestInfo {
    NSString *amount    = [_data objectForKey:ICParameterAmount];
    NSString *orderId   = [_data objectForKey:ICParameterOrderId];
    NSString *currency  = [_data objectForKey:ICParameterCurrency];
    
    if (!amount || !orderId || !currency) {
        return [super requestInfo];
    }
    
    return [NSString stringWithFormat:@"Order %@ capture authorization request for %@ %@ has been sent",
            orderId, amount, currency];
}

- (NSString *)responseInfo {
    NSString *orderId    = [_data objectForKey:ICParameterOrderId];
    NSString *trnRef     = [_data objectForKey:ICParameterAuthorizationTrnRef];
    
    if (!orderId || !trnRef) {
        return [super responseInfo];
    }
    
    return [NSString stringWithFormat:@"Response for order %@ capture authorization request has been received. Reference: %@",
            orderId, trnRef];
}

@end
