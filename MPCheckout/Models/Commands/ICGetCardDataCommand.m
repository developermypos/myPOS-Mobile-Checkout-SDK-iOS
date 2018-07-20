//
//  ICGetCardDataCommand.m
//  MPCheckout
//
//  Created by Valio Cholakov on 1/31/17.
//  Copyright © 2017 Intercard Finance AD. All rights reserved.
//

#import "ICGetCardDataCommand.h"
#import "NSString+Helpers.h"

@implementation ICGetCardDataCommand

#pragma mark - Initializers

- (instancetype)initWithPan:(NSString *)pan {
    if (self = [super init]) {
        [_data setObject:[pan encrypted] ? : @""                           forKey:ICParameterPAN];
        [_data setObject:ICMethodGetCardData                               forKey:ICParameterMethod];
        [_data setObject:[[ICMobilePaymentManager sharedManager] currency] forKey:ICParameterCurrency];
    }
    
    return self;
}

#pragma mark - Abstract Methods

- (NSString *)requestInfo {
    return @"Verifying card...";
}

@end
