//
//  ICAuthorizationReverseCommand.m
//  MPCheckout
//
//  Created by Valio Cholakov on 10.07.20.
//  Copyright © 2020 Intercard Finance AD. All rights reserved.
//

#import "ICAuthorizationReverseCommand.h"

@implementation ICAuthorizationReverseCommand

#pragma mark - Initialziers

- (instancetype)initWithOrderId:(NSString *)orderId {
    
    if (self = [super init]) {
        [_data setObject:ICMethodReverseAuthorization forKey:ICParameterMethod];
        [_data setObject:orderId                      forKey:ICParameterOrderId];
    }
    
    return self;
}

#pragma mark - Abstract Methods

- (NSString *)requestInfo {
    NSString *orderId   = [_data objectForKey:ICParameterOrderId];
    
    if (!orderId) {
        return [super requestInfo];
    }
    
    return [NSString stringWithFormat:@"Order %@ cancel authorization request has been sent", orderId];
}

- (NSString *)responseInfo {
    NSString *orderId = [_data objectForKey:ICParameterOrderId];
    
    if (!orderId) {
        return [super responseInfo];
    }
    
    return [NSString stringWithFormat:@"Response for order %@ cancel authorization request has been received", orderId];
}

@end
