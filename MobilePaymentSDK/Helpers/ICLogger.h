//
//  ICLogger.h
//  MobilePaymentSDK
//
//  Created by Valio Cholakov on 1/31/17.
//  Copyright © 2017 Intercard Finance AD. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ICLogger : NSObject

+ (void)log:(NSString *)message;
+ (void)logDebug:(NSString *)message;

@end
