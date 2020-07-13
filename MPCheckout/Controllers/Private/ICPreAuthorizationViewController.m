//
//  ICPreAuthorizationViewController.m
//  MPCheckout
//
//  Created by Valio Cholakov on 8.07.20.
//  Copyright © 2020 Intercard Finance AD. All rights reserved.
//

#import "ICPreAuthorizationViewController.h"

@interface ICPreAuthorizationViewController ()

@end

@implementation ICPreAuthorizationViewController

#pragma mark - Controller Methods

- (void)localize {
    [super localize];
    
    self.navigationItem.title = ICLocalizedString(@"Pre-authorization");
    self.confirmButton.title  = ICLocalizedString(@"Make");
}

- (void)dealloc {
    _orderId  = nil;
    _itemName = nil;
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
    
    [self showLoadingHUD];
    [[ICCommunicationManager sharedManager] makePreAuthorizationFor:self.amount
                                                           itemName:self.itemName
                                                            orderId:self.orderId
                                                               card:self.card
                                                           cardData:_extraData
                                                         completion:[self preAuthorizationCompleted]
                                                            failure:[self preAuthorizationFailed]];
}

#pragma mark - Helpers

- (void (^)(NSString *))preAuthorizationCompleted {
    return ^(NSString *transactionRef) {
        NSString *trnReference = [transactionRef isKindOfClass:[NSNumber class]] ? [(id)transactionRef stringValue] : transactionRef;
        [self dismiss:^{
            if ([self.paymentDelegate respondsToSelector:@selector(paymentDidCompleteWithReference:)]) {
                [self.paymentDelegate paymentDidCompleteWithReference:trnReference];
            }
        }];
    };
}

- (void (^)(MPCheckoutError *))preAuthorizationFailed {
    return ^(MPCheckoutError *error) {
        [self dismiss:^{
            if ([self.paymentDelegate respondsToSelector:@selector(paymentDidFailWithError:)]) {
                [self.paymentDelegate paymentDidFailWithError:error];
            }
        }];
    };
}

@end
