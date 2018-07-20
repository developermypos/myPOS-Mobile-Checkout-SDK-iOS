//
//  ICBaseViewController.h
//  MPCheckout
//
//  Created by Valio Cholakov on 1/31/17.
//  Copyright © 2017 Intercard Finance AD. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MPCheckoutProtocols.h"

@interface ICBaseViewController : UIViewController

@property (weak, nonatomic) IBOutlet UIView *mainView;
@property (nonatomic, nullable) UIColor *backgroundColor;

- (void)localize;
- (void)applyTheme;
- (void)showLoadingHUD;
- (void)hideLoadingHUD;

@end
