//
//  ICThemedTextField.h
//  MPCheckout
//
//  Created by Valio Cholakov on 1/31/17.
//  Copyright © 2017 Intercard Finance AD. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ICThemedTextField : UITextField

@property (nonatomic) NSTextAlignment placeholderAlignment;
@property (nonatomic) CGFloat placeholderFontSize;
@property (nonatomic, strong) UIColor *placeholderColor;
@property (nonatomic, strong) UIColor *borderColor;

@end
