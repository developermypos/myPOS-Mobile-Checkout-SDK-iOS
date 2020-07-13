//
//  MPPreAuthorizationViewController.m
//  MPCheckout
//
//  Created by Valio Cholakov on 9.07.20.
//  Copyright © 2020 Intercard Finance AD. All rights reserved.
//

#import "MPPreAuthorizationViewController.h"
#import "ICPreAuthorizationViewController.h"

#import "ICMobilePaymentManager.h"
#import "ICLogger.h"
#import "ICUtil.h"

#import "UIViewController+Helperes.h"

@interface MPPreAuthorizationViewController () {
    CGFloat _amount;
    NSString *_orderId;
    NSString *_itemName;
}

@property (weak, nonatomic) id<MPPaymentDelegate> paymentDelegate;

@end

@implementation MPPreAuthorizationViewController

#pragma mark - Initializers/Deinitializer

- (instancetype)initWithItemName:(NSString *)itemName amount:(CGFloat)amount orderId:(NSString *)orderId delegate:(id<MPPaymentDelegate>)delegate {
    if (self = [super initWithNibName:nil bundle:nil]) {
        _amount          = amount;
        _orderId         = orderId;
        _itemName        = itemName;
        _paymentDelegate = delegate;
        
        [self customInit];
    }
    
    return self;
}

- (void)dealloc {
    _orderId         = nil;
    _itemName        = nil;
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
    ICPreAuthorizationViewController *preAuthorizationController = [ICUtil preAuthorizationController];
    
    preAuthorizationController.amount          = _amount;
    preAuthorizationController.orderId         = _orderId;
    preAuthorizationController.itemName        = _itemName;
    preAuthorizationController.paymentDelegate = self.paymentDelegate;
    preAuthorizationController.backgroundColor = self.backgroundColor;
    
    [self setViewControllers:@[preAuthorizationController]];
}

@end
