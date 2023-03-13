//
//  ICPaymentViewController.m
//  MPCheckout
//
//  Created by Valio Cholakov on 1/31/17.
//  Copyright © 2017 Intercard Finance AD. All rights reserved.
//

#import "ICPaymentViewController.h"

#import "NSString+Helpers.h"

@interface ICPaymentViewController ()

@end

@implementation ICPaymentViewController

#pragma mark - Controller Methods

- (void)viewDidLoad {
    [super viewDidLoad];
    
    if (!self.cardToken) {
        return;
    }
    
    self.contentView.hidden                = YES;
    self.navigationItem.rightBarButtonItem = nil;
    
    [self showLoadingHUD];
    [[ICCommunicationManager sharedManager] makePurchaseForItems:self.cartItems
                                                         orderId:self.orderId
                                                       cardToken:self.cardToken
                                                      completion:[self paymentCompleted]
                                                         failure:[self paymentFailed]];
}

- (void)localize {
    [super localize];
    
    self.navigationItem.title = ICLocalizedString(@"Payment");
    self.confirmButton.title  = ICLocalizedString(@"Pay");
}

- (void)dealloc {
    _orderId   = nil;
    _cartItems = nil;
    _cardToken = nil;
}

#pragma mark - 3D Secure Delegate

- (void)didReceive3DSecureResponse:(NSDictionary *)response {
    [super didReceive3DSecureResponse:response];
    
    MPCard *card = [self card];
    
    if (!card || !_extraData) {
        [self dismiss:^{
            if ([self.storeCardDelegate respondsToSelector:@selector(storeCardDidFailWithError:)]) {
                [self.storeCardDelegate storeCardDidFailWithError:[MPCheckoutError communicationError]];
            }
        }];
        return;
    }
    
    NSString *dsTransactionId  = [response objectForKey:IC3DSParameterDsTransactionId];
    NSInteger programProtocol  = [[response objectForKey:IC3DSParameterProgramProtocol] integerValue];
    
    [self showLoadingHUD];
    [[ICCommunicationManager sharedManager] makePurchaseForItems:self.cartItems
                                                         orderId:self.orderId
                                                            card:card
                                                        cardData:_extraData
                                                 dsTransactionId:dsTransactionId
                                                 programProtocol:programProtocol
                                                    requestToken:self.requestToken
                                                      completion:[self paymentCompleted]
                                                         failure:[self paymentFailed]];
}

#pragma mark - Helpers

- (void (^)(NSString *, NSString *))paymentCompleted {
    return ^(NSString *transactionRef, NSString *cardToken) {
        NSString *trnReference = [transactionRef isKindOfClass:[NSNumber class]] ? [(id)transactionRef stringValue] : transactionRef;
        [self dismiss:^{
            if ([self.paymentDelegate respondsToSelector:@selector(paymentDidCompleteWithReference:card:)]) {
                [self.paymentDelegate paymentDidCompleteWithReference:trnReference card:[self storedCardWithToken:cardToken]];
            }
        }];
    };
}

- (void (^)(MPCheckoutError *))paymentFailed {
    return ^(MPCheckoutError *error) {
        [self dismiss:^{
            if ([self.paymentDelegate respondsToSelector:@selector(paymentDidFailWithError:)]) {
                [self.paymentDelegate paymentDidFailWithError:error];
            }
        }];
    };
}

- (MPStoredCard *)storedCardWithToken:(NSString *)token {
    NSString *cardType = [_extraData objectForKey:ICParameterCardType] ? : @"";
    return [[MPStoredCard alloc] initWithCard:[self card] type:[cardType plainCardType] token:token];
}

@end
