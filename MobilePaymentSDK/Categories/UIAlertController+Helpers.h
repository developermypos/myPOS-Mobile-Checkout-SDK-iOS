//
//  UIAlertController+Helpers.h
//  MPCheckout
//
//  Created by Valio Cholakov on 5/2/17.
//  Copyright © 2017 Intercard Finance AD. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIAlertController (Helpers)

+ (void)showAlert:(NSString *)message withTitle:(NSString *)title inController:(UIViewController *)sender;

@end
