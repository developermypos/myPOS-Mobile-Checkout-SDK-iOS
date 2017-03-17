//
//  ICLogger.m
//  MobilePaymentSDK
//
//  Created by Valio Cholakov on 1/31/17.
//  Copyright © 2017 Intercard Finance AD. All rights reserved.
//

#import "ICLogger.h"
#import "ICMobilePaymentManager.h"

@implementation ICLogger

#pragma mark - Public Methods

+ (void)log:(NSString *)message {
    if (!message || message.length == 0) {
        return;
    }
    
    NSLog(@"%@ [Mobile Payment SDK] %@", [NSDate new], message);
}

+ (void)logDebug:(NSString *)message {
//#if !DEBUG
    [self log:message];
//#endif
    
}

@end
