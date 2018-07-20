//
//  MPCheckoutController.m
//  MPCheckout
//
//  Created by Valio Cholakov on 7/20/18.
//  Copyright © 2018 Intercard Finance AD. All rights reserved.
//

#import "MPCheckoutController.h"

@interface MPCheckoutController ()

@end

@implementation MPCheckoutController

#pragma mark - Public Methods

- (void)setBackgroundColor:(UIColor *)backgroundColor {
    UIViewController *controller = [self.viewControllers firstObject];
    
    if (!controller || ![controller respondsToSelector:@selector(setBackgroundColor:)]) {
        return;
    }
    
    [controller performSelector:@selector(setBackgroundColor:) withObject:backgroundColor];
}

- (void)setNavigationTitleView:(UIView *)navigationTitleView {
    [[[self viewController] navigationItem] setTitleView:navigationTitleView];
}

#pragma mark - Helpers

- (UIViewController *)viewController {
    return [[self viewControllers] firstObject];
}

@end
