//
//  MPCheckoutTheme.m
//  MPCheckout
//
//  Created by Valio Cholakov on 1/31/17.
//  Copyright © 2017 Intercard Finance AD. All rights reserved.
//

#import "MPCheckoutTheme.h"
#import "ICThemeManager.h"

#import "UIColor+Helpers.h"
#import "UIColor+HexString.h"

@interface MPCheckoutTheme () <ICThemeManager>

@end

@implementation MPCheckoutTheme

- (instancetype)init {
    if (self = [super init]) {
        self.labelFontSize        = 13.0f;
        self.placeholderFontSize  = 13.0f;
        self.textFieldBorderColor = [[UIColor grayColor] colorWithAlphaComponent:0.3f];
        self.placeholderAlignment = NSTextAlignmentLeft;
        self.textFieldFont        = [UIFont  systemFontOfSize:14.0f];
        self.labelTextColor       = [UIColor defaultTextColor];
        self.placeholderColor     = [UIColor lightGrayColor];
        self.barButtonItemColor   = [UIColor buttonEnabled];
        self.textFieldTextColor   = [UIColor defaultTextColor];
        self.navigationTitleColor = [UIColor defaultTextColor];
    }
    
    return self;
}

#pragma mark - Public Methods

- (void)setTheme:(MPCheckoutTheme *)theme {
    self.labelFontSize        = theme.labelFontSize;
    self.placeholderFontSize  = theme.placeholderFontSize;
    self.textFieldBorderColor = theme.textFieldBorderColor;
    self.placeholderAlignment = theme.placeholderAlignment;
    self.textFieldFont        = theme.textFieldFont;
    self.labelTextColor       = theme.labelTextColor;
    self.placeholderColor     = theme.placeholderColor;
    self.barButtonItemColor   = theme.barButtonItemColor;
    self.textFieldTextColor   = theme.textFieldTextColor;
    self.navigationTitleColor = theme.navigationTitleColor;
    self.navigationBarColor   = theme.navigationBarColor;
}

#pragma mark - ICTheme Implementation

- (UIColor *)backgroundColor:(ICThemeViewBackground)background
{
    NSString *key = nil;
    switch (background) {
        case ICThemeViewBackgroundLogin:
            key = kNameLoginControllersBackground;
            break;
            
        default:
            key = kNameDefaultControllersBackground;
            break;
    }
    UIImage *image = [UIImage imageNamed:key];
    image = [image resizableImageWithCapInsets:UIEdgeInsetsZero];
    
    return [UIColor colorWithPatternImage:image];
}

- (UIImage *)tableBackground
{
    UIImage *image = [UIImage imageNamed:kNameDefaultControllersBackground];
    image = [image resizableImageWithCapInsets:UIEdgeInsetsZero];
    
    return image;
}

- (UIImage *)tabMenuTableBackground
{
    UIImage *image = [UIImage imageNamed:kNameTabControllersBackground];
    image = [image resizableImageWithCapInsets:UIEdgeInsetsZero];
    
    return image;
}

//  w:27,h:17 all metrics
- (UIImage *)textBackgroundForState:(UIControlState)state withImage:(NSString *)underlineImageName
{
    NSString *name = underlineImageName ? : kNameTextFieldBackgroundRed;
    if (state == UIControlStateHighlighted) {
        name = [name stringByAppendingString:kNameHighlightedExtensionString];
    }
    
    UIImage *image = [UIImage imageNamed:name];
    image = [image resizableImageWithCapInsets:UIEdgeInsetsMake(8.0, 13.0, 8.0, 13.0)];
    return image;
}

- (UIFont *)fontWithSize:(CGFloat)size
{
    return [UIFont fontWithName:kNameApplicationDefaultFont size:size];
}

- (UIFont *)fontWithName:(NSString *)name size:(CGFloat)size
{
    return [UIFont fontWithName:name size:size];
}

- (UIFont *)boldFontWithSize:(CGFloat)size
{
    return [UIFont fontWithName:kNameApplicationBoldFont size:size];
}

- (UIFont *)italicFontWithSize:(CGFloat)size
{
    return [UIFont fontWithName:kNameApplicationItalicFont size:size];
}

- (UIFont *)mediumFontWithSize:(CGFloat)size
{
    return [UIFont fontWithName:kNameApplicationMediumFont size:size];
}

- (UIFont *)mediumItalicFontWithSize:(CGFloat)size
{
    return [UIFont fontWithName:kNameApplicationMediumItalicFont size:size];
}

- (UIFont *)lightFontWithSize:(CGFloat)size
{
    return [UIFont fontWithName:kNameApplicationLightFont size:size];
}

- (UIFont *)lightItalicFontWithSize:(CGFloat)size
{
    return [UIFont fontWithName:kNameApplicationLightItalicFont size:size];
}

- (UIFont *)thinFontWithSize:(CGFloat)size
{
    return [UIFont fontWithName:kNameApplicationThinFont size:size];
}

- (UIFont *)thinItalicFontWithSize:(CGFloat)size
{
    return [UIFont fontWithName:kNameApplicationThinItalicFont size:size];
}

- (UIFont *)checkFontWithSize:(CGFloat)size
{
    return [UIFont fontWithName:kNameCheckFont size:size];
}

- (UIFont *)textFieldFont
{
    return [self mediumFontWithSize:kNameTextFieldFontSize];
}

- (UIFont *)messagesTextViewFont
{
    return [UIFont fontWithName:kNameApplicationLightFont size:15.0f];
}

- (UIFont *)messageStatusFont
{
    return [UIFont fontWithName:kNameApplicationLightFont size:11.0f];
}

- (UIFont *)messageDateFont
{
    return [UIFont fontWithName:kNameApplicationLightFont size:13.0f];
}

- (UIColor *)textFieldFontColor
{
    NSString *hexColor = [[self hexColorsMap] objectForKey:kNameTextFieldFontColor];
    return hexColor ? [UIColor colorWithHexString:hexColor] : nil;
}

- (UIColor *)textPlaceholderColor
{
    NSString *hexColor = [[self hexColorsMap] objectForKey:kNameTextFieldPlaceholderColor];
    return hexColor ? [UIColor colorWithHexString:hexColor] : nil;
}

- (UIFont *)fontForButton:(ICThemeButton)button
{
    return [self fontForButton:button withSize:kNameButtonFontSize];
}

- (UIFont *)fontForButton:(ICThemeButton)button withSize:(CGFloat)size
{
    switch (button) {
        case ICThemeButtonTab:
            return [UIFont fontWithName:kNameApplicationLightFont size:10.0f];
            break;
            
        case ICThemeButtonLeuYellow:
            return [self fontWithName:kNameApplicationLightFont size:size];;
            break;
            
        default:
            return [self fontWithSize:size];
            break;
    }
}

- (UIColor *)buttonTitleColor:(ICThemeButton)button state:(UIControlState)state
{
    NSString *key = nil;
    
    switch (state) {
        case UIControlStateHighlighted:
            key = kNameHighlightedButtonTitleColor;
            break;
            
        case UIControlStateDisabled:
            key = kNameDisabledButtonTitleColor;
            break;
            
        case UIControlStateSelected:
            key = kNameSelectedButtonTitleColor;
            break;
            
        default:
            switch (button) {
                case ICThemeButtonGray:
                    key = kNameDarkGrayIntroFontColor;
                    break;
                    
                case ICThemeButtonBlue:
                case ICThemeButtonLink:
                    key = kNameYellowButtonTitleColor;
                    break;
                    
                case ICThemeButtonLeuYellow:
                    key = kNameLeuYellow;
                    break;
                    
                default:
                    break;
            }
            break;
    }
    
    if (key == nil)
        return [UIColor whiteColor];
    
    NSDictionary *colorsMap = [self hexColorsMap];
    NSString *hexColor = [colorsMap objectForKey:key];
    
    return hexColor ? [UIColor colorWithHexString:hexColor] : [UIColor whiteColor];
}

- (UIColor *)labelTextColor:(ICThemeLabelColor)color
{
    NSString *key = nil;
    // apply state
    switch (color) {
        case ICThemeLabelColorWhite:
            key = kNameWhiteLabelFontColor;
            break;
            
        case ICThemeLabelColorGray:
            key = kNameGrayLabelFontColor;
            break;
            
        case ICThemeLabelColorGreen:
            key = kNameGreenLabelFontColor;
            break;
            
        case ICThemeLabelColorRed:
            key = kNameRedLabelFontColor;
            break;
            
        case ICThemeLabelColorBlue:
            key = kNameBlueLabelFontColor;
            break;
            
        case ICThemeLabelColorDarkGray:
            key = kNameDarkGrayLabelFontColor;
            break;
            
        case ICTHemeLabelColorLeuYellow:
            key = kNameLeuYellow;
            break;
            
        case ICThemeLabelColorDarkRed:
            key = kNameDarkRedFontColor;
            break;
            
        case ICThemeLabelColorDarkGreen:
            key = kNameDarkGreenFontColor;
            break;
            
        case ICThemeLabelColorDefault:
        case ICThemeLabelColorIntro:
            key = kNameDarkGrayIntroFontColor;
            break;
            
        case ICThemeLabelColorPlaceholderLight:
            key = kNameLabelColorPlaceholderLight;
            break;
            
        case ICThemeLabelColorPureGray:
            key = kNamePureGrayColor;
            break;
            
        case ICThemeLabelColorMyPosBlue:
            key = kNameMyPosBlue;
            break;
            
        default:
            break;
    }
    
    NSDictionary *colorsMap = [self hexColorsMap];
    NSString *hexColor = [colorsMap objectForKey:key];
    
    return hexColor ? [UIColor colorWithHexString:hexColor] : [UIColor whiteColor];
}

- (UIColor *)textFieldTextColor:(ICThemeTextField)textField
{
    NSString *key = nil;
    
    switch (textField) {
        case ICThemeTextFieldWhite:
            key = kNameWhiteTextFieldFontColor;
            break;
            
        case ICThemeTextFieldGray:
            key = kNameGrayTextFieldFontColor;
            break;
            
        case ICThemeTextFieldGreen:
            key = kNameGreenTextFieldFontColor;
            break;
            
        case ICThemeTextFieldRed:
            key = kNameRedTextFieldFontColor;
            break;
            
        case ICThemeTextFieldBlue:
            key = kNameBlueTextFieldFontColor;
            break;
            
        case ICThemeTextFieldLightGray:
            key = kNameLightGrayTextFieldFontColor;
            break;
            
        default:
            break;
    }
    
    NSDictionary *colorsMap = [self hexColorsMap];
    NSString *hexColor = [colorsMap objectForKey:key];
    
    return hexColor ? [UIColor colorWithHexString:hexColor] : [UIColor whiteColor];
}

- (UIColor *)redColor {
    return [UIColor colorWithHexString:[[self hexColorsMap] objectForKey:kNameRedLabelFontColor]];
}

- (UIColor *)defaultColor {
    return [UIColor colorWithHexString:[[self hexColorsMap] objectForKey:kNameDarkGrayIntroFontColor]];
}

// portrait = w:17,h:44 for 1 color image
- (UIImage *)navigationBackgroundForBarMetrics:(UIBarMetrics)metrics
{
    NSString *name = kNameNavigationBarBackground;

    UIImage *image = [UIImage imageNamed:name];
    image = [image resizableImageWithCapInsets:UIEdgeInsetsMake(0.0, 8.0, 0.0, 8.0)];
    return image;
}

// portrait = w:27,h:30
- (UIImage *)barButtonBackgroundForState:(UIControlState)state barMetrics:(UIBarMetrics)barMetrics
{
    NSString *name = kNameNavigationBarButton;
    if (state == UIControlStateHighlighted) {
        name = [name stringByAppendingString:kNameHighlightedExtensionString];
    }
    UIImage *image = [UIImage imageNamed:name];
    image = [image resizableImageWithCapInsets:UIEdgeInsetsMake(0.0, 13.0, 0.0, 13.0)];
    return image;
}

// portrait = w:36,h:30
- (UIImage *)backBackgroundForState:(UIControlState)state barMetrics:(UIBarMetrics)barMetrics
{
    NSString *name = kNameNavigationBarBackButton;
    if (state == UIControlStateHighlighted) {
        name = [name stringByAppendingString:kNameHighlightedExtensionString];
    }
    UIImage *image = [UIImage imageNamed:name];
    image = [image resizableImageWithCapInsets:UIEdgeInsetsMake(0.0, 25.0, 0.0, 10.0)];
    return image;
}

- (UIImage *)cellMarkForStyle:(ICThemeCellStyle)cellStyle
{
    NSString *name = nil;
    switch (cellStyle) {
        case ICThemeCellStyleWhite:
            name = kNameCellWhiteMark;
            break;
            
        case ICThemeCellStyleRed:
            name = kNameCellRedMark;
            break;
            
        case ICThemeCellStyleGreen:
            name = kNameCellGreenMark;
            break;
            
        case ICThemeCellStyleBlue:
            name = kNameCellBlueMark;
            break;
            
        case ICThemeCellStyleLightGray:
            name = kNameCellLightGrayMark;
            break;
            
        case ICThemeCellStyleDarkGray:
            name = kNameCellDarkGrayMark;
            break;
            
        default:
            break;
    }
    
    if (name == nil)
        return nil;
    
    UIImage *image = [UIImage imageNamed:name];
    image = [image resizableImageWithCapInsets:UIEdgeInsetsMake(8.0, 0.0, 8.0, 0.0)];
    return image;
}

- (UIColor *)mainTintColor
{
    NSDictionary *colorsMap = [self hexColorsMap];
    NSString *hexColor = [colorsMap objectForKey:kNameMainTintColor];
    
    return hexColor ? [UIColor colorWithHexString:hexColor] : nil;
}

- (UIColor *)segmentTintColor
{
    NSDictionary *colorsMap = [self hexColorsMap];
    NSString *hexColor = [colorsMap objectForKey:kNameBlueTintColor];
    
    return hexColor ? [UIColor colorWithHexString:hexColor] : nil;
}

// portrait = w:17,h:44
- (UIImage *)toolbarBackgroundForBarMetrics:(UIBarMetrics)metrics
{
    NSString *name = kNameToolBarBackground;

    UIImage *image = [UIImage imageNamed:name];
    image = [image resizableImageWithCapInsets:UIEdgeInsetsMake(0.0, 8.0, 0.0, 8.0)];
    return image;
}


// portrait = w:27,h:30
- (UIImage *)segmentedBackgroundForState:(UIControlState)state barMetrics:(UIBarMetrics)barMetrics
{
    NSString *name = kNameSegmentBackground;
    if (state == UIControlStateSelected) {
        name = [name stringByAppendingString:kNameSelectedExtensionString];
    }
    UIImage *image = [UIImage imageNamed:name];
    image = [image resizableImageWithCapInsets:UIEdgeInsetsMake(0.0f, 13.0f, 0.0f, 13.0f)];
    return image;
}

// portrait = w:1,h:30
- (UIImage *)segmentedDividerForBarMetrics:(UIBarMetrics)barMetrics
{
    NSString *name = kNameSegmentedDivider;
    return [UIImage imageNamed:name];
}

// search bar
// w:1,h:44 all metrics
- (UIImage *)searchBackground
{
    return [UIImage imageNamed:kNameSearchBarBackground];
}

// w:33,h:32 all metrics
- (UIImage *)searchFieldImage
{
    UIImage *image = [UIImage imageNamed:kNameSearchFieldBackground];
    image = [image resizableImageWithCapInsets:UIEdgeInsetsMake(0.0, 16.0, 0.0, 16.0)];
    return image;
}

// w:33,h:44 all metrics
- (UIImage *)backgroundForButton:(ICThemeButton)button state:(UIControlState)state
{
    NSString *name = nil;
    switch (button) {
        case ICThemeButtonInfo:
            name = kNameButtonInfoBackground;
            break;
            
        case ICThemeButtonToggle:
            name = kNameButtonToggleBackground;
            break;
            
        case ICThemeButtonAdd:
            name = kNameButtonAddBackground;
            break;
            
        default:
            break;
    }
    
    if (name == nil)
        return nil;
    
    // apply state extension
    if (state == UIControlStateHighlighted) {
        name = [name stringByAppendingString:kNameHighlightedExtensionString];
    } else if (state == UIControlStateDisabled) {
        name = [name stringByAppendingString:kNameDisabledExtensionString];
    } else if (state == UIControlStateSelected) {
        name = [name stringByAppendingString:kNameSelectedExtensionString];
    }
    
    UIImage *image = [UIImage imageNamed:name];
    return image;
}

// portrait = w:320,h:49
- (UIImage *)tabBarBackground
{
    UIImage *image = [UIImage imageNamed:kNameTabBarBackground];
    return image;
}

- (UIImage *)imageForTab:(ICThemeTab)tab selected:(BOOL)selected {
    NSString *name = nil;
    
    switch (tab) {
        case ICThemeTabAccount:
            name = kCash;
            break;
            
        case ICThemeTabDevices:
            name = kmyPOS;
            break;
            
        case ICThemeTabCards:
            name = kCards;
            break;
            
        case ICThemeTabMore:
            name = kMore;
            break;
            
        default:
            break;
    }
    
    if (selected) {
        name = [name stringByAppendingString:kNameSelectedExtensionString];
    }
    
    return (name ? [UIImage imageNamed:name] : nil);
}

- (UIColor *)switchMainTintColor
{
    NSDictionary *colorsMap = [self hexColorsMap];
    NSString *hexColor = [colorsMap objectForKey:kNameSwitchMainTintColor];
    
    return hexColor ? [UIColor colorWithHexString:hexColor] : nil;
}

- (UIColor *)switchOnTintColor
{
    NSDictionary *colorsMap = [self hexColorsMap];
    NSString *hexColor = [colorsMap objectForKey:kNameSwitchOnTintColor];
    
    return hexColor ? [UIColor colorWithHexString:hexColor] : nil;
}

- (UIColor *)pageIndicatorTintColor
{
    NSDictionary *colorsMap = [self hexColorsMap];
    NSString *hexColor = [colorsMap objectForKey:kNamePageIndicatorTintColor];
    
    return hexColor ? [UIColor colorWithHexString:hexColor] : nil;
}

- (UIColor *)currentPageIndicatorTintColor
{
    NSDictionary *colorsMap = [self hexColorsMap];
    NSString *hexColor = [colorsMap objectForKey:kNameCurrentPageIndicatorTintColor];
    
    return hexColor ? [UIColor colorWithHexString:hexColor] : nil;
}

- (UIColor *)tabButtonBackgroundColor:(BOOL)selected
{
    if (!selected) {
        return [UIColor clearColor];
    }
    
    NSDictionary *colorsMap = [self hexColorsMap];
    NSString *hexColor = [colorsMap objectForKey:kNameTabButtonBackgroundColor];
    
    return hexColor ? [UIColor colorWithHexString:hexColor] : nil;
}


#pragma mark - Helpers

- (NSDictionary *)hexColorsMap
{
    static NSDictionary *colorsMap;
    
    if (colorsMap == nil) {
        colorsMap = @{
                      kNameTextFieldFontColor               :   @"#5b5b5b",
                      kNameTextFieldPlaceholderColor        :   @"#B1B1B1",
                      kNameGrayButtonTitleColor             :   @"#7D8082",
                      kNameBlueButtonTitleColor             :   @"#0077C1",
                      kNameHighlightedButtonTitleColor      :   @"#FFFFFF",
                      kNameSelectedButtonTitleColor         :   @"#009EFF",
                      kNameDisabledButtonTitleColor         :   @"#B2B2B2",
                      kNameGrayLabelFontColor               :   @"#7D8082",
                      kNameLightGrayLabelFontColor          :   @"#b8b8b8",
                      kNameDarkGrayLabelFontColor           :   @"#474747",
                      kNameWhiteLabelFontColor              :   @"#FFFFFF",
                      kNameGreenLabelFontColor              :   @"#407220",
                      kNameRedLabelFontColor                :   @"#8c2020",
                      kNameBlueLabelFontColor               :   @"#0077C1",
                      kNameMainTintColor                    :   @"#FFFFFF",
                      kNameBlueTintColor                    :   @"#0077C1",
                      kNameSwitchMainTintColor              :   @"#7D8082",
                      kNameSwitchOnTintColor                :   @"#0077C1",
                      kNamePageIndicatorTintColor           :   @"#7D8082",
                      kNameCurrentPageIndicatorTintColor    :   @"#0077C1",
                      kNameTabButtonBackgroundColor         :   @"#7D8082",
                      kNameDarkGrayIntroFontColor           :   @"#5b5b5b",
                      kNameLightGrayTextFieldFontColor      :   @"#4C4030",
                      kNameYellowButtonTitleColor           :   @"#0072ba",
                      kNameLeuYellow                        :   @"#F8D031",
                      kNameDarkRedFontColor                 :   @"#92393C",
                      kNameDarkGreenFontColor               :   @"#407220",
                      kNameLabelColorPlaceholderLight       :   @"#A6A6A6",
                      kNamePureGrayColor                    :   @"#777777",
                      kNameMyPosBlue                        :   @"#0072ba",
                      };
    }
    
    return colorsMap;
}

@end
