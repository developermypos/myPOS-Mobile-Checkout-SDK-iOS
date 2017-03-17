//
//  ICStoreCardCommand.m
//  MobilePaymentSDK
//
//  Created by Valio Cholakov on 1/31/17.
//  Copyright © 2017 Intercard Finance AD. All rights reserved.
//

#import "ICStoreCardCommand.h"
#import "NSString+Helpers.h"

@implementation ICStoreCardCommand

#pragma mark - Initializers

- (instancetype)initWithPan:(NSString *)pan
                        cvc:(NSString *)cvc
                 expiryDate:(NSString *)expiryDate
                 embossName:(NSString *)embossName
                 customName:(NSString *)customName
                     amount:(NSString *)amount
                  extraData:(NSDictionary *)extraData {
    if (self = [super init]) {
        [_data setObject:amount forKey:ICParameterAmount];
        [_data setObject:ICMethodStoreCard                                 forKey:ICParameterMethod];
        [_data setObject:embossName                                        forKey:ICParameterEmbossName];
        [_data setObject:customName                                        forKey:ICParameterCustomName];
        [_data setObject:[pan        encrypted]                            forKey:ICParameterPAN];
        [_data setObject:[cvc        encrypted]                            forKey:ICParameterCVC];
        [_data setObject:[expiryDate encrypted]                            forKey:ICParameterExpiryDate];
        [_data setObject:kCardVerification                                 forKey:ICParameterCardVerification];
        [_data setObject:[[ICMobilePaymentManager sharedManager] currency] forKey:ICParameterCurrency];
        
        [_data addEntriesFromDictionary:extraData];
    }
    
    return self;
}

#pragma mark - Abstract Methods

- (NSString *)requestInfo {
    NSString *customName = [_data objectForKey:ICParameterCustomName];
    
    if (!customName) {
        return [super requestInfo];
    }
    
    return [NSString stringWithFormat:@"Store card with custom name %@ request has been sent", customName];
}

- (NSString *)responseInfo {
    NSString *customName = [_data objectForKey:ICParameterCustomName];
    
    if (!customName) {
        return [super responseInfo];
    }
    
    return [NSString stringWithFormat:@"Response for store card with custom name %@ has been received", customName];
}

@end
