//
//  MPCheckoutTheme.h
//  MPCheckout
//
//  Created by Valio Cholakov on 1/31/17.
//  Copyright © 2017 Intercard Finance AD. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MPCheckoutTheme : NSObject

@property (nonatomic) CGFloat labelFontSize;
@property (nonatomic) CGFloat placeholderFontSize;
@property (nonatomic) NSTextAlignment placeholderAlignment;
@property (nonatomic, strong, nonnull) UIFont *textFieldFont;
@property (nonatomic, strong, nonnull) UIColor *labelTextColor;
@property (nonatomic, strong, nonnull) UIColor *placeholderColor;
@property (nonatomic, strong, nonnull) UIColor *barButtonItemColor;
@property (nonatomic, strong, nonnull) UIColor *textFieldTextColor;
@property (nonatomic, strong, nonnull) UIColor *navigationTitleColor;
@property (nonatomic, strong, nonnull) UIColor *textFieldBorderColor;
@property (nonatomic, strong, nullable) UIColor *navigationBarColor;

/*!
 * @method setTheme:
 *
 * @param theme A custom theme that will be applied across the SDK screens. 
 */
- (void)setTheme:(nonnull MPCheckoutTheme *)theme;

@end
