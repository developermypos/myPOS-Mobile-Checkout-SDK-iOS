//
//  ICUpdateStoredCardCommand.m
//  MPCheckout
//
//  Created by Valio Cholakov on 1/31/17.
//  Copyright © 2017 Intercard Finance AD. All rights reserved.
//

#import "ICUpdateStoredCardCommand.h"

@implementation ICUpdateStoredCardCommand

#pragma mark - Initializers

- (instancetype)initWithToken:(NSString *)token
                          pan:(NSString *)pan
                          cvc:(NSString *)cvc
                   expiryDate:(NSString *)expiryDate
                   embossName:(NSString *)embossName
                   customName:(NSString *)customName
                       amount:(NSString *)amount
                    extraData:(NSDictionary *)extraData {
    if (self = [super initWithPan:pan cvc:cvc expiryDate:expiryDate embossName:embossName customName:customName amount:amount autoReverse:NO extraData:extraData]) {
        [_data setObject:token                    forKey:ICParameterCardToken];
        [_data setObject:ICMethodUpdateStoredCard forKey:ICParameterMethod];
    }
    
    return self;
}

#pragma mark - Abstract Methods

- (NSString *)requestInfo {
    NSString *customName = [_data objectForKey:ICParameterCustomName];
    
    if (!customName) {
        return [super requestInfo];
    }
    
    return [NSString stringWithFormat:@"Update stored card with custom name %@ request has been sent", customName];
}

- (NSString *)responseInfo {
    NSString *customName = [_data objectForKey:ICParameterCustomName];
    
    if (!customName) {
        return [super responseInfo];
    }
    
    return [NSString stringWithFormat:@"Response for store card update with custom name %@ has been received", customName];
}

@end
