//
//  UIColor+Helpers.m
//  MPCheckout
//
//  Created by Valio Cholakov on 1/30/17.
//  Copyright © 2017 Intercard Finance AD. All rights reserved.
//

#import "UIColor+Helpers.h"
#import "UIColor+HexString.h"
#import "ICConstants.h"

@implementation UIColor (Helpers)

#pragma mark - Public Methods

+ (UIColor *)buttonEnabled {
    return [UIColor colorWithHexString:ICColorEnabled];
}

+ (UIColor *)buttonDisabled {
    return [UIColor colorWithHexString:ICColorDisabled];
}

+ (UIColor *)navigationBarDefaultColor {
    return [self colorWithRGB:247.0f / 255.0f];
}

+ (UIColor *)backgroundGray {
    return [UIColor colorWithHexString:ICColorBackgroundGray];
}

+ (UIColor *)navigationBarDefaultBackgroundColor {
    return [self colorWithRGB:246.0f / 255.0f];
}

+ (UIColor *)defaultTextColor {
    return [UIColor blackColor];
}

+ (UIColor *)defaultPlaceholderColor {
    return [UIColor blackColor];
}

#pragma mark - Private Methods

+ (UIColor *)colorWithRGB:(CGFloat)rgb {
    return [UIColor colorWithRed:rgb green:rgb blue:rgb alpha:1.0];
}

@end
