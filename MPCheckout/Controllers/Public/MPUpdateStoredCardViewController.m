//
//  MPUpdateStoredCardViewController.m
//  MPCheckout
//
//  Created by Valio Cholakov on 1/31/17.
//  Copyright © 2017 Intercard Finance AD. All rights reserved.
//

#import "MPUpdateStoredCardViewController.h"
#import "ICUpdateStoredCardViewController.h"

#import "ICUtil.h"
#import "ICLogger.h"
#import "ICMobilePaymentManager.h"

#import "UIViewController+Helperes.h"

@interface MPUpdateStoredCardViewController () {
    BOOL _withoutCustomName;
    CGFloat _verificationAmount;
    NSString *_cardToken;
}

@property(nonatomic, weak) id<MPStoreCardDelegate> storeCardDelegate;

@end

@implementation MPUpdateStoredCardViewController

#pragma mark - Initializers

- (instancetype)initWithCardToken:(NSString *)cardToken
               verificationAmount:(CGFloat)verificationAmount
                         delegate:(id<MPStoreCardDelegate>)delegate {
    
    return [self initWithCardToken:cardToken verificationAmount:verificationAmount delegate:delegate withoutCustomName:NO];
}

- (instancetype)initWithCardToken:(NSString *)cardToken
               verificationAmount:(CGFloat)verificationAmount
                         delegate:(id<MPStoreCardDelegate>)delegate
                withoutCustomName:(BOOL)withoutCustomName {
    
    if (self = [super initWithNibName:nil bundle:nil]) {
        
        _cardToken          = cardToken;
        _storeCardDelegate  = delegate;
        _verificationAmount = verificationAmount;
        _withoutCustomName  = withoutCustomName;
        
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
        [self.storeCardDelegate storeCardDidFailWithError:[MPCheckoutError notInitializedError]];
    }
    
    [self.presenter dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - Private Methods

- (void)customInit {
    ICUpdateStoredCardViewController *storeCardController = [ICUtil updateCardController];
    
    storeCardController.cardToken              = _cardToken;
    storeCardController.storeCardDelegate      = self.storeCardDelegate;
    storeCardController.withoutCustomName      = _withoutCustomName;
    storeCardController.cardVerificationAmount = _verificationAmount;
    storeCardController.backgroundColor        = self.backgroundColor;
    
    [self setViewControllers:@[storeCardController]];
}

@end
