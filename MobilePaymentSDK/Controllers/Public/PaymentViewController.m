//
//  PaymentViewController.m
//  MobilePaymentSDK
//
//  Created by Valio Cholakov on 1/31/17.
//  Copyright © 2017 Intercard Finance AD. All rights reserved.
//

#import "PaymentViewController.h"
#import "ICPaymentViewController.h"

#import "ICMobilePaymentManager.h"
#import "ICLogger.h"
#import "ICUtil.h"

#import "UIViewController+Helperes.h"

@interface PaymentViewController () {
    NSString *_orderId;
    NSString *_cardToken;
    NSArray<CartItem *> *_cartItems;
}

@property (weak, nonatomic) id<PaymentDelegate> paymentDelegate;

@end

@implementation PaymentViewController

#pragma mark - Initializers/Deinitializer

- (instancetype)initWithCartItems:(NSArray *)cartItems orderId:(NSString *)orderId delegate:(id<PaymentDelegate>)delegate {
    if (self = [super initWithNibName:nil bundle:nil]) {
        _orderId         = orderId;
        _cartItems       = cartItems;
        _paymentDelegate = delegate;
        
        [self customInit];
    }
    
    return self;
}

- (instancetype)initWithCartItems:(NSArray<CartItem *> *)cartItems orderId:(NSString *)orderId cardToken:(NSString *)cardToken delegate:(id<PaymentDelegate>)delegate {
    if (self = [super initWithNibName:nil bundle:nil]) {
        _orderId         = orderId;
        _cartItems       = cartItems;
        _paymentDelegate = delegate;
        _cardToken       = cardToken;
        
        [self customInit];
    }
    
    return self;
}

- (void)dealloc {
    _orderId         = nil;
    _cardToken       = nil;
    _cartItems       = nil;
    _paymentDelegate = nil;
}

#pragma mark - Controller Methods

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    if ([[ICMobilePaymentManager sharedManager] isInitialized]) {
        return;
    }
    
    [ICLogger log:@"SDK not initialized"];
    
    if ([self.paymentDelegate respondsToSelector:@selector(paymentDidFailWithError:)]) {
        [self.paymentDelegate paymentDidFailWithError:[MobilePaymentSDKError notInitializedError]];
    }
    
    [self.presenter dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - Private Methods

- (void)customInit {
    ICPaymentViewController *paymentController = [ICUtil paymentController];
    
    paymentController.orderId                = _orderId;
    paymentController.cartItems              = _cartItems;
    paymentController.cardToken              = _cardToken;
    paymentController.paymentDelegate        = self.paymentDelegate;
    paymentController.withoutCustomName      = YES;
    paymentController.cardVerificationAmount = [[ICUtil itemsTotalAmount:_cartItems] floatValue];
    
    [self setViewControllers:@[paymentController]];
}

@end
