//
//  ICStoreCardCommand.m
//  MPCheckout
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
                autoReverse:(BOOL)autoReverse
                  extraData:(NSDictionary *)extraData {
    if (self = [super init]) {
        [_data setObject:ICMethodStoreCard                                 forKey:ICParameterMethod];
        [_data setObject:embossName                                        forKey:ICParameterEmbossName];
        [_data setObject:customName                                        forKey:ICParameterCustomName];
        [_data setObject:[pan        encrypted]                            forKey:ICParameterPAN];
        [_data setObject:[cvc        encrypted]                            forKey:ICParameterCVC];
        [_data setObject:[expiryDate encrypted]                            forKey:ICParameterExpiryDate];
        [_data setObject:[[ICMobilePaymentManager sharedManager] currency] forKey:ICParameterCurrency];
        
        if (amount.doubleValue == 0.00) {
            [_data setObject:@"1" forKey:ICParameterCardVerification];
        }
        else {
            [_data setObject:@"2"   forKey:ICParameterCardVerification];
            [_data setObject:amount forKey:ICParameterAmount];
        }
        
        [_data setValue:[[NSNumber numberWithBool:autoReverse] stringValue]  forKey:ICParameterAutoReverse];
        
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
    NSString *transactionRef = [[_data objectForKey:ICParameterTransactionRef] stringValue];
    
    if (!customName || !transactionRef) {
        return [super responseInfo];
    }
    
    return [NSString stringWithFormat:@"Response for store card with custom name %@ and transaction reference %@ has been received", customName, transactionRef];
}

@end
