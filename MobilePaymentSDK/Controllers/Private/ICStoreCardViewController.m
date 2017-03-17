//
//  ICStoreCardViewController.m
//  MobilePaymentSDK
//
//  Created by Valio Cholakov on 1/31/17.
//  Copyright © 2017 Intercard Finance AD. All rights reserved.
//

#import "ICStoreCardViewController.h"

@implementation ICStoreCardViewController

#pragma mark - Controller Methods

- (void)localize {
    [super localize];
    
    self.navigationItem.title = ICLocalizedString(@"Store card");
    self.confirmButton.title  = ICLocalizedString(@"Save");
}

#pragma mark - 3D Secure Delegate

- (void)didReceive3DSecureResponse:(NSDictionary *)response {
    [super didReceive3DSecureResponse:response];
    
    Card *card = [self card];
    
    if (!card || !_extraData) {
        return;
    }
    
    [self showLoadingHUD];
    [[ICCommunicationManager sharedManager] storeCard:card.pan
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
            if ([self.storeCardDelegate respondsToSelector:@selector(storeCardDidCompleteWithToken:forCardWithName:)]) {
                [self.storeCardDelegate storeCardDidCompleteWithToken:cardToken forCardWithName:_cardView.customName];
            }
        }];
    };
}

- (void (^)(MobilePaymentSDKError *))storeCardFailed {
    return ^(MobilePaymentSDKError *error) {
        [self dismiss:^{
            if ([self.storeCardDelegate respondsToSelector:@selector(storeCardDidFailWithError:)]) {
                [self.storeCardDelegate storeCardDidFailWithError:error];
            }
        }];
    };
}

@end
