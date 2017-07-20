//
//  MobilePaymentTheme.h
//  MobilePaymentSDK
//
//  Created by Valio Cholakov on 1/31/17.
//  Copyright © 2017 Intercard Finance AD. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ICThemeManager.h"

@interface MobilePaymentTheme : NSObject<ICThemeManager>

@property (nonatomic) CGFloat placeholderFontSize;
@property (nonatomic) NSTextAlignment placeholderAlignment;
@property (nonatomic, strong) UIFont *textFieldFont;
@property (nonatomic, strong) UIColor *labelTextColor;
@property (nonatomic, strong) UIColor *placeholderColor;
@property (nonatomic, strong) UIColor *barButtonItemColor;
@property (nonatomic, strong) UIColor *textFieldTextColor;
@property (nonatomic, strong) UIColor *navigationTitleColor;
@property (nonatomic, strong) UIColor *textFieldBorderColor;

/*!
 * @method setTheme:
 *
 * @param theme A custom theme that will be applied across the SDK screens. 
 */
- (void)setTheme:(MobilePaymentTheme *)theme;

@end
