//
//  ICUpdateStoredCardViewController.m
//  MobilePaymentSDK
//
//  Created by Valio Cholakov on 1/31/17.
//  Copyright © 2017 Intercard Finance AD. All rights reserved.
//

#import "ICUpdateStoredCardViewController.h"

@implementation ICUpdateStoredCardViewController

#pragma mark - Controller Methods

- (void)localize {
    [super localize];
    
    self.navigationItem.title = ICLocalizedString(@"Update stored card");
    self.confirmButton.title  = ICLocalizedString(@"Save");
}

- (void)dealloc {
    _cardToken = nil;
}

#pragma mark - 3D Secure Delegate

- (void)didReceive3DSecureResponse:(NSDictionary *)response {
    [super didReceive3DSecureResponse:response];
    
    Card *card = [self card];
    
    if (!card || !_extraData) {
        return;
    }
    
    [self showLoadingHUD];
    [[ICCommunicationManager sharedManager] updateStoredCard:self.cardToken
                                                         pan:card.pan
                                                  expiryDate:card.expiryDate
                                                         cvc:card.cvc
                                                  embossName:card.embossName
                                                  customName:card.customName
                                                      amount:ICFormatterAmount(self.cardVerificationAmount)
                                                   extraData:_extraData
                                                  completion:[self storeCardCompleted]
                                                     failure:[self storeCardFailed]];
}

#pragma mark - Helpers

- (void (^)(NSString *))storeCardCompleted {
    return ^(NSString *cardToken) {
        [self dismiss:^{
            if ([self.storeCardDelegate respondsToSelector:@selector(updateStoredCardDidCompleteWithToken:forCardWithName:)]) {
                [self.storeCardDelegate updateStoredCardDidCompleteWithToken:cardToken forCardWithName:_cardView.customName];
            }
        }];
    };
}

- (void (^)(MobilePaymentSDKError *))storeCardFailed {
    return ^(MobilePaymentSDKError *error) {
        [self dismiss:^{
            if ([self.storeCardDelegate respondsToSelector:@selector(updateStoredCardDidFailWithError:)]) {
                [self.storeCardDelegate updateStoredCardDidFailWithError:error];
            }
        }];
    };
}

@end
