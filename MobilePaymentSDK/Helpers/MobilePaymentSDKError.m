//
//  MobilePaymentSDKError.m
//  MobilePaymentSDK
//
//  Created by Valio Cholakov on 1/31/17.
//  Copyright © 2017 Intercard Finance AD. All rights reserved.
//

#import "MobilePaymentSDKError.h"

@implementation MobilePaymentSDKError

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
            break;
            
        case MobilePaymentSDKNoError:
            return @"N/A";
            break;
            
        case MobilePaymentSDKInvalidStoreIdError:
            return @"Invalid Store Id";
            break;
            
        case MobilePaymentSDKInvalidInputParametersError:
        case MobilePaymentSDKInvalidParametersError:
            return @"Invalid parameters";
            break;
            
        case MobilePaymentSDKInvalidAmountError:
            return @"Invalid amount";
            break;
            
        case MobilePaymentSDKInsufficientFundsError:
            return @"Insufficient funds";
            break;
            
        case MobilePaymentSDKTransactionNotPermittedError:
            return @"Transaction not permitted";
            break;
            
        case MobilePaymentSDKLimitExceededError:
            return @"Limit exceeded";
            break;
            
        case MobilePaymentSDKInactiveAccountError:
            return @"Inactive account";
            break;
            
        case MobilePaymentSDKInvalidAccountError:
            return @"Invalid account";
            break;
            
        case MobilePaymentSDKAccountLimitExceededError:
            return @"Account limit exceeded";
            break;
            
        case MobilePaymentSDKUndefinedError:
            return @"Undefined";
            break;
            
        case MobilePaymentSDKNotInitializedError:
            return @"SDK not initialized";
            break;
            
        case MobilePaymentSDKSignatureValidationError:
            return @"Signature validaation failed. Check your public certificate";
            break;
            
        case MobilePaymentSDKCommunicationError:
            return @"Communication error";
            break;
            
        case MobilePaymentSDKAPIError:
            return @"API error";
            break;
            
        case MobilePaymentSDKOrderIdAlreadyUsedError:
            return @"Order id already used for a different transaction";
            break;
            
        default:
            return @"Unknown";
            break;
    }
}

@end
