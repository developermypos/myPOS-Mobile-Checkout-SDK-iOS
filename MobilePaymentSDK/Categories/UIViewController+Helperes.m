//
//  UIViewController+Helperes.m
//  MobilePaymentSDK
//
//  Created by Valio Cholakov on 5/9/18.
//  Copyright © 2018 Intercard Finance AD. All rights reserved.
//

#import "UIViewController+Helperes.h"

@implementation UIViewController (Helperes)

- (UIViewController *)presenter {
    return self.navigationController ? : self;
}

@end
