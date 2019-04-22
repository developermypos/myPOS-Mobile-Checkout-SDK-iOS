//
//  MPCheckoutError.h
//  MPCheckout
//
//  Created by Valio Cholakov on 1/31/17.
//  Copyright © 2017 Intercard Finance AD. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>

@interface MPCheckoutError : NSError

+ (instancetype)errorWithStatus:(NSInteger)status;
+ (instancetype)notInitializedError;
+ (instancetype)communicationError;
+ (instancetype)undefinedError;

@end

extern NSInteger const MPCheckoutConnectivityChangedError;
extern NSInteger const MPCheckoutNotInitializedError;
extern NSInteger const MPCheckoutSignatureValidationError;
extern NSInteger const MPCheckoutCommunicationError;
extern NSInteger const MPCheckoutInvalidInputParametersError;
extern NSInteger const MPCheckoutAPIError;
extern NSInteger const MPCheckoutTimeoutError;
extern NSInteger const MPCheckoutNoError;
extern NSInteger const MPCheckoutInvalidStoreIdError;
extern NSInteger const MPCheckoutCardIssuerError;
extern NSInteger const MPCheckoutInvalidParametersError;
extern NSInteger const MPCheckoutInvalidAmountError;
extern NSInteger const MPCheckoutInsufficientFundsError;
extern NSInteger const MPCheckoutTransactionNotPermittedError;
extern NSInteger const MPCheckoutLimitExceededError;
extern NSInteger const MPCheckoutInactiveAccountError;
extern NSInteger const MPCheckoutInvalidAccountError;
extern NSInteger const MPCheckoutAccountLimitExceededError;
extern NSInteger const MPCheckoutOrderIdAlreadyUsedError;
extern NSInteger const MPCheckoutDeclinedByCardIssuerError;
extern NSInteger const MPCheckoutUndefinedError;
