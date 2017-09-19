//
//  MobilePaymentSDKError.m
//  MobilePaymentSDK
//
//  Created by Valio Cholakov on 1/31/17.
//  Copyright © 2017 Intercard Finance AD. All rights reserved.
//

#import "MobilePaymentSDKError.h"

@implementation MobilePaymentSDKError

NSInteger const MobilePaymentSDKConnectivityChangedError     = -7;
NSInteger const MobilePaymentSDKNotInitializedError          = -6;
NSInteger const MobilePaymentSDKSignatureValidationError     = -5;
NSInteger const MobilePaymentSDKCommunicationError           = -4;
NSInteger const MobilePaymentSDKInvalidInputParametersError  = -3;
NSInteger const MobilePaymentSDKAPIError                     = -2;
NSInteger const MobilePaymentSDKTimeoutError                 = -1;
NSInteger const MobilePaymentSDKNoError                      = 0;
NSInteger const MobilePaymentSDKInvalidStoreIdError          = 4;
NSInteger const MobilePaymentSDKInvalidParametersError       = 5;
NSInteger const MobilePaymentSDKInvalidAmountError           = 9;
NSInteger const MobilePaymentSDKInsufficientFundsError       = 13;
NSInteger const MobilePaymentSDKTransactionNotPermittedError = 14;
NSInteger const MobilePaymentSDKLimitExceededError           = 15;
NSInteger const MobilePaymentSDKInactiveAccountError         = 17;
NSInteger const MobilePaymentSDKInvalidAccountError          = 18;
NSInteger const MobilePaymentSDKAccountLimitExceededError    = 19;
NSInteger const MobilePaymentSDKOrderIdAlreadyUsedError      = 20;
NSInteger const MobilePaymentSDKDeclinedByCardIssuerError    = 21;
NSInteger const MobilePaymentSDKUndefinedError               = 99;

static NSString * const kErrorDomain = @"com.ipay.MobilePaymentSDKError";

#pragma mark - Initialziers

+ (instancetype)errorWithStatus:(NSInteger)status {
    return [self errorWithDomain:kErrorDomain code:status userInfo:@{ NSLocalizedDescriptionKey : [self messageForStatus:status] }];
}

+ (instancetype)notInitializedError {
    return [self errorWithStatus:MobilePaymentSDKNotInitializedError];
}

+ (instancetype)communicationError {
    return [self errorWithStatus:MobilePaymentSDKCommunicationError];
}

+ (instancetype)undefinedError {
    return [self errorWithStatus:MobilePaymentSDKUndefinedError];
}

#pragma mark - Private Methods

+ (NSString *)messageForStatus:(NSInteger)status {
    switch (status) {
        case MobilePaymentSDKTimeoutError:
            return @"Request timed out";
            
        case MobilePaymentSDKConnectivityChangedError:
            return @"No internet connection. Please check your previous transaction by transaction id";
            
        case MobilePaymentSDKNoError:
            return @"N/A";
            
        case MobilePaymentSDKInvalidStoreIdError:
            return @"Invalid Store Id";
            
        case MobilePaymentSDKInvalidInputParametersError:
        case MobilePaymentSDKInvalidParametersError:
            return @"Invalid parameters";
            
        case MobilePaymentSDKInvalidAmountError:
            return @"Invalid amount";
            
        case MobilePaymentSDKInsufficientFundsError:
            return @"Insufficient funds";
            
        case MobilePaymentSDKTransactionNotPermittedError:
            return @"Transaction not permitted";
            
        case MobilePaymentSDKLimitExceededError:
            return @"Limit exceeded";
            
        case MobilePaymentSDKInactiveAccountError:
            return @"Inactive account";
            
        case MobilePaymentSDKInvalidAccountError:
            return @"Invalid account";
            
        case MobilePaymentSDKAccountLimitExceededError:
            return @"Account limit exceeded";
            
        case MobilePaymentSDKUndefinedError:
            return @"Undefined";
            
        case MobilePaymentSDKNotInitializedError:
            return @"SDK not initialized";
            
        case MobilePaymentSDKSignatureValidationError:
            return @"Signature validation failed. Check your public certificate";
            
        case MobilePaymentSDKCommunicationError:
            return @"Communication error";
            
        case MobilePaymentSDKAPIError:
            return @"API error";
            
        case MobilePaymentSDKOrderIdAlreadyUsedError:
            return @"Order id already used for a different transaction";
            
        case MobilePaymentSDKDeclinedByCardIssuerError:
            return @"Transaction is declined by card issuer";
            
        default:
            return @"Unknown";
    }
}

@end
