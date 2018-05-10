//
//  MobilePaymentSDK.h
//  MobilePaymentSDK
//
//  Created by Valio Cholakov on 1/31/17.
//  Copyright © 2017 Intercard Finance AD. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>

#import "Card.h"
#import "CartItem.h"
#import "MobilePaymentTheme.h"
#import "MobilePaymentSDKError.h"
#import "MobilePaymentSDKProtocols.h"
#import "PaymentViewController.h"
#import "StoreCardViewController.h"
#import "UpdateStoredCardViewController.h"

typedef NS_ENUM (NSUInteger, TransactionType) {
    TransactionTypeUnknown,
    TransactionTypePurchase,
    TransactionTypeRefund,
};

typedef NS_ENUM (NSUInteger, Currency) {
    CurrencyHRK,
    CurrencyCZK,
    CurrencyDKK,
    CurrencyHUF,
    CurrencyISK,
    CurrencyNOK,
    CurrencySEK,
    CurrencyCHF,
    CurrencyGBP,
    CurrencyUSD,
    CurrencyRON,
    CurrencyBGN,
    CurrencyEUR,
    CurrencyPLN,
};

@interface MobilePaymentSDK : NSObject

+ (void)initializeWithAccountNumber:(NSString * _Nonnull)accountNumber
                            storeId:(NSString * _Nonnull)storeId
                           currency:(Currency)currency
                        certificate:(NSString * _Nonnull)certificate
                         privateKey:(NSString * _Nonnull)privateKey
                             bundle:(NSBundle * _Nullable)bundle
                           keyIndex:(NSInteger)keyIndex;

+ (void)initializeWithAccountNumber:(NSString * _Nonnull)accountNumber
                            storeId:(NSString * _Nonnull)storeId
                           currency:(Currency)currency
                        certificate:(NSString * _Nonnull)certificate
                         privateKey:(NSString * _Nonnull)privateKey
                             bundle:(NSBundle * _Nullable)bundle
                           keyIndex:(NSInteger)keyIndex
                          isSandbox:(BOOL)isSandbox;

+ (void)applyTheme:( MobilePaymentTheme * _Nonnull )theme;

+ (void)getOrderStatus:( NSString * _Nonnull)orderId
       transactionType:(TransactionType)transactionType
            completion:(void (^ _Nullable)(NSInteger status, NSString * _Nonnull transactionRef))completion
               failure:(void (^ _Nullable)(MobilePaymentSDKError * _Nonnull error))failure;

+ (void)refundTransaction:(NSString * _Nonnull)transactionRef
                fromOrder:(NSString * _Nonnull)orderId
                   amount:(CGFloat)amount
               completion:(void (^ _Nullable)(NSString * _Nonnull transactionRef))completion
                  failure:(void (^ _Nullable)(MobilePaymentSDKError * _Nonnull error))failure;

@end
