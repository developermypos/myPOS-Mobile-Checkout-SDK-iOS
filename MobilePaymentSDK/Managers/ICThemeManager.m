//
//  ICThemeManager.m
//  myPOS
//
//  Created by Valio Cholakov on 12/30/15.
//  Copyright (c) 2015 InterCard Finance AD. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>

#import "ICThemeManager.h"

#import "MobilePaymentTheme.h"

#import "UIColor+Helpers.h"
#import "UIColor+HexString.h"

@implementation ICThemeManager

NSString *const kNameDefaultControllersBackground       = @"background";
NSString *const kNameLoginControllersBackground         = @"backgroundLogin";
NSString *const kNameTabControllersBackground           = @"backgroundTab";
NSString *const kNameTabControllersBackground6          = @"backgroundTab_iphone6";
NSString *const kTextFieldBackgroundGray                = @"textBackground";
NSString *const kNameTextFieldBackgroundBlue            = @"textBackground_blue";
NSString *const kNameTextFieldBackgroundRed             = @"textBackground_red";
NSString *const kNameTextFieldBackgroundWhite           = @"textBackground_white";

NSString *const kNameApplicationDefaultFont             = @"HelveticaNeue";
NSString *const kNameApplicationBoldFont                = @"HelveticaNeue-Bold";
NSString *const kNameApplicationItalicFont              = @"HelveticaNeue-Italic";
NSString *const kNameApplicationMediumFont              = @"HelveticaNeue-Medium";
NSString *const kNameApplicationMediumItalicFont        = @"HelveticaNeue-MediumItalic";
NSString *const kNameApplicationLightFont               = @"HelveticaNeue-Light";
NSString *const kNameApplicationLightItalicFont         = @"HelveticaNeue-LightItalic";
NSString *const kNameApplicationThinFont                = @"HelveticaNeue-Thin";
NSString *const kNameApplicationThinItalicFont          = @"HelveticaNeue-ThinItalic";
NSString *const kNameCheckFont                          = @"PatrickHand-Regular";

NSString *const kNameHighlightedExtensionString         = @"Highlighted";
NSString *const kNameSelectedExtensionString            = @"-selected";
NSString *const kNameDisabledExtensionString            = @"Disabled";

NSString *const kNameTextFieldFontColor                 = @"textFieldFontColor";
NSString *const kNameTextFieldPlaceholderColor          = @"textFieldPlaceholderColor";

NSString *const kNameGrayButtonTitleColor               = @"grayButtonTitleColor";
NSString *const kNameBlueButtonTitleColor               = @"blueButtonTitleColor";
NSString *const kNameYellowButtonTitleColor             = @"yellowButtonTitleColor";
NSString *const kNameHighlightedButtonTitleColor        = @"highlightedButtonTitleColor";
NSString *const kNameDisabledButtonTitleColor           = @"disabledButtonTitleColor";
NSString *const kNameSelectedButtonTitleColor           = @"selectedButtonTitleColor";
NSString *const kNamePureGrayColor                      = @"grayColor";

NSString *const kNameGrayLabelFontColor                 = @"grayLabelFontColor";
NSString *const kNameLightGrayLabelFontColor            = @"lightGrayLabelFontColor";
NSString *const kNameDarkGrayLabelFontColor             = @"darkGrayLabelFontColor";
NSString *const kNameWhiteLabelFontColor                = @"whiteLabelFontColor";
NSString *const kNameGreenLabelFontColor                = @"greenLabelFontColor";
NSString *const kNameRedLabelFontColor                  = @"redLabelFontColor";
NSString *const kNameBlueLabelFontColor                 = @"blueLabelFontColor";
NSString *const kNameDarkGrayIntroFontColor             = @"dakrGrayIntroFontColor";
NSString *const kNameLeuYellow                          = @"leuYellow";
NSString *const kNameDarkRedFontColor                   = @"darkRedFontColor";
NSString *const kNameDarkGreenFontColor                 = @"darkGreenFontColor";
NSString *const kNameLabelColorPlaceholderLight         = @"labelColorPlaceholderLight";
NSString *const kNameMyPosBlue                          = @"myPosBlue";

NSString *const kNameGrayTextFieldFontColor             = @"grayTextFieldFontColor";
NSString *const kNameWhiteTextFieldFontColor            = @"whiteTextFieldFontColor";
NSString *const kNameGreenTextFieldFontColor            = @"greenTextFieldFontColor";
NSString *const kNameRedTextFieldFontColor              = @"redTextFieldFontColor";
NSString *const kNameBlueTextFieldFontColor             = @"blueTextFieldFontColor";
NSString *const kNameLightGrayTextFieldFontColor        = @"lightGrayTextFieldFontColor";

NSString *const kNameNavigationBarBackground            = @"navigationBackground";
NSString *const kNameNavigationBarBackgroundDark        = @"navigationBackground_dark";

NSString *const kNameNavigationBarButton                = @"barButton";
NSString *const kNameNavigationBarBackButton            = @"backButton";

NSString *const kNameCellBlueMark                       = @"blueMark";
NSString *const kNameCellDarkGrayMark                   = @"darkGrayMark";
NSString *const kNameCellGreenMark                      = @"greenMark";
NSString *const kNameCellLightGrayMark                  = @"lightGrayMark";
NSString *const kNameCellRedMark                        = @"redMark";
NSString *const kNameCellWhiteMark                      = @"whiteMark";

NSString *const kNameCellDevider                        = @"cellDivider";
NSString *const kNameCellDisclosure                     = @"cellDisclosure";
NSString *const kNameCellCheckBox                       = @"toggleButtonBackground";
NSString *const kNameCellCheckBoxSelected               = @"toggleButtonBackgroundSelected";
NSString *const kNameCellCheck                          = @"check";

NSString *const kNameMainTintColor                      = @"mainTintColor";
NSString *const kNameBlueTintColor                      = @"blueTintColor";

NSString *const kNameToolBarBackground                  = @"toolbarBackground";

NSString *const kNameSegmentBackground                  = @"segmentedBackground";
NSString *const kNameSegmentedDivider                   = @"segmentedDivider";

NSString *const kNameSearchBarBackground                = @"searchBackground";
NSString *const kNameSearchFieldBackground              = @"searchField";

NSString *const kNameButtonToggleBackground             = @"toggleButtonBackground";
NSString *const kNameButtonInfoBackground               = @"infoButtonBackground";
NSString *const kNameButtonAddBackground                = @"addButtonBackground";

NSString *const kNameTabBarBackground                   = @"tabBarBackground";
NSString *const kNameTabBarBackgroundSelectedAccount    = @"tabBarBackgroundSelectedAccount";
NSString *const kNameTabBarBackgroundSelectedAccountS   = @"tabBarBackgroundSelectedAccountSmall";
NSString *const kNameTabBarBackgroundSelectedNotify     = @"tabBarBackgroundSelectedNotifications";
NSString *const kNameTabBarBackgroundSelectedNotifyS    = @"tabBarBackgroundSelectedNotificationsSmall";
NSString *const kNameTabBarBackgroundSelectedPayments   = @"tabBarBackgroundSelectedPayments";
NSString *const kNameTabBarBackgroundSelectedMore       = @"tabBarBackgroundSelectedMore";
NSString *const kNameTabBarBackgroundSelectedMoreS      = @"tabBarBackgroundSelectedMoreSmall";

NSString *const kNameSwitchMainTintColor                = @"switchMainTintColor";
NSString *const kNameSwitchOnTintColor                  = @"switchOnTintColor";

NSString *const kNamePageIndicatorTintColor             = @"pageIndicatorTintColor";
NSString *const kNameCurrentPageIndicatorTintColor      = @"currentPageIndicatorTintColor";

NSString *const kNameTabButtonBackgroundColor           = @"tabButtonBackgroundColor";

NSString *const kCash  = @"cash-icon";
NSString *const kmyPOS = @"mypos-icon";
NSString *const kCards = @"cards-icon";
NSString *const kMore  = @"more-icon";

const CGFloat kNameTextFieldFontSize        = 14.0f;
const CGFloat kNameButtonFontSize           = 14.0f;
const CGFloat kNameLabelMinimumFontSize     = 8.0f;
const CGFloat kNameLabelDefaultFontSize     = 14.0f;

#pragma mark - Public Methods

+ (MobilePaymentTheme <ICThemeManager> *)sharedTheme {
	static MobilePaymentTheme <ICThemeManager> *sharedTheme = nil;
	static dispatch_once_t onceToken;
	dispatch_once(&onceToken, ^{
		sharedTheme = [[MobilePaymentTheme alloc] init];
	});

	return sharedTheme;
}

+ (UIColor *)lightGrayColor {
	return [[self sharedTheme] labelTextColor:ICThemeLabelColorPlaceholderGray];
}

+ (UIColor *)customGrayColor {
	return [[self sharedTheme] labelTextColor:ICThemeLabelColorGray];
}

+ (void)customizeLabel:(UILabel *)label size:(CGFloat)size style:(ICThemeLabelStyle)style color:(ICThemeLabelColor)color {
	id <ICThemeManager> theme = [self sharedTheme];

	UIFont *font = nil;

	switch (style) {
		case ICThemeLabelStyleBold:
			font = [theme boldFontWithSize:size];
			break;

		case ICThemeLabelStyleItalic:
			font = [theme italicFontWithSize:size];
			break;
            
        case ICThemeLabelStyleMedium:
            font = [theme mediumFontWithSize:size];
            break;
            
        case ICThemeLabelStyleMediumItalic:
            font = [theme mediumItalicFontWithSize:size];
            break;
            
        case ICThemeLabelStyleLight:
            font = [theme lightFontWithSize:size];
            break;
            
        case ICThemeLabelStyleLightItalic:
            font = [theme lightItalicFontWithSize:size];
            break;
            
        case ICThemeLabelStyleThin:
            font = [theme thinFontWithSize:size];
            break;
            
        case ICThemeLabelStyleThinItalic:
            font = [theme thinItalicFontWithSize:size];
            break;
            
        case ICTHemeLabelStyleCheck:
            font = [theme checkFontWithSize:size];
            break;

		default:
			font = [theme fontWithSize:size];
			break;
	}

	[label setFont:font];
	[label setMinimumScaleFactor:0.5];
	[label setAdjustsFontSizeToFitWidth:YES];

	[label setBackgroundColor:[UIColor clearColor]];

	// nil means default label color
	UIColor *textColor = [theme labelTextColor:color];

	if (textColor != nil) {
		[label setTextColor:textColor];
	}

	[label setShadowColor:[UIColor clearColor]];
	[label setShadowOffset:CGSizeZero];
}

+ (void)customizeTextField:(UITextField *)textField size:(CGFloat)size style:(ICThemeTextFieldStyle)style type:(ICThemeTextField)type {
	id <ICThemeManager> theme = [self sharedTheme];

	UIFont *font = nil;

	switch (style) {
		case ICThemeTextFieldStyleBold:
			[theme boldFontWithSize:size];
			break;

		case ICThemeTextFieldStyleItalic:
			[theme italicFontWithSize:size];
			break;
            
        case ICThemeTextFieldStyleMedium:
            font = [theme mediumFontWithSize:size];
            break;
            
        case ICThemeTextFieldStyleLight:
            font = [theme lightFontWithSize:size];
            break;
            
        case ICThemeTextFieldStyleThin:
            font = [theme thinFontWithSize:size];
            break;
            
        case ICThemeTextFieldStyleThinItalic:
            font = [theme thinItalicFontWithSize:size];
            break;

		default:
			font = [theme fontWithSize:size];
			break;
	}

	[textField setFont:font];
	[textField setAdjustsFontSizeToFitWidth:YES];

	[textField setBackgroundColor:[UIColor clearColor]];

	// nil means default label color
	UIColor *textColor = [theme textFieldTextColor:type];

	if (textColor != nil) {
		[textField setTextColor:textColor];
	}
}

+ (void)customizeButton:(UIButton *)button size:(CGFloat)size type:(ICThemeButton)type
{
    UIImage *radioButtonImage           = nil;
    UIImage *radioButtonSelectedImage   = nil;
    
    id <ICThemeManager> theme = [self sharedTheme];
    
    if (type == ICThemeButtonInfo || type == ICThemeButtonToggle || type == ICThemeButtonAdd) {
        [button setTitle:@"" forState:UIControlStateNormal];
        
        [button setBackgroundImage:[theme backgroundForButton:type state:UIControlStateNormal]   forState:UIControlStateNormal];
        [button setBackgroundImage:[theme backgroundForButton:type state:UIControlStateSelected] forState:UIControlStateSelected];
        return;
    }
    
    if (type == ICThemeButtonRadio) {
        radioButtonImage            = [UIImage imageNamed:@"radioButton"];
        radioButtonSelectedImage    = [UIImage imageNamed:@"radioButtonSelected"];
        
        [button setImage:radioButtonImage forState:UIControlStateNormal];
        [button setImage:radioButtonSelectedImage forState:UIControlStateSelected];
        
        button.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
        button.titleEdgeInsets = UIEdgeInsetsMake(0, 10.0, 0, 0);
    }
    
    [button.titleLabel setAdjustsFontSizeToFitWidth:YES];
    [button.titleLabel setMinimumScaleFactor:0.5];
    
    NSString *normalTitle       = [button titleForState:UIControlStateNormal];
    NSString *selectedTitle     = [button titleForState:UIControlStateSelected];
    NSString *disabledTitle     = [button titleForState:UIControlStateDisabled];
    NSString *highlightedTitle  = [button titleForState:UIControlStateHighlighted];
    
    NSMutableAttributedString *normalAttributedString       = [[NSMutableAttributedString alloc] initWithString:normalTitle      ? normalTitle      : @""];
    NSMutableAttributedString *selectedAttributedString     = [[NSMutableAttributedString alloc] initWithString:selectedTitle    ? selectedTitle    : @""];
    NSMutableAttributedString *disabledAttributedString     = [[NSMutableAttributedString alloc] initWithString:disabledTitle    ? disabledTitle    : @""];
    NSMutableAttributedString *highlightedAttributedString  = [[NSMutableAttributedString alloc] initWithString:highlightedTitle ? highlightedTitle : @""];
    
    UIFont *titleLabelFont = [theme fontForButton:type withSize:size];
    
    if (titleLabelFont != nil) {
        [normalAttributedString         addAttribute:NSFontAttributeName value:titleLabelFont range:NSMakeRange(0, normalAttributedString.length)];
        [selectedAttributedString       addAttribute:NSFontAttributeName value:titleLabelFont range:NSMakeRange(0, selectedAttributedString.length)];
        [disabledAttributedString       addAttribute:NSFontAttributeName value:titleLabelFont range:NSMakeRange(0, disabledAttributedString.length)];
        [highlightedAttributedString    addAttribute:NSFontAttributeName value:titleLabelFont range:NSMakeRange(0, highlightedAttributedString.length)];
    }
    
    UIColor *normalTitleColor = [theme buttonTitleColor:type state:UIControlStateNormal];
    if (normalTitleColor)
        [normalAttributedString addAttribute:NSForegroundColorAttributeName value:normalTitleColor range:NSMakeRange(0, normalAttributedString.length)];
    
    UIColor *selectedTitleColor = [theme buttonTitleColor:ICThemeButtonDefault state:UIControlStateSelected];
    if (selectedTitleColor)
        [selectedAttributedString addAttribute:NSForegroundColorAttributeName value:selectedTitleColor range:NSMakeRange(0, normalAttributedString.length)];
    
    UIColor *disabledTitleColor = [theme buttonTitleColor:ICThemeButtonDefault state:UIControlStateDisabled];
    if (disabledTitleColor)
        [disabledAttributedString addAttribute:NSForegroundColorAttributeName value:disabledTitleColor range:NSMakeRange(0, normalAttributedString.length)];
    
    UIColor *highlightedTitleColor = [theme buttonTitleColor:type state:UIControlStateHighlighted];
    if (highlightedTitleColor)
        [highlightedAttributedString addAttribute:NSForegroundColorAttributeName value:highlightedTitleColor range:NSMakeRange(0, normalAttributedString.length)];
    
    NSNumber *underlineStyle = nil;
    if (type == ICThemeButtonLink) {
        underlineStyle = [NSNumber numberWithInt:NSUnderlineStyleSingle];
        
        [normalAttributedString         addAttribute:NSUnderlineStyleAttributeName  value:underlineStyle range:NSMakeRange(0, normalAttributedString.length)];
        [selectedAttributedString       addAttribute:NSFontAttributeName            value:underlineStyle range:NSMakeRange(0, selectedAttributedString.length)];
        [disabledAttributedString       addAttribute:NSFontAttributeName            value:underlineStyle range:NSMakeRange(0, disabledAttributedString.length)];
        [highlightedAttributedString    addAttribute:NSUnderlineStyleAttributeName  value:underlineStyle range:NSMakeRange(0, highlightedAttributedString.length)];
        
        button.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    }
    
    [button setAttributedTitle:normalAttributedString       forState:UIControlStateNormal];
    [button setAttributedTitle:selectedAttributedString     forState:UIControlStateSelected];
    [button setAttributedTitle:disabledAttributedString     forState:UIControlStateDisabled];
    [button setAttributedTitle:highlightedAttributedString  forState:UIControlStateHighlighted];
}

+ (void)customizeTabBarItem:(UITabBarItem *)item forTab:(ICThemeTab)tab {
	id <ICThemeManager> theme = [self sharedTheme];

	item.image           = [[theme imageForTab:tab selected:NO]  imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
	item.selectedImage   = [[theme imageForTab:tab selected:YES] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
}

+ (void)customizeAppAppearance {
    MobilePaymentTheme <ICThemeManager> *theme = [self sharedTheme];
    
	// Status bar
    [[UIApplication sharedApplication] setStatusBarHidden:NO withAnimation:NO];

	// Navigation bar
	UINavigationBar *navigationBarAppearance = [UINavigationBar appearance];
	[navigationBarAppearance setTintColor:theme.barButtonItemColor];
    [navigationBarAppearance setTitleTextAttributes:@{
                                                      NSFontAttributeName            : [theme mediumFontWithSize:16.0f],
                                                      NSForegroundColorAttributeName : theme.navigationTitleColor
                                                      }];
    
    // Tab bar
    [[UITabBar appearance] setBarTintColor:theme.barButtonItemColor];
    
	// Tab bar item
    [[UITabBarItem appearance] setTitleTextAttributes:@{ NSForegroundColorAttributeName : [UIColor whiteColor],
                                                         NSFontAttributeName            : [theme fontWithSize:12.0f] }
                                             forState:UIControlStateNormal];
    
    [[UITabBarItem appearance] setTitleTextAttributes:@{ NSForegroundColorAttributeName : [UIColor whiteColor],
                                                         NSFontAttributeName            : [theme mediumFontWithSize:12.0f] }
                                             forState:UIControlStateSelected];
    
    // Button Item when in Toolbar
    [[UIBarButtonItem appearanceWhenContainedIn:[UINavigationBar class], nil] setTitleTextAttributes:@{
                                                                                                       NSFontAttributeName               : [theme fontWithSize:16.0f],
                                                                                                       NSForegroundColorAttributeName    : theme.barButtonItemColor
                                                                                                       }
                                                                                            forState:UIControlStateNormal];
    
    [[UIBarButtonItem appearanceWhenContainedIn:[UINavigationBar class], nil] setTitleTextAttributes:@{
                                                                                                       NSFontAttributeName               : [theme fontWithSize:16.0f],
                                                                                                       NSForegroundColorAttributeName    : [UIColor grayColor]
                                                                                                       }
                                                                                            forState:UIControlStateDisabled];
//	UITabBarItem *tabBarItemAppearance = [UITabBarItem appearance];
//	[tabBarItemAppearance setTitleTextAttributes:@{ NSForegroundColorAttributeName : [UIColor grayColor] }           forState:UIControlStateNormal];
//    
//    // Button Item when in Toolbar
    [[UIBarButtonItem appearanceWhenContainedIn:[UIToolbar class], nil] setTintColor:theme.barButtonItemColor];
//
//	// Segments backround
	UISegmentedControl *segmentedAppearance = [UISegmentedControl appearance];
//	[segmentedAppearance setTitleTextAttributes:@{ NSForegroundColorAttributeName : [UIColor leuYellow] } forState:UIControlStateNormal];
//	[segmentedAppearance setTitleTextAttributes:@{ NSForegroundColorAttributeName : [UIColor whiteColor] } forState:UIControlStateSelected];
	[segmentedAppearance setTintColor:theme.barButtonItemColor];
    
    // Search bar cancel button
    [[UIBarButtonItem appearanceWhenContainedIn:[UISearchBar class], nil] setTintColor:theme.barButtonItemColor];
//    
    // Switch control
    UISwitch *switchAppearance = [UISwitch appearance];
    [switchAppearance setBackgroundColor:[UIColor clearColor]];
    [switchAppearance setOnTintColor:theme.barButtonItemColor];
}

+ (void)addTopBorderWithHeight:(CGFloat)borderHeight color:(UIColor *)color ToView:(UIView *)view {
	CALayer *topBorder = [CALayer layer];
	topBorder.frame = CGRectMake(0.0f, 0.0f, view.frame.size.width, borderHeight);
	topBorder.backgroundColor = color.CGColor;
	[view.layer addSublayer:topBorder];
}

@end
