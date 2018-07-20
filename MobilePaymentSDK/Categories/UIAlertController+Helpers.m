//
//  UIAlertController+Helpers.m
//  MPCheckout
//
//  Created by Valio Cholakov on 5/2/17.
//  Copyright © 2017 Intercard Finance AD. All rights reserved.
//

#import "UIAlertController+Helpers.h"

#import "ICHelpers.h"
#import "ICConstants.h"
#import "ICMobilePaymentManager.h"

#import "UIViewController+Helperes.h"

@implementation UIAlertController (Helpers)

#pragma mark - Public Methods

+ (void)showAlert:(NSString *)message withTitle:(NSString *)title inController:(UIViewController *)sender {
    UIAlertAction *okAction = [UIAlertAction actionWithTitle:ICLocalizedString(@"Ok") style:UIAlertActionStyleCancel handler:nil];
    
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:title message:message preferredStyle:UIAlertControllerStyleAlert];
    [alertController addAction:okAction];
    
    dispatch_async(dispatch_get_main_queue(), ^{
        [[sender presenter] presentViewController:alertController animated:YES completion:nil];
    });
}

@end
