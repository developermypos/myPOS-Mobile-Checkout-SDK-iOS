//
//  MPAuthorization.m
//  MPCheckout
//
//  Created by Valio Cholakov on 10.07.20.
//  Copyright © 2020 Intercard Finance AD. All rights reserved.
//

#import "MPAuthorization.h"
#import "ICConstants.h"

@implementation MPAuthorization

#pragma mark - Initializers

- (instancetype)initFromData:(NSDictionary *)data {
    if (self = [super init]) {
        _date         = [data objectForKey:ICParameterDate];
        _orderId      = [data objectForKey:ICParameterOrderId];
        _amount       = [data objectForKey:ICParameterAmount];
        _currency     = [data objectForKey:ICParameterCurrency];
        _trnReference = [data objectForKey:ICParameterAuthorizationTrnRef];
    }
    
    return self;
}

@end
