//
//  MPCheckoutError.m
//  MPCheckout
//
//  Created by Valio Cholakov on 1/31/17.
//  Copyright © 2017 Intercard Finance AD. All rights reserved.
//

#import "MPCheckoutError.h"

@implementation MPCheckoutError

NSInteger const MPCheckoutConnectivityChangedError     = -7;
NSInteger const MPCheckoutNotInitializedError          = -6;
NSInteger const MPCheckoutSignatureValidationError     = -5;
NSInteger const MPCheckoutCommunicationError           = -4;
NSInteger const MPCheckoutInvalidInputParametersError  = -3;
NSInteger const MPCheckoutAPIError                     = -2;
NSInteger const MPCheckoutTimeoutError                 = -1;
NSInteger const MPCheckoutNoError                      = 0;
NSInteger const MPCheckoutInvalidStoreIdError          = 4;
NSInteger const MPCheckoutInvalidParametersError       = 5;
NSInteger const MPCheckoutInvalidAmountError           = 9;
NSInteger const MPCheckoutInsufficientFundsError       = 13;
NSInteger const MPCheckoutTransactionNotPermittedError = 14;
NSInteger const MPCheckoutLimitExceededError           = 15;
NSInteger const MPCheckoutInactiveAccountError         = 17;
NSInteger const MPCheckoutInvalidAccountError          = 18;
NSInteger const MPCheckoutAccountLimitExceededError    = 19;
NSInteger const MPCheckoutOrderIdAlreadyUsedError      = 20;
NSInteger const MPCheckoutDeclinedByCardIssuerError    = 21;
NSInteger const MPCheckoutUndefinedError               = 99;

static NSString * const kErrorDomain = @"com.ipay.MPCheckoutError";

#pragma mark - Initialziers

+ (instancetype)errorWithStatus:(NSInteger)status {
    return [self errorWithDomain:kErrorDomain code:status userInfo:@{ NSLocalizedDescriptionKey : [self messageForStatus:status] }];
}

+ (instancetype)notInitializedError {
    return [self errorWithStatus:MPCheckoutNotInitializedError];
}

+ (instancetype)communicationError {
    return [self errorWithStatus:MPCheckoutCommunicationError];
}

+ (instancetype)undefinedError {
    return [self errorWithStatus:MPCheckoutUndefinedError];
}

#pragma mark - Private Methods

+ (NSString *)messageForStatus:(NSInteger)status {
    switch (status) {
        case MPCheckoutTimeoutError:
            return @"Request timed out";
            
        case MPCheckoutConnectivityChangedError:
            return @"No internet connection. Please check your previous transaction by transaction id";
            
        case MPCheckoutNoError:
            return @"N/A";
            
        case MPCheckoutInvalidStoreIdError:
            return @"Invalid Store Id";
            
        case MPCheckoutInvalidInputParametersError:
        case MPCheckoutInvalidParametersError:
            return @"Invalid parameters";
            
        case MPCheckoutInvalidAmountError:
            return @"Invalid amount";
            
        case MPCheckoutInsufficientFundsError:
            return @"Insufficient funds";
            
        case MPCheckoutTransactionNotPermittedError:
            return @"Transaction not permitted";
            
        case MPCheckoutLimitExceededError:
            return @"Limit exceeded";
            
        case MPCheckoutInactiveAccountError:
            return @"Inactive account";
            
        case MPCheckoutInvalidAccountError:
            return @"Invalid account";
            
        case MPCheckoutAccountLimitExceededError:
            return @"Account limit exceeded";
            
        case MPCheckoutUndefinedError:
            return @"Undefined";
            
        case MPCheckoutNotInitializedError:
            return @"SDK not initialized";
            
        case MPCheckoutSignatureValidationError:
            return @"Signature validation failed. Check your public certificate";
            
        case MPCheckoutCommunicationError:
            return @"Communication error";
            
        case MPCheckoutAPIError:
            return @"API error";
            
        case MPCheckoutOrderIdAlreadyUsedError:
            return @"Order id already used for a different transaction";
            
        case MPCheckoutDeclinedByCardIssuerError:
            return @"Transaction is declined by card issuer";
            
        default:
            return @"Unknown";
    }
}

@end
