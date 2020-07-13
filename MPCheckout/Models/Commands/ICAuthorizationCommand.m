//
//  ICAuthorizationCommand.m
//  MPCheckout
//
//  Created by Valio Cholakov on 10.07.20.
//  Copyright © 2020 Intercard Finance AD. All rights reserved.
//

#import "ICAuthorizationCommand.h"

@implementation ICAuthorizationCommand

#pragma mark - Initialziers

- (instancetype)initWithAmount:(NSString *)amount
                       orderId:(NSString *)orderId
                      itemName:(NSString *)itemName
                     cardToken:(NSString *)cardToken {
    
    if (self = [super init]) {
        [_data setObject:ICMethodAuthorization                             forKey:ICParameterMethod];
        [_data setObject:amount                                            forKey:ICParameterAmount];
        [_data setObject:itemName                                          forKey:ICParameterItemName];
        [_data setObject:cardToken                                         forKey:ICParameterCardToken];
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
    NSString *itemName  = [_data objectForKey:ICParameterItemName];
    NSString *cardToken = [_data objectForKey:ICParameterCardToken];
    
    if (!amount || !orderId || !currency || !itemName) {
        return [super requestInfo];
    }
    
    return [NSString stringWithFormat:@"Order %@ authorization request for %@ for a %@ %@ with card %@ has been sent",
            orderId, itemName, amount, currency, cardToken];
}

- (NSString *)responseInfo {
    NSString *orderId    = [_data objectForKey:ICParameterOrderId];
    NSString *trnRef     = [_data objectForKey:ICParameterAuthorizationTrnRef];
    NSString *expiryDate = [_data objectForKey:ICParameterPreAuthExpDate];
    
    if (!orderId || !trnRef || !expiryDate) {
        return [super responseInfo];
    }
    
    return [NSString stringWithFormat:@"Response for order %@ authorization request has been received. Reference: %@ | Expiry date: %@",
            orderId, trnRef, expiryDate];
}

@end
