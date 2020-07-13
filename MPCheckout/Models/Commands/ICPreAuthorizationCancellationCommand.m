//
//  ICPreAuthorizationCancellationCommand.m
//  MPCheckout
//
//  Created by Valio Cholakov on 9.07.20.
//  Copyright © 2020 Intercard Finance AD. All rights reserved.
//

#import "ICPreAuthorizationCancellationCommand.h"

@implementation ICPreAuthorizationCancellationCommand

#pragma mark - Initializers

- (instancetype)initWithOrderId:(NSString *)orderId {
    if (self = [super init]) {
        [_data setObject:ICMethodPreAuthorizationCancellation              forKey:ICParameterMethod];
        [_data setObject:orderId                                           forKey:ICParameterOrderId];
        [_data setObject:[[ICMobilePaymentManager sharedManager] currency] forKey:ICParameterCurrency];
    }
    
    return self;
}

#pragma mark - Abstract Methods

- (NSString *)requestInfo {
    NSString *orderId  = [_data objectForKey:ICParameterOrderId];
    
    if (!orderId) {
        return [super requestInfo];
    }
    
    return [NSString stringWithFormat:@"Order %@ pre authorization cancellation request been sent", orderId];
}

- (NSString *)responseInfo {
    return @"Response for order pre authorization cancellation request has been received";
}

@end
