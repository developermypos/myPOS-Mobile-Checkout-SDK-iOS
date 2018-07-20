//
//  MPCheckoutController.h
//  MPCheckout
//
//  Created by Valio Cholakov on 7/20/18.
//  Copyright © 2018 Intercard Finance AD. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MPCheckoutController : UINavigationController

/*!
 * Sets the navigationItems's titleView property.
 */
@property (weak, nonatomic, nullable) UIView *navigationTitleView;

/*!
 * Sets the background color of the main view in the controller.
 */
@property (weak, nonatomic, nullable) UIColor *backgroundColor;

/*!
 * Sets the navigationBar's background color.
 */
@property (weak, nonatomic, nullable) UIColor *navigationBarBackgroundColor;

@end
