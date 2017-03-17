//
//  ICBaseViewController.h
//  MobilePaymentSDK
//
//  Created by Valio Cholakov on 1/31/17.
//  Copyright © 2017 Intercard Finance AD. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MobilePaymentSDKProtocols.h"

@interface ICBaseViewController : UIViewController

- (void)localize;
- (void)applyTheme;
- (void)showLoadingHUD;
- (void)hideLoadingHUD;

@end
