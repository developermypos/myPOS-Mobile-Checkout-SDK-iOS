//
//  MPPaymentViewController.m
//  MPCheckout
//
//  Created by Valio Cholakov on 1/31/17.
//  Copyright © 2017 Intercard Finance AD. All rights reserved.
//

#import "MPPaymentViewController.h"
#import "ICPaymentViewController.h"

#import "ICMobilePaymentManager.h"
#import "ICLogger.h"
#import "ICUtil.h"

#import "UIViewController+Helperes.h"

@interface MPPaymentViewController () {
    NSString *_orderId;
    NSString *_cardToken;
    NSArray<MPCartItem *> *_cartItems;
    BOOL _forceTDS;
    BOOL _requestToken;
}

@property (weak, nonatomic) id<MPPaymentDelegate> paymentDelegate;

@end

@implementation MPPaymentViewController

#pragma mark - Initializers/Deinitializer

- (instancetype)initWithCartItems:(NSArray *)cartItems orderId:(NSString *)orderId requestToken:(BOOL)requestToken delegate:(id<MPPaymentDelegate>)delegate {
    if (self = [super initWithNibName:nil bundle:nil]) {
        _orderId         = orderId;
        _cartItems       = cartItems;
        _paymentDelegate = delegate;
        _requestToken     = requestToken;
        
        [self customInit];
    }
    
    return self;
}

- (instancetype)initWithCartItems:(NSArray<MPCartItem *> *)cartItems orderId:(NSString *)orderId cardToken:(NSString *)cardToken forceTDS:(BOOL)forceTDS delegate:(id<MPPaymentDelegate>)delegate {
    if (self = [super initWithNibName:nil bundle:nil]) {
        _orderId         = orderId;
        _cartItems       = cartItems;
        _paymentDelegate = delegate;
        _cardToken       = cardToken;
        _forceTDS        = forceTDS;
        
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
        [self.paymentDelegate paymentDidFailWithError:[MPCheckoutError notInitializedError]];
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
    paymentController.forceTDS               = _forceTDS;
    paymentController.requestToken           = _requestToken;
    paymentController.cardVerificationAmount = [[ICUtil itemsTotalAmount:_cartItems] floatValue];
    paymentController.backgroundColor        = self.backgroundColor;
    
    [self setViewControllers:@[paymentController]];
}

@end
