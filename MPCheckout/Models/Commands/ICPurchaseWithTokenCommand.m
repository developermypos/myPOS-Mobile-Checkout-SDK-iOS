//
//  ICPurchaseWithTokenCommand.m
//  MPCheckout
//
//  Created by Ivaylo Zhelev on 13.03.23.
//  Copyright © 2023 Intercard Finance AD. All rights reserved.
//

#import "ICPurchaseWithTokenCommand.h"

@implementation ICPurchaseWithTokenCommand

#pragma mark - Initialziers

- (instancetype)initWithAmount:(NSString *)amount
               dsTransactionId:(NSString *)dsTransactionId
                tdsReferenceId:(NSString *)tdsReferenceId
               programProtocol:(NSString *)programProtocol
                     extraData:(NSDictionary *)extraData {
    
    if (self = [super init]) {
        [_data setObject:ICMethodPurchaseWithToken                              forKey:ICParameterMethod];
        [_data setObject:amount                                                 forKey:ICParameterAmount];
        [_data setObject:[[ICMobilePaymentManager sharedManager] currency]      forKey:ICParameterCurrency];
        
        if (dsTransactionId) {
            [_data setObject:dsTransactionId                                  forKey:ICParameterDsTransactionId];
        }
        
        if (tdsReferenceId) {
            [_data setObject:tdsReferenceId                                   forKey:IC3DSParameterTDSReferenceId];
        }
        
        if (programProtocol) {
            [_data setObject:programProtocol                                  forKey:ICParameterProgramProtocol];
        }
        
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
