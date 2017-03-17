//
//  ICThemeManager.h
//  myPOS
//
//  Created by Valio Cholakov on 12/30/15.
//  Copyright (c) 2015 InterCard Finance AD. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>

typedef enum : NSUInteger
{
    ICThemeButtonDefault,
    ICThemeButtonBlue,
    ICThemeButtonLeuYellow,
    ICThemeButtonGray,
    ICThemeButtonLink,
    ICThemeButtonInfo,
    ICThemeButtonToggle,
    ICThemeButtonRadio,
    ICThemeButtonAdd,
    ICThemeButtonDown,
    ICThemeButtonTab
} ICThemeButton;

typedef enum : NSUInteger
{
    ICThemeLabelStyleDefault,
    ICThemeLabelStyleItalic,
    ICThemeLabelStyleMedium,
    ICThemeLabelStyleMediumItalic,
    ICThemeLabelStyleLight,
    ICThemeLabelStyleLightItalic,
    ICThemeLabelStyleThin,
    ICThemeLabelStyleThinItalic,
    ICThemeLabelStyleBold,
    ICTHemeLabelStyleCheck,
} ICThemeLabelStyle;

typedef enum : NSUInteger
{
    ICThemeLabelColorWhite,
    ICThemeLabelColorGray,
    ICThemeLabelColorLightGray,
    ICThemeLabelColorDarkGray,
    ICThemeLabelColorRed,
    ICThemeLabelColorGreen,
    ICThemeLabelColorBlue,
    ICThemeLabelColorPlaceholderGray,
    ICThemeLabelColorIntro,
    ICThemeLabelColorDefault,
    ICTHemeLabelColorLeuYellow,
    ICThemeLabelColorPlaceholderLight,
    ICThemeLabelColorDarkRed,
    ICThemeLabelColorDarkGreen,
    ICThemeLabelColorPureGray,
    ICThemeLabelColorMyPosBlue,
} ICThemeLabelColor;

typedef enum : NSUInteger
{
    ICThemeTextFieldStyleDefault,
    ICThemeTextFieldStyleItalic,
    ICThemeTextFieldStyleMedium,
    ICThemeTextFieldStyleLight,
    ICThemeTextFieldStyleThin,
    ICThemeTextFieldStyleThinItalic,
    ICThemeTextFieldStyleBold,
} ICThemeTextFieldStyle;

typedef enum : NSUInteger
{
    ICThemeTextFieldWhite,
    ICThemeTextFieldGray,
    ICThemeTextFieldGreen,
    ICThemeTextFieldRed,
    ICThemeTextFieldBlue,
    ICThemeTextFieldLightGray,
} ICThemeTextField;

typedef enum : NSUInteger
{
    ICThemeViewBackgroundDefault,
    ICThemeViewBackgroundLogin,
    ICTHemeViewBackgroundHome,
    ICThemeViewBackgroundTab,
} ICThemeViewBackground;

typedef enum : NSUInteger
{
    ICThemeCellStyleNone,
    ICThemeCellStyleWhite,
    ICThemeCellStyleRed,
    ICThemeCellStyleGreen,
    ICThemeCellStyleBlue,
    ICThemeCellStyleLightGray,
    ICThemeCellStyleDarkGray,
} ICThemeCellStyle;

typedef enum : NSUInteger
{
    ICThemeTabAccount,
    ICThemeTabDevices,
    ICThemeTabCards,
    ICThemeTabMore,
} ICThemeTab;

typedef enum : NSUInteger
{
    ICThemeCellAccessoryTypeNone,
    ICThemeCellAccessoryTypeDisclosure,
    ICThemeCellAccessoryTypeCheckBox,
    ICThemeCellAccessoryTypeCheckBoxChecked,
    ICTHemeCellAccessoryTypeCheck,
} ICThemeCellAccessoryType;

@protocol ICThemeManager <NSObject>

- (UIFont *)textFieldFont;
- (UIFont *)fontForButton:(ICThemeButton)button;
- (UIFont *)fontForButton:(ICThemeButton)button withSize:(CGFloat)size;
- (UIFont *)fontWithSize:(CGFloat)size;
- (UIFont *)boldFontWithSize:(CGFloat)size;
- (UIFont *)italicFontWithSize:(CGFloat)size;
- (UIFont *)mediumFontWithSize:(CGFloat)size;
- (UIFont *)mediumItalicFontWithSize:(CGFloat)size;
- (UIFont *)lightFontWithSize:(CGFloat)size;
- (UIFont *)lightItalicFontWithSize:(CGFloat)size;
- (UIFont *)thinFontWithSize:(CGFloat)size;
- (UIFont *)thinItalicFontWithSize:(CGFloat)size;
- (UIFont *)checkFontWithSize:(CGFloat)size;
- (UIFont *)fontWithName:(NSString *)name size:(CGFloat)size;
- (UIFont *)messagesTextViewFont;
- (UIFont *)messageStatusFont;
- (UIFont *)messageDateFont;

- (UIImage *)tableBackground;
- (UIImage *)tabMenuTableBackground;
- (UIImage *)textBackgroundForState:(UIControlState)state withImage:(NSString *)underlineImageName;
- (UIImage *)navigationBackgroundForBarMetrics:(UIBarMetrics)metrics;
- (UIImage *)barButtonBackgroundForState:(UIControlState)state barMetrics:(UIBarMetrics)barMetrics;
- (UIImage *)backBackgroundForState:(UIControlState)state barMetrics:(UIBarMetrics)barMetrics;
- (UIImage *)cellMarkForStyle:(ICThemeCellStyle)cellStyle;
- (UIImage *)toolbarBackgroundForBarMetrics:(UIBarMetrics)metrics;
- (UIImage *)segmentedBackgroundForState:(UIControlState)state barMetrics:(UIBarMetrics)barMetrics;
- (UIImage *)segmentedDividerForBarMetrics:(UIBarMetrics)barMetric;
- (UIImage *)searchBackground;
- (UIImage *)searchFieldImage;
- (UIImage *)backgroundForButton:(ICThemeButton)button state:(UIControlState)state;
- (UIImage *)tabBarBackground;
- (UIImage *)imageForTab:(ICThemeTab)tab selected:(BOOL)selected;

- (UIColor *)mainTintColor;
- (UIColor *)segmentTintColor;
- (UIColor *)switchMainTintColor;
- (UIColor *)switchOnTintColor;
- (UIColor *)pageIndicatorTintColor;
- (UIColor *)currentPageIndicatorTintColor;
- (UIColor *)backgroundColor:(ICThemeViewBackground)background;
- (UIColor *)textFieldFontColor;
- (UIColor *)textPlaceholderColor;
- (UIColor *)buttonTitleColor:(ICThemeButton)button state:(UIControlState)state;
- (UIColor *)tabButtonBackgroundColor:(BOOL)selected;
- (UIColor *)labelTextColor:(ICThemeLabelColor)color;
- (UIColor *)textFieldTextColor:(ICThemeTextField)textField;
- (UIColor *)redColor;
- (UIColor *)defaultColor;

@end

@class MobilePaymentTheme;

@interface ICThemeManager : NSObject

+ (MobilePaymentTheme <ICThemeManager> *)sharedTheme;
+ (UIColor *)lightGrayColor;
+ (UIColor *)customGrayColor;
+ (void)customizeAppAppearance;
+ (void)customizeLabel:(UILabel *)label size:(CGFloat)size style:(ICThemeLabelStyle)style color:(ICThemeLabelColor)color;
+ (void)customizeTextField:(UITextField *)textField size:(CGFloat)size style:(ICThemeTextFieldStyle)style type:(ICThemeTextField)type;
+ (void)customizeButton:(UIButton *)button size:(CGFloat)size type:(ICThemeButton)type;

@end

extern NSString * const kNameDefaultControllersBackground;
extern NSString * const kNameLoginControllersBackground;
extern NSString * const kNameTabControllersBackground;
extern NSString * const kNameTabControllersBackground6;
extern NSString * const kTextFieldBackgroundGray;
extern NSString * const kNameTextFieldBackgroundBlue;
extern NSString * const kNameTextFieldBackgroundWhite;
extern NSString * const kNameTextFieldBackgroundRed;

extern NSString * const kNameApplicationDefaultFont;
extern NSString * const kNameApplicationBoldFont;
extern NSString * const kNameApplicationItalicFont;
extern NSString * const kNameApplicationMediumFont;
extern NSString * const kNameApplicationMediumItalicFont;
extern NSString * const kNameApplicationThinFont;
extern NSString * const kNameApplicationLightFont;
extern NSString * const kNameApplicationLightItalicFont;
extern NSString * const kNameApplicationThinItalicFont;
extern NSString * const kNameCheckFont;

extern NSString * const kNameHighlightedExtensionString;
extern NSString * const kNameSelectedExtensionString;
extern NSString * const kNameDisabledExtensionString;

extern NSString * const kNameTextFieldFontColor;
extern NSString * const kNameTextFieldPlaceholderColor;

extern NSString * const kNameGrayButtonTitleColor;
extern NSString * const kNameBlueButtonTitleColor;
extern NSString * const kNameHighlightedButtonTitleColor;
extern NSString * const kNameYellowButtonTitleColor;
extern NSString * const kNameDisabledButtonTitleColor;
extern NSString * const kNameSelectedButtonTitleColor;
extern NSString * const kNamePureGrayColor;

extern NSString * const kNameGrayLabelFontColor;
extern NSString * const kNameLightGrayLabelFontColor;
extern NSString * const kNameDarkGrayLabelFontColor;
extern NSString * const kNameWhiteLabelFontColor;
extern NSString * const kNameGreenLabelFontColor;
extern NSString * const kNameRedLabelFontColor;
extern NSString * const kNameBlueLabelFontColor;
extern NSString * const kNameDarkGrayIntroFontColor;
extern NSString * const kNameLeuYellow;
extern NSString * const kNameDarkRedFontColor;
extern NSString * const kNameDarkGreenFontColor;
extern NSString * const kNameLabelColorPlaceholderLight;
extern NSString * const kNameMyPosBlue;

extern NSString * const kNameGrayTextFieldFontColor;
extern NSString * const kNameWhiteTextFieldFontColor;
extern NSString * const kNameGreenTextFieldFontColor;
extern NSString * const kNameRedTextFieldFontColor;
extern NSString * const kNameBlueTextFieldFontColor;
extern NSString * const kNameLightGrayTextFieldFontColor;

extern NSString * const kNameGrayNavigationBarBackgroundColor;
extern NSString * const kNameNavigationBarBackground;
extern NSString * const kNameNavigationBarBackgroundDark;

extern NSString * const kNameNavigationBarButton;
extern NSString * const kNameNavigationBarBackButton;

extern NSString * const kNameCellBlueMark;
extern NSString * const kNameCellDarkGrayMark;
extern NSString * const kNameCellGreenMark;
extern NSString * const kNameCellLightGrayMark;
extern NSString * const kNameCellRedMark;
extern NSString * const kNameCellWhiteMark;

extern NSString * const kNameCellDevider;
extern NSString * const kNameCellDisclosure;
extern NSString * const kNameCellCheckBox;
extern NSString * const kNameCellCheckBoxSelected;
extern NSString * const kNameCellCheck;

extern NSString * const kNameMainTintColor;
extern NSString * const kNameBlueTintColor;

extern NSString * const kNameToolBarBackground;

extern NSString * const kNameSegmentBackground;
extern NSString * const kNameSegmentedDivider;

extern NSString * const kNameSearchBarBackground;
extern NSString * const kNameSearchFieldBackground;

extern NSString * const kNameButtonToggleBackground;
extern NSString * const kNameButtonInfoBackground;
extern NSString * const kNameButtonAddBackground;

extern NSString * const kNameTabBarBackground;
extern NSString * const kNameTabBarBackgroundSelectedAccount;
extern NSString * const kNameTabBarBackgroundSelectedAccountS;
extern NSString * const kNameTabBarBackgroundSelectedNotify;
extern NSString * const kNameTabBarBackgroundSelectedNotifyS;
extern NSString * const kNameTabBarBackgroundSelectedPayments;
extern NSString * const kNameTabBarBackgroundSelectedMore;
extern NSString * const kNameTabBarBackgroundSelectedMoreS;

extern NSString * const kCash;
extern NSString * const kmyPOS;
extern NSString * const kCards;
extern NSString * const kMore;

extern NSString * const kNameSwitchMainTintColor;
extern NSString * const kNameSwitchOnTintColor;

extern NSString * const kNamePageIndicatorTintColor;
extern NSString * const kNameCurrentPageIndicatorTintColor;

extern NSString * const kNameTabButtonBackgroundColor;

extern const CGFloat kNameTextFieldFontSize;
extern const CGFloat kNameButtonFontSize;
extern const CGFloat kNameLabelMinimumFontSize;
extern const CGFloat kNameLabelDefaultFontSize;
