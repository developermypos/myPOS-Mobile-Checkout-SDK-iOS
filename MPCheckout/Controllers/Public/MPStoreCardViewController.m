//
//  MPStoreCardViewController.m
//  MPCheckout
//
//  Created by Valio Cholakov on 1/31/17.
//  Copyright © 2017 Intercard Finance AD. All rights reserved.
//

#import "MPStoreCardViewController.h"
#import "ICStoreCardViewController.h"

#import "ICUtil.h"
#import "ICLogger.h"
#import "ICMobilePaymentManager.h"

#import "UIViewController+Helperes.h"

@interface MPStoreCardViewController () {
    BOOL _withoutCustomName;
    BOOL _autoReverse;
    CGFloat _verificationAmount;
}

@property(nonatomic, weak) id<MPStoreCardDelegate> storeCardDelegate;

@end

@implementation MPStoreCardViewController

#pragma mark - Initializers

- (instancetype)initWithVerificationAmount:(CGFloat)verificationAmount delegate:(id<MPStoreCardDelegate>)delegate {
    return [self initWithVerificationAmount:verificationAmount autoReverse:NO delegate:delegate withoutCustomName:NO];
}

- (instancetype)initWithVerificationAmount:(CGFloat)verificationAmount autoReverse:(BOOL)autoReverse delegate:(id<MPStoreCardDelegate>)delegate {
    return [self initWithVerificationAmount:verificationAmount autoReverse:autoReverse delegate:delegate withoutCustomName:NO];
}

- (instancetype)initWithVerificationAmount:(CGFloat)verificationAmount autoReverse:(BOOL)autoReverse delegate:(id<MPStoreCardDelegate>)delegate withoutCustomName:(BOOL)withoutCustomName {
    if (self = [super initWithNibName:nil bundle:nil]) {
        _storeCardDelegate  = delegate;
        _withoutCustomName  = withoutCustomName;
        _autoReverse        = autoReverse;
        _verificationAmount = verificationAmount;
        
        [self customInit];
    }
    
    return self;
}

#pragma mark - Deinitializer

- (void)dealloc {
    _storeCardDelegate = nil;
}

#pragma mark - Controller Methods

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    if ([[ICMobilePaymentManager sharedManager] isInitialized]) {
        return;
    }
    
    [ICLogger log:@"SDK not initialized"];
    
    if ([self.storeCardDelegate respondsToSelector:@selector(storeCardDidFailWithError:)]) {
        [self.storeCardDelegate storeCardDidFailWithError:[MPCheckoutError notInitializedError]];
    }
    
    [self.presenter dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - Private Methods

- (void)customInit {
    ICStoreCardViewController *storeCardController = [ICUtil storeCardController];
    
    storeCardController.storeCardDelegate      = self.storeCardDelegate;
    storeCardController.withoutCustomName      = _withoutCustomName;
    storeCardController.autoReverse            = _autoReverse;
    storeCardController.cardVerificationAmount = _verificationAmount;
    
    [self setViewControllers:@[storeCardController]];
}

@end
