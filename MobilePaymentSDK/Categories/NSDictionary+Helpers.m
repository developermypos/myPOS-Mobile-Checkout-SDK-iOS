//
//  NSDictionary+Helpers.m
//  MobilePaymentSDK
//
//  Created by Valio Cholakov on 1/30/17.
//  Copyright © 2017 Intercard Finance AD. All rights reserved.
//

#import "NSDictionary+Helpers.h"
#import "NSString+Helpers.h"

@implementation NSDictionary (Helpers)

#pragma mark - Public Methods

- (NSString *)formData {
    __block NSString *formData = @"";
    
    [[self allKeys] enumerateObjectsUsingBlock:^(NSString * _Nonnull key, NSUInteger idx, BOOL * _Nonnull stop) {
        formData = [NSString stringWithFormat:@"%@&%@=%@", formData, key, [[self valueForKey:key] urlEncoded]];
    }];
    
    return [formData substringFromIndex:1];
}

@end
