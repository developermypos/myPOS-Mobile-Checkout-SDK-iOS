//
//  NSRegularExpression+Helpers.m
//  MPCheckout
//
//  Created by Valio Cholakov on 4/20/17.
//  Copyright © 2017 Intercard Finance AD. All rights reserved.
//

#import "NSRegularExpression+Helpers.h"

@implementation NSRegularExpression (Helpers)

#pragma mark - Public Methods

+ (BOOL)string:(NSString *)string matchesRegularExpression:(NSString *)regularExpression {
    NSError             *error = nil;
    NSRegularExpression *regEx = [NSRegularExpression regularExpressionWithPattern:regularExpression options:0 error:&error];
    
    if (error != nil) {
        return NO;
    }
    
    return [regEx rangeOfFirstMatchInString:string options:0 range:NSMakeRange(0, string.length)].location != NSNotFound;
}

@end
