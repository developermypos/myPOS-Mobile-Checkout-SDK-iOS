//
//  ICThemedTextField.m
//  MobilePaymentSDK
//
//  Created by Valio Cholakov on 1/31/17.
//  Copyright © 2017 Intercard Finance AD. All rights reserved.
//

#import "ICThemedTextField.h"

#import "ICThemeManager.h"
#import "ICConstants.h"
#import "MobilePaymentTheme.h"

@interface ICThemedTextField() {
    CALayer *_bottomBorder;
}

@end

static CGFloat const kTextFieldInsets = 4.0f;

@implementation ICThemedTextField

#pragma mark - Initializers

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self customInit];
    }
    
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    if (self = [super initWithCoder:aDecoder]) {
        [self customInit];
    }
    
    return self;
}

#pragma mark - Overrides

- (BOOL)becomeFirstResponder {
    BOOL outcome = [super becomeFirstResponder];
    
    if (outcome) {
        // Feature
    }
    
    return outcome;
}

- (BOOL)resignFirstResponder {
    BOOL outcome = [super resignFirstResponder];
    
    if (outcome) {
        // Feature
    }
    
    return outcome;
}

- (void)drawPlaceholderInRect:(CGRect)rect {
    if (!self.placeholder) {
        return;
    }
    
    MobilePaymentTheme <ICThemeManager> *theme = [self theme];
    
    CGFloat xOrigin          = 0.0f;
    UIFont  *placeholderFont = [theme lightFontWithSize:self.placeholderFontSize > 0 ? self.placeholderFontSize : [theme placeholderFontSize]];
    
    NSMutableParagraphStyle *textStyle = [[NSParagraphStyle defaultParagraphStyle] mutableCopy];
    textStyle.lineBreakMode            = NSLineBreakByWordWrapping;
    
    NSDictionary *attributes = @{
                                 NSFontAttributeName            : placeholderFont,
                                 NSParagraphStyleAttributeName  : textStyle,
                                 NSForegroundColorAttributeName : self.placeholderColor ? : [theme placeholderColor]
                                 };
    
    CGSize placeholderSize = [self.placeholder boundingRectWithSize:CGSizeMake(rect.size.width - (2 * kTextFieldInsets), rect.size.height)
                                                            options:NSStringDrawingUsesFontLeading | NSStringDrawingUsesLineFragmentOrigin
                                                         attributes:attributes
                                                            context:nil].size;
    
    NSTextAlignment alignment = self.placeholderAlignment ? : [theme placeholderAlignment];
    
    if (alignment == NSTextAlignmentLeft) {
        xOrigin = kTextFieldInsets;
    }
    else if (alignment == NSTextAlignmentCenter) {
        xOrigin = (rect.size.width - placeholderSize.width) / 2;
    }
    else if (alignment == NSTextAlignmentRight) {
        xOrigin = rect.size.width - placeholderSize.width - kTextFieldInsets;
    }
    
    CGRect placeholderRect = CGRectMake(xOrigin, (rect.size.height - placeholderSize.height) / 2, placeholderSize.width, placeholderSize.height);
    
    [self.placeholder drawInRect:placeholderRect withAttributes:attributes];
}

- (void)drawRect:(CGRect)rect {
    if (!_bottomBorder) {
        _bottomBorder             = [CALayer new];
        _bottomBorder.borderColor = self.borderColor ? [self.borderColor CGColor] : [[[self theme] textFieldBorderColor] CGColor];
        _bottomBorder.borderWidth = kSeparatorHeight;
        _bottomBorder.frame       = CGRectMake(0.0f, self.bounds.size.height - kSeparatorHeight, self.bounds.size.width, kSeparatorHeight);
        
        [self.layer addSublayer:_bottomBorder];
        [self.layer setMasksToBounds:YES];
    }
    
    [super drawRect:rect];
}

#pragma mark - Setters

- (void)setPlaceholderAlignment:(NSTextAlignment)placeholderAlignment {
    _placeholderAlignment = placeholderAlignment;
    
    [self redrawPlaceholder];
}

- (void)setPlaceholderFontSize:(CGFloat)placeholderFontSize {
    _placeholderFontSize = placeholderFontSize;
    
    [self redrawPlaceholder];
}

- (void)setPlaceholderColor:(UIColor *)placeholderColor {
    _placeholderColor = placeholderColor;
    
    [self redrawPlaceholder];
}

- (void)setBorderColor:(UIColor *)borderColor {
    _borderColor = borderColor;
    
    [self redrawPlaceholder];
}

#pragma mark - Private Methods

- (void)customInit {
    [self setBorderStyle:UITextBorderStyleNone];
    [self setContentVerticalAlignment:UIControlContentVerticalAlignmentCenter];
    
    MobilePaymentTheme *theme = [self theme];
    
    [self setFont:[theme textFieldFont]];
    [self setTextColor:[theme textFieldTextColor]];
}

- (void)redrawPlaceholder {
    if (self.placeholder == nil) {
        return;
    }
    
    NSString *placeholder = [self.placeholder copy];
    
    self.placeholder = nil;
    self.placeholder = placeholder;
}

#pragma mark - Helpers

- (MobilePaymentTheme <ICThemeManager> *)theme {
    return [ICThemeManager sharedTheme];
}

@end
