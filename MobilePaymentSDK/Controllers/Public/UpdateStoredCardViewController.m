//
//  UpdateStoredCardViewController.m
//  MobilePaymentSDK
//
//  Created by Valio Cholakov on 1/31/17.
//  Copyright © 2017 Intercard Finance AD. All rights reserved.
//

#import "UpdateStoredCardViewController.h"
#import "ICUpdateStoredCardViewController.h"

#import "ICUtil.h"
#import "ICLogger.h"
#import "ICMobilePaymentManager.h"

@interface UpdateStoredCardViewController () {
    CGFloat _verificationAmount;
    NSString *_cardToken;
}

@property(nonatomic, weak) id<StoreCardDelegate> storeCardDelegate;

@end

@implementation UpdateStoredCardViewController

#pragma mark - Initializers

- (instancetype)initWithCardToken:(NSString *)cardToken verificationAmount:(CGFloat)verificationAmount delegate:(id<StoreCardDelegate>)delegate {
    if (self = [super initWithNibName:nil bundle:nil]) {
        
        _cardToken          = cardToken;
        _storeCardDelegate  = delegate;
        _verificationAmount = verificationAmount;
        
        [self customInit];
    }
    
    return self;
}

#pragma mark - Deinitializer

- (void)dealloc {
    _cardToken         = nil;
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
    
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - Private Methods

- (void)customInit {
    ICUpdateStoredCardViewController *storeCardController = [ICUtil updateCardController];
    
    storeCardController.cardToken              = _cardToken;
    storeCardController.storeCardDelegate      = self.storeCardDelegate;
    storeCardController.cardVerificationAmount = _verificationAmount;
    
    [self setViewControllers:@[storeCardController]];
}

@end
