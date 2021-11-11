//
//  ICStoreCardViewController.m
//  MPCheckout
//
//  Created by Valio Cholakov on 1/31/17.
//  Copyright © 2017 Intercard Finance AD. All rights reserved.
//

#import "ICStoreCardViewController.h"

#import "MPStoredCard.h"

#import "NSString+Helpers.h"

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
    [[ICCommunicationManager sharedManager] storeCard:card.pan
                                           expiryDate:card.expiryDate
                                                  cvc:card.cvc
                                           embossName:card.embossName
                                           customName:card.customName
                                               amount:ICFormatterAmount(self.cardVerificationAmount)
                                          autoReverse:self.autoReverse
                                            extraData:_extraData
                                           completion:[self storeCardCompleted]
                                              failure:[self storeCardFailed]];
}

#pragma mark - Helpers

- (void (^)(NSString *cardToken, NSString *transactionRef))storeCardCompleted {
    return ^(NSString *cardToken, NSString *transactionRef) {
        [self dismiss:^{
            if ([self.storeCardDelegate respondsToSelector:@selector(storeCardDidCompleteWithData:transactionRef:)]) {
                [self.storeCardDelegate storeCardDidCompleteWithData:[self storedCardWithToken:cardToken] transactionRef:transactionRef];
            }
        }];
    };
}

- (void (^)(MPCheckoutError *))storeCardFailed {
    return ^(MPCheckoutError *error) {
        [self dismiss:^{
            if ([self.storeCardDelegate respondsToSelector:@selector(storeCardDidFailWithError:)]) {
                [self.storeCardDelegate storeCardDidFailWithError:error];
            }
        }];
    };
}

- (MPStoredCard *)storedCardWithToken:(NSString *)token {
    NSString *cardType = [_extraData objectForKey:ICParameterCardType] ? : @"";
    return [[MPStoredCard alloc] initWithCard:[self card] type:[cardType plainCardType] token:token];
}

@end
