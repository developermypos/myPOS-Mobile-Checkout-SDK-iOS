//
//  ICGetPreAuthorizationStatusCommand.m
//  MPCheckout
//
//  Created by Valio Cholakov on 9.07.20.
//  Copyright © 2020 Intercard Finance AD. All rights reserved.
//

#import "ICGetPreAuthorizationStatusCommand.h"

@implementation ICGetPreAuthorizationStatusCommand

#pragma mark - Initializers

- (instancetype)initWithOrderId:(NSString *)orderId {
    if (self = [super init]) {
        [_data setObject:ICMethodGetPreAuthorizationStatus forKey:ICParameterMethod];
        [_data setObject:orderId                           forKey:ICParameterOrderId];
    }
    
    return self;
}

#pragma mark - Abstract Methods

- (NSString *)requestInfo {
    NSString *orderId  = [_data objectForKey:ICParameterOrderId];
    
    if (!orderId) {
        return [super requestInfo];
    }
    
    return [NSString stringWithFormat:@"Order %@ pre authorization status request has been sent",
            orderId];
}

- (NSString *)responseInfo {
    NSString *orderId                = [_data objectForKey:ICParameterOrderId];
    NSString *expiryDate             = [_data objectForKey:ICParameterPreAuthExpDate];
    MPPreAuthorizationStatus status  = (MPPreAuthorizationStatus)[[_data objectForKey:ICParameterPreAuthorizationStatus] integerValue];
    
    if (!orderId || !expiryDate) {
        return [super responseInfo];
    }
    
    return [NSString stringWithFormat:@"Response for order %@ pre authorization status request has been received. Status: %lu | Expiry date: %@",
            orderId, (unsigned long)status, expiryDate];
}

@end
