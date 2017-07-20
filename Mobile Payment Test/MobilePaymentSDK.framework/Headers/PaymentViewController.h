//
//  PaymentViewController.h
//  MobilePaymentSDK
//
//  Created by Valio Cholakov on 1/31/17.
//  Copyright © 2017 Intercard Finance AD. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "CartItem.h"
#import "MobilePaymentSDKProtocols.h"

@interface PaymentViewController : UINavigationController

- (nonnull instancetype)initWithCartItems:(nonnull NSArray<CartItem *> *)cartItems orderId:(nonnull NSString *)orderId delegate:(nullable id<PaymentDelegate>)delegate;
- (nonnull instancetype)initWithCartItems:(nonnull NSArray<CartItem *> *)cartItems orderId:(nonnull NSString *)orderId cardToken:(nonnull NSString *)cardToken delegate:(nullable id<PaymentDelegate>)delegate;

@end
