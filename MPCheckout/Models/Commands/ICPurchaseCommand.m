//
//  ICPurchaseCommand.m
//  MPCheckout
//
//  Created by Valio Cholakov on 1/31/17.
//  Copyright © 2017 Intercard Finance AD. All rights reserved.
//

#import "ICPurchaseCommand.h"

@implementation ICPurchaseCommand

#pragma mark - Initialziers

- (instancetype)initWithAmount:(NSString *)amount
               dsTransactionId:(NSString *)dsTransactionId
               programProtocol:(NSString *)programProtocol
                  requestToken:(BOOL)requestToken
                     extraData:(NSDictionary *)extraData {
    
    if (self = [super init]) {
        [_data setObject:ICMethodPurchase                                  forKey:ICParameterMethod];
        [_data setObject:amount                                            forKey:ICParameterAmount];
        [_data setObject:[[ICMobilePaymentManager sharedManager] currency] forKey:ICParameterCurrency];
        [_data setObject:[NSNumber numberWithBool:requestToken]            forKey:ICParameterRequestToken];
        
        if (dsTransactionId) {
            [_data setObject:dsTransactionId                                  forKey:IC3DSParameterDsTransactionId];
        }
        
        if (programProtocol) {
            [_data setObject:programProtocol                                  forKey:IC3DSParameterProgramProtocol];
        }
        
        [_data addEntriesFromDictionary:extraData];
    }
    
    return self;
}

- (instancetype)initWithAmount:(NSString *)amount
                  requestToken:(BOOL)requestToken
                     extraData:(NSDictionary *)extraData {
    if (self = [super init]) {
        [_data setObject:ICMethodPurchase                                  forKey:ICParameterMethod];
        [_data setObject:amount                                            forKey:ICParameterAmount];
        [_data setObject:[[ICMobilePaymentManager sharedManager] currency] forKey:ICParameterCurrency];
        [_data setObject:[NSNumber numberWithBool:requestToken]            forKey:ICParameterRequestToken];
        
        [_data addEntriesFromDictionary:extraData];
    }
    
    return self;
}

#pragma mark - Abstract Methods

- (NSString *)requestInfo {
    NSString *amount    = [_data objectForKey:ICParameterAmount];
    NSString *orderId   = [_data objectForKey:ICParameterOrderId];
    NSString *currency  = [_data objectForKey:ICParameterCurrency];
    NSString *cartItems = [_data objectForKey:ICParameterCartItems];
    
    if (!amount || !orderId || !currency || !cartItems) {
        return [super requestInfo];
    }
    
    return [NSString stringWithFormat:@"Order %@ purchase request for %@ items for a total of %@ %@ has been sent",
            orderId, cartItems, amount, currency];
}

- (NSString *)responseInfo {
    NSString *orderId = [_data objectForKey:ICParameterOrderId];
    
    if (!orderId) {
        return [super responseInfo];
    }
    
    return [NSString stringWithFormat:@"Response for order %@ purchase request has been received", orderId];
}

@end
