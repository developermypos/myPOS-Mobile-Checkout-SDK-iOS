//
//  MPCheckoutError.m
//  MPCheckout
//
//  Created by Valio Cholakov on 1/31/17.
//  Copyright © 2017 Intercard Finance AD. All rights reserved.
//

#import "MPCheckoutError.h"
#import "ICHelpers.h"
#import "ICConstants.h"
#import "NSString+Helpers.h"
#import "ICMobilePaymentManager.h"

@implementation MPCheckoutError

NSInteger const MPCheckoutConnectivityChangedError     = -7;
NSInteger const MPCheckoutNotInitializedError          = -6;
NSInteger const MPCheckoutSignatureValidationError     = -5;
NSInteger const MPCheckoutCommunicationError           = -4;
NSInteger const MPCheckoutInvalidInputParametersError  = -3;
NSInteger const MPCheckoutAPIError                     = -2;
NSInteger const MPCheckoutTimeoutError                 = -1;
NSInteger const MPCheckoutNoError                      = 0;
NSInteger const MPCheckoutCardIssuerError              = 3;
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

NSString * const MPSubStatusCallIssuer1                                  = @"01";
NSString * const MPSubStatusCallIssuer2                                  = @"02";
NSString * const MPSubStatusInvalidMerchant                              = @"03";
NSString * const MPSubStatusCaptureCard                                  = @"04";
NSString * const MPSubStatusDoNotHonor                                   = @"05";
NSString * const MPSubStatusIssuerGeneralError                           = @"06";
NSString * const MPSubStatusPickUpCard                                   = @"07";
NSString * const MPSubStatusHonorWithId                                  = @"08";
NSString * const MPSubStatusRequestInProgress                            = @"09";
NSString * const MPSubStatusApprovedForPartialAmount                     = @"10";
NSString * const MPSubStatusInvalidTransaction                           = @"12";
NSString * const MPSubStatusInvalidAmount                                = @"13";
NSString * const MPSubStatusInvalidCardNumber                            = @"14";
NSString * const MPSubStatusInvalidUser                                  = @"15";
NSString * const MPSubStatusCustomerCancellation                         = @"17";
NSString * const MPSubStatusReEnterTransaction                           = @"19";
NSString * const MPSubStatusInvalidResponse                              = @"20";
NSString * const MPSubStatusNoActionTaken                                = @"21";
NSString * const MPSubStatusSuspectedMalfunction                         = @"22";
NSString * const MPSubStatusUnacceptableTransactionFee                   = @"23";
NSString * const MPSubStatusFileUpdateNotSupported                       = @"24";
NSString * const MPSubStatusUnableToLocateRecord                         = @"25";
NSString * const MPSubStatusDuplicateRecord                              = @"26";
NSString * const MPSubStatusFileUpdateEditError                          = @"27";
NSString * const MPSubStatusFileUpdateFileLocked                         = @"28";
NSString * const MPSubStatusFormatError                                  = @"30";
NSString * const MPSubStatusCardExpired                                  = @"33";
NSString * const MPSubStatusSuspectedFraud                               = @"34";
NSString * const MPSubStatusContactCardIssuer                            = @"35";
NSString * const MPSubStatusCardRestricted                               = @"36";
NSString * const MPSubStatusCallAcquirerSecurity                         = @"37";
NSString * const MPSubStatusPinTriesExceeded                             = @"38";
NSString * const MPSubStatusNoCreditAccount                              = @"39";
NSString * const MPSubStatusFunctionNotSupported                         = @"40";
NSString * const MPSubStatusLostCard                                     = @"41";
NSString * const MPSubStatusNoUniversalAccount                           = @"42";
NSString * const MPSubStatusCardStolen                                   = @"43";
NSString * const MPSubStatusCreditLimitReached                           = @"51";
NSString * const MPSubStatusCardExpired2                                 = @"54";
NSString * const MPSubStatusInvalidPin                                   = @"55";
NSString * const MPSubStatusInactiveCard                                 = @"56";
NSString * const MPSubStatusTransactionNotPermittedIssuerCardholder      = @"57";
NSString * const MPSubStatusTransactionNotPermittedAcquirerTerminal      = @"58";
NSString * const MPSubStatusSuspectedFraudNoto                           = @"59";
NSString * const MPSubStatusContactAcquirer                              = @"60";
NSString * const MPSubStatusExceedWithdrawalLimit                        = @"61";
NSString * const MPSubStatusCardRestricted2                              = @"62";
NSString * const MPSubStatusSecurityViolation                            = @"63";
NSString * const MPSubStatusIncorrectOriginalAmount                      = @"64";
NSString * const MPSubStatusExceedWithdrawalCountLimit                   = @"65";
NSString * const MPSubStatusCallAcquirerSecurity2                        = @"66";
NSString * const MPSubStatusHardCapture                                  = @"67";
NSString * const MPSubStatusResponseReceivedTooLate                      = @"68";
NSString * const MPSubStatusContactCardIssuer2                           = @"70";
NSString * const MPSubStatusPinNotChanged                                = @"71";
NSString * const MPSubStatusEmvDataInconsistent                          = @"72";
NSString * const MPSubStatusNumberOfPinRetriesExceeded                   = @"75";
NSString * const MPSubStatusDebitAccountNotExist                         = @"76";
NSString * const MPSubStatusCreditAccountNotExist                        = @"77";
NSString * const MPSubStatusInvalidAccount                               = @"78";
NSString * const MPSubStatusTimeoutAtIssuer                              = @"82";
NSString * const MPSubStatusNoAccounts                                   = @"83";
NSString * const MPSubStatusInvalidAuthorizationLifeCycle                = @"84";
NSString * const MPSubStatusNotValidForAvs                               = @"85";
NSString * const MPSubStatusPinValidationNotPossible                     = @"86";
NSString * const MPSubStatusCryptographicFailure                         = @"88";
NSString * const MPSubStatusUnacceptablePin                              = @"89";
NSString * const MPSubStatusCutOffInProgress                             = @"90";
NSString * const MPSubStatusAuthorizationSystemOrIssuerSystemInoperative = @"91";
NSString * const MPSubStatusUnableToRouteTransaction                     = @"92";
NSString * const MPSubStatusViolationOfLaw                               = @"93";
NSString * const MPSubStatusDuplicateTransaction                         = @"94";
NSString * const MPSubStatusReconcileError                               = @"95";
NSString * const MPSubStatusSystemErrorHasOccurred                       = @"96";
NSString * const MPSubStatusExceedsCashLimit                             = @"98";
NSString * const MPSubStatusDelayApproval                                = @"99";
NSString * const MPSubStatusSurchargeAmountNotPermitted                  = @"B1";
NSString * const MPSubStatusUnableToAuthorize                            = @"N0";
NSString * const MPSubStatusInvalidPanLength                             = @"N1";
NSString * const MPSubStatusMaxOnlineRefundReached                       = @"N3";
NSString * const MPSubStatusMaxOfflineRefundReached                      = @"N4";
NSString * const MPSubStatusMaxCreditPerRefundReached                    = @"N5";
NSString * const MPSubStatusMaxRefundCreditReached                       = @"N6";
NSString * const MPSubStatusMaxNumberOfRefundCredit                      = @"N9";
NSString * const MPSubStatusCorruptedCard                                = @"NO";
NSString * const MPSubStatusCorruptedAccount                             = @"NM";
NSString * const MPSubStatusOverDailyLimit                               = @"P1";
NSString * const MPSubStatusOverLimitTable                               = @"P6";
NSString * const MPSubStatusAdministrativeCardNeeded                     = @"P8";
NSString * const MPSubStatusEnterLesserAmount                            = @"P9";
NSString * const MPSubStatusPinRequired                                  = @"O5";
NSString * const MPSubStatusInvalidTransactionDate                       = @"Q0";
NSString * const MPSubStatusInvalidExpirationDate                        = @"Q1";
NSString * const MPSubStatusInvalidTransactionCode                       = @"Q2";
NSString * const MPSubStatusNumberTimesUsed                              = @"Q4";
NSString * const MPSubStatusAdministrativeCardNotFound                   = @"Q8";
NSString * const MPSubStatusAdministrativeCardNotAllowed                 = @"Q9";
NSString * const MPSubStatusAdministrativeTransactionsNotSupported       = @"R7";
NSString * const MPSubStatusCardOnNegativeNationalFile                   = @"R8";
NSString * const MPSubStatusDestinationNotAvailable                      = @"R9";
NSString * const MPSubStatusSuspectReversal                              = @"S0";
NSString * const MPSubStatusUnableToValidatePinSecurityModuleIsDown      = @"S9";
NSString * const MPSubStatusInvalidAdvanceIncrement                      = @"T1";
NSString * const MPSubStatusInvalidTransactionDateT                      = @"T2";
NSString * const MPSubStatusCardNotSupported                             = @"T3";
NSString * const MPSubStatusInvalidAccountT                              = @"T8";
NSString * const MPSubStatusArqcFailureDecline                           = @"U0";
NSString * const MPSubStatusAtcCheckFailure                              = @"U4";
NSString * const MPSubStatusCvrDecline                                   = @"U5";
NSString * const MPSubStatusTvrDecline                                   = @"U6";
NSString * const MPSubStatusReasonOnlineDecline                          = @"U7";
NSString * const MPSubStatusArqcFailure                                  = @"V0";
NSString * const MPSubStatusCvrReferral                                  = @"V1";
NSString * const MPSubStatusTvrReferral                                  = @"V2";
NSString * const MPSubStatusReasonOnlineCodeReferral                     = @"V3";
NSString * const MPSubStatusReasonFallbackReferral                       = @"V4";
NSString * const MPSubStatusArqcFailureCapture                           = @"V7";
NSString * const MPSubStatusCvrCapture                                   = @"V8";
NSString * const MPSubStatusTvrCapture                                   = @"V9";
NSString * const MPSubStatusForwardToIssuer                              = @"XA";
NSString * const MPSubStatusForwardToIssuer2                             = @"XD";
NSString * const MPSubStatusDeclinedUnableToGoOnline                     = @"Z3";
NSString * const MPSubStatusFraudPreventionECommerceScaRequest           = @"1A";
NSString * const MPSubStatusIssuerHostUnreachable                        = @"HU";

static NSString * const kErrorDomainId = @"com.ipay.MPCheckoutError";

#pragma mark - Initialziers

+ (instancetype)errorWithStatus:(NSInteger)status {
    return [self errorWithDomain:kErrorDomainId code:status userInfo:@{ NSLocalizedDescriptionKey : [self messageForStatus:status] }];
}

+ (instancetype)errorWithSubStatus:(NSString *)subStatus
                            status:(NSInteger)status {
    
    NSString * const message = [self messageForSubStatus:subStatus];
    return [self errorWithDomain:kErrorDomainId code:status userInfo:@{ NSLocalizedDescriptionKey : ICLocalizedString(message),
                                                                      @"SubStatus" : subStatus}];
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
            
        case MPCheckoutCardIssuerError:
            return @"Declined by card issuer";
            
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

+ (NSString *)messageForSubStatus:(NSString *)subStatus {
    NSString *subStatusStr = [subStatus uppercaseString];
    
    if ([[NSArray arrayWithObjects:
          MPSubStatusDuplicateRecord,
          MPSubStatusPinTriesExceeded,
          MPSubStatusNoCreditAccount,
          MPSubStatusFunctionNotSupported,
          MPSubStatusNoUniversalAccount,
          MPSubStatusCardStolen,
          MPSubStatusCreditLimitReached,
          MPSubStatusTransactionNotPermittedAcquirerTerminal,
          MPSubStatusSuspectedFraudNoto,
          MPSubStatusExceedWithdrawalLimit,
          MPSubStatusCardRestricted2,
          MPSubStatusSecurityViolation,
          MPSubStatusExceedWithdrawalCountLimit,
          MPSubStatusResponseReceivedTooLate,
          MPSubStatusNumberOfPinRetriesExceeded,
          MPSubStatusDebitAccountNotExist,
          MPSubStatusInvalidAuthorizationLifeCycle,
          MPSubStatusNotValidForAvs,
          MPSubStatusCryptographicFailure,
          MPSubStatusUnacceptablePin,
          MPSubStatusCutOffInProgress,
          MPSubStatusAuthorizationSystemOrIssuerSystemInoperative,
          MPSubStatusUnableToRouteTransaction,
          MPSubStatusViolationOfLaw,
          MPSubStatusDuplicateTransaction,
          MPSubStatusReconcileError,
          MPSubStatusSystemErrorHasOccurred,
          MPSubStatusFraudPreventionECommerceScaRequest,
          MPSubStatusUnableToAuthorize,
          MPSubStatusPinRequired,
          MPSubStatusAdministrativeCardNeeded,
          MPSubStatusEnterLesserAmount,
          MPSubStatusInvalidTransactionDate,
          MPSubStatusInvalidTransactionCode,
          MPSubStatusCardNotSupported,
          MPSubStatusArqcFailureDecline,
          MPSubStatusTvrDecline,
          MPSubStatusReasonOnlineDecline,
          MPSubStatusReasonOnlineCodeReferral,
          MPSubStatusReasonFallbackReferral,
          MPSubStatusCardOnNegativeNationalFile, nil] containsObject: subStatusStr]) {
        return @"The payment was declined. Please try again later or use a different card or payment method.";
    }
    else if ([[NSArray arrayWithObjects:
               MPSubStatusCallIssuer1,
               MPSubStatusCallIssuer2,
               MPSubStatusCaptureCard,
               MPSubStatusPickUpCard,
               MPSubStatusHonorWithId,
               MPSubStatusApprovedForPartialAmount,
               MPSubStatusInvalidUser,
               MPSubStatusNoActionTaken,
               MPSubStatusSuspectedMalfunction,
               MPSubStatusLostCard,
               MPSubStatusEmvDataInconsistent,
               MPSubStatusPinValidationNotPossible,
               MPSubStatusExceedsCashLimit,
               MPSubStatusDelayApproval,
               MPSubStatusIssuerHostUnreachable,
               MPSubStatusForwardToIssuer,
               MPSubStatusForwardToIssuer2,
               MPSubStatusSurchargeAmountNotPermitted,
               MPSubStatusDeclinedUnableToGoOnline,
               MPSubStatusArqcFailure,
               MPSubStatusCvrReferral,
               MPSubStatusTvrReferral,
               MPSubStatusArqcFailureCapture,
               MPSubStatusCvrCapture,
               MPSubStatusTvrCapture,
               MPSubStatusAtcCheckFailure,
               MPSubStatusCvrDecline,
               MPSubStatusSuspectReversal,
               MPSubStatusCorruptedCard,
               MPSubStatusNumberTimesUsed,
               MPSubStatusAdministrativeTransactionsNotSupported,
               MPSubStatusDestinationNotAvailable, nil] containsObject: subStatusStr]) {
        return @"Your payment was declined. Please contact your card issuer for assistance.";
    }
    else if ([[NSArray arrayWithObjects:
               MPSubStatusInvalidMerchant,
               MPSubStatusIssuerGeneralError,
               MPSubStatusInvalidTransaction,
               MPSubStatusFileUpdateNotSupported,
               MPSubStatusUnableToLocateRecord,
               MPSubStatusFileUpdateEditError,
               MPSubStatusFileUpdateFileLocked,
               MPSubStatusFormatError,
               MPSubStatusContactCardIssuer,
               MPSubStatusCardRestricted,
               MPSubStatusCallAcquirerSecurity,
               MPSubStatusTransactionNotPermittedIssuerCardholder,
               MPSubStatusCreditAccountNotExist,
               MPSubStatusInvalidAccount,
               MPSubStatusTimeoutAtIssuer,
               MPSubStatusNoAccounts,
               MPSubStatusInvalidAccountT,
               MPSubStatusOverDailyLimit,
               MPSubStatusOverLimitTable,
               MPSubStatusCorruptedAccount, nil] containsObject: subStatusStr]) {
        return @"The payment cannot be processed now. Please try again later or use a different card or payment method. Contact the merchant if the issue persists.";
    }
    else if ([[NSArray arrayWithObjects:
               MPSubStatusDoNotHonor,
               MPSubStatusContactAcquirer,
               MPSubStatusCallAcquirerSecurity2,
               MPSubStatusHardCapture,
               MPSubStatusContactCardIssuer2,
               MPSubStatusPinNotChanged,
               MPSubStatusInvalidPanLength,
               MPSubStatusInvalidAdvanceIncrement,
               MPSubStatusInvalidTransactionDateT,
               MPSubStatusUnableToValidatePinSecurityModuleIsDown,
               MPSubStatusAdministrativeCardNotFound,
               MPSubStatusAdministrativeCardNotAllowed, nil] containsObject: subStatusStr]) {
        return @"Your payment was declined. Please ensure your card information is correct or contact your card issuer for assistance.";
    }
    else if ([[NSArray arrayWithObjects:
               MPSubStatusReEnterTransaction,
               MPSubStatusInvalidResponse,
               MPSubStatusUnacceptableTransactionFee,
               MPSubStatusSuspectedFraud,
               MPSubStatusInvalidPin, nil] containsObject: subStatusStr]) {
        return @"Your payment was declined.Please try again or contact customer services for assistance.";
    }
    else if ([[NSArray arrayWithObjects:
               MPSubStatusMaxOnlineRefundReached,
               MPSubStatusMaxOfflineRefundReached,
               MPSubStatusMaxCreditPerRefundReached,
               MPSubStatusMaxRefundCreditReached,
               MPSubStatusMaxNumberOfRefundCredit, nil] containsObject: subStatusStr]) {
        return @"Maximum refund limit reached. Please contact customer support for further assistance";
    }
    else if ([[NSArray arrayWithObjects:
               MPSubStatusCardExpired,
               MPSubStatusCardExpired2,
               MPSubStatusInactiveCard,
               MPSubStatusInvalidExpirationDate, nil] containsObject: subStatusStr]) {
        return @"The card provided has expired. Please use a valid card or try to pay with another card";
    }
    else if ([[NSArray arrayWithObjects:
               MPSubStatusInvalidAmount,
               MPSubStatusIncorrectOriginalAmount, nil] containsObject: subStatusStr]) {
        return @"Your payment request cannot be processed due to an invalid amount. Please review the amount entered and try again.";
    }
    else if ([[NSArray arrayWithObjects:
               MPSubStatusRequestInProgress, nil] containsObject: subStatusStr]) {
        return @"Your payment request is currently in progress. Please try again later or contact support for assistance";
    }
    else if ([[NSArray arrayWithObjects:
               MPSubStatusCustomerCancellation, nil] containsObject: subStatusStr]) {
        return @"Your payment request was cancelled.";
    }
    else if ([[NSArray arrayWithObjects:
               MPSubStatusInvalidCardNumber, nil] containsObject: subStatusStr]) {
        return @"The card number provided is invalid. Please double-check and enter a valid card number to proceed with the payment.";
    }
    else {
        return @"The payment cannot be processed now. Please try again later or use a different card or payment method. Contact the merchant if the issue persists.";
    }
}

@end
