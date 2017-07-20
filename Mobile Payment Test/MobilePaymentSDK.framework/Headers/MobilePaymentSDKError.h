//
//  MobilePaymentSDKError.h
//  MobilePaymentSDK
//
//  Created by Valio Cholakov on 1/31/17.
//  Copyright © 2017 Intercard Finance AD. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>

@interface MobilePaymentSDKError : NSError

+ (instancetype)errorWithStatus:(NSInteger)status;
+ (instancetype)notInitializedError;
+ (instancetype)communicationError;
+ (instancetype)undefinedError;

@end

extern NSInteger const MobilePaymentSDKConnectivityChangedError;
extern NSInteger const MobilePaymentSDKNotInitializedError;
extern NSInteger const MobilePaymentSDKSignatureValidationError;
extern NSInteger const MobilePaymentSDKCommunicationError;
extern NSInteger const MobilePaymentSDKInvalidInputParametersError;
extern NSInteger const MobilePaymentSDKAPIError;
extern NSInteger const MobilePaymentSDKTimeoutError;
extern NSInteger const MobilePaymentSDKNoError;
extern NSInteger const MobilePaymentSDKInvalidStoreIdError;
extern NSInteger const MobilePaymentSDKInvalidParametersError;
extern NSInteger const MobilePaymentSDKInvalidAmountError;
extern NSInteger const MobilePaymentSDKInsufficientFundsError;
extern NSInteger const MobilePaymentSDKTransactionNotPermittedError;
extern NSInteger const MobilePaymentSDKLimitExceededError;
extern NSInteger const MobilePaymentSDKInactiveAccountError;
extern NSInteger const MobilePaymentSDKInvalidAccountError;
extern NSInteger const MobilePaymentSDKAccountLimitExceededError;
extern NSInteger const MobilePaymentSDKOrderIdAlreadyUsedError;
extern NSInteger const MobilePaymentSDKDeclinedByCardIssuerError;
extern NSInteger const MobilePaymentSDKUndefinedError;
