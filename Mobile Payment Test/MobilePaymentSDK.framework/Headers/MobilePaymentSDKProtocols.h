//
//  MobilePaymentSDKProtocols.h
//  MobilePaymentSDK
//
//  Created by Valio Cholakov on 1/30/17.
//  Copyright © 2017 Intercard Finance AD. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MobilePaymentSDKError.h"

@protocol PaymentDelegate <NSObject>

- (void)paymentDidCompleteWithReference:(nonnull NSString *)transactionReference;
- (void)paymentDidFailWithError:(nonnull MobilePaymentSDKError *)error;

@end

@protocol StoreCardDelegate <NSObject>

- (void)storeCardDidCompleteWithToken:(nonnull NSString *)cardToken forCardWithName:(nonnull NSString *)cardName;
- (void)storeCardDidFailWithError:(nonnull MobilePaymentSDKError *)error;

- (void)updateStoredCardDidCompleteWithToken:(nonnull NSString *)cardToken forCardWithName:(nonnull NSString *)cardName;
- (void)updateStoredCardDidFailWithError:(nonnull MobilePaymentSDKError *)error;

@end
