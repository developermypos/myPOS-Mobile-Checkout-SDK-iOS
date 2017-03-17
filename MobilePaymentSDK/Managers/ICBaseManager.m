//
//  ICBaseManager.m
//  MobilePaymentSDK
//
//  Created by Valio Cholakov on 1/31/17.
//  Copyright © 2017 Intercard Finance AD. All rights reserved.
//

#import "ICBaseManager.h"

@implementation ICBaseManager

#pragma mark - Singleton

+ (instancetype)sharedManager {
    NSAssert(NO, @"Abstract method not implemented - %s", __PRETTY_FUNCTION__);
    return nil;
}

@end
