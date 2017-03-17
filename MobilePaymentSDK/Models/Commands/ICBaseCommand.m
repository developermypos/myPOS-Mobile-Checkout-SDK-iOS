//
//  ICBaseCommand.m
//  MobilePaymentSDK
//
//  Created by Valio Cholakov on 1/31/17.
//  Copyright © 2017 Intercard Finance AD. All rights reserved.
//

#import "ICBaseCommand.h"

@implementation ICBaseCommand

#pragma mark - Initializers

- (instancetype)init {
    if (self = [super init]) {
        _data = [@{
                   ICParameterSID          : [[ICMobilePaymentManager sharedManager] storeId],
                   ICParameterVersion      : kSDKVersion,
                   ICParameterLanguage     : [[ICMobilePaymentManager sharedManager] language],
                   ICParameterKeyIndex     : ICIntegerToString([[ICMobilePaymentManager sharedManager] keyIndex]),
                   ICParameterIPCVersion   : kIPCVersion,
                   ICParameterOutputFormat : kOutputFormat,
                   ICParameterWalletNumber : [[ICMobilePaymentManager sharedManager] walletNumber]
                   }
                 mutableCopy];
    }
    
    return self;
}

#pragma mark - Abstract Methods

- (NSDictionary *)data {
    return (NSDictionary *)_data;
}

- (NSString *)requestInfo {
    return @"";
}

- (NSString *)responseInfo {
    return @"";
}

@end
