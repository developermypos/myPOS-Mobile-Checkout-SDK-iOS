//
//  StoreCardViewController.m
//  MobilePaymentSDK
//
//  Created by Valio Cholakov on 1/31/17.
//  Copyright © 2017 Intercard Finance AD. All rights reserved.
//

#import "StoreCardViewController.h"
#import "ICStoreCardViewController.h"

#import "ICUtil.h"
#import "ICLogger.h"
#import "ICMobilePaymentManager.h"

#import "UIViewController+Helperes.h"

@interface StoreCardViewController () {
    BOOL _withoutCustomName;
    CGFloat _verificationAmount;
}

@property(nonatomic, weak) id<StoreCardDelegate> storeCardDelegate;

@end

@implementation StoreCardViewController

#pragma mark - Initializers

- (instancetype)initWithVerificationAmount:(CGFloat)verificationAmount delegate:(id<StoreCardDelegate>)delegate {
    return [self initWithVerificationAmount:verificationAmount delegate:delegate withoutCustomName:NO];
}

- (instancetype)initWithVerificationAmount:(CGFloat)verificationAmount delegate:(id<StoreCardDelegate>)delegate withoutCustomName:(BOOL)withoutCustomName {
    if (self = [super initWithNibName:nil bundle:nil]) {
        _storeCardDelegate  = delegate;
        _withoutCustomName  = withoutCustomName;
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
        [self.storeCardDelegate storeCardDidFailWithError:[MobilePaymentSDKError notInitializedError]];
    }
    
    [self.presenter dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - Private Methods

- (void)customInit {
    ICStoreCardViewController *storeCardController = [ICUtil storeCardController];
    
    storeCardController.storeCardDelegate      = self.storeCardDelegate;
    storeCardController.withoutCustomName      = _withoutCustomName;
    storeCardController.cardVerificationAmount = _verificationAmount;
    
    [self setViewControllers:@[storeCardController]];
}

@end
