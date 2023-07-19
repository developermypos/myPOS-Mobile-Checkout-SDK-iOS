//
//  ICPreAuthorizationCommand.m
//  MPCheckout
//
//  Created by Valio Cholakov on 8.07.20.
//  Copyright © 2020 Intercard Finance AD. All rights reserved.
//

#import "ICPreAuthorizationCommand.h"

@implementation ICPreAuthorizationCommand

#pragma mark - Initialziers

- (instancetype)initWithAmount:(NSString *)amount extraData:(NSDictionary *)extraData dsTransactionId:(NSString *)dsTransactionId programProtocol:(NSString *)programProtocol {
    if (self = [super init]) {
        [_data setObject:ICMethodPreAuthorization                          forKey:ICParameterMethod];
        [_data setObject:amount                                            forKey:ICParameterAmount];
        [_data setObject:[[ICMobilePaymentManager sharedManager] currency] forKey:ICParameterCurrency];
        
        [_data addEntriesFromDictionary:extraData];
        
        if (dsTransactionId) {
            [_data setObject:dsTransactionId                                  forKey:ICParameterDsTransactionId];
        }
        
        if (programProtocol) {
            [_data setObject:programProtocol                                  forKey:ICParameterProgramProtocol];
        }
    }
    
    return self;
}

#pragma mark - Abstract Methods

- (NSString *)requestInfo {
    NSString *amount   = [_data objectForKey:ICParameterAmount];
    NSString *orderId  = [_data objectForKey:ICParameterOrderId];
    NSString *currency = [_data objectForKey:ICParameterCurrency];
    NSString *itemName = [_data objectForKey:ICParameterItemName];
    
    if (!amount || !orderId || !currency || !itemName) {
        return [super requestInfo];
    }
    
    return [NSString stringWithFormat:@"Order %@ pre authorization request for %@ for a %@ %@ has been sent",
            orderId, itemName, amount, currency];
}

- (NSString *)responseInfo {
    NSString *orderId = [_data objectForKey:ICParameterOrderId];
    
    if (!orderId) {
        return [super responseInfo];
    }
    
    return [NSString stringWithFormat:@"Response for order %@ pre authorization request has been received", orderId];
}

@end
