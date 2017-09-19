//
//  NSRegularExpression+Helpers.h
//  MobilePaymentSDK
//
//  Created by Valio Cholakov on 4/20/17.
//  Copyright © 2017 Intercard Finance AD. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSRegularExpression (Helpers)

+ (BOOL)string:(NSString *)string matchesRegularExpression:(NSString *)regularExpression;

@end
