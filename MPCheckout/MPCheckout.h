//
//  MPCheckout.h
//  MPCheckout
//
//  Created by Valio Cholakov on 1/31/17.
//  Copyright © 2017 Intercard Finance AD. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>

#import "MPCard.h"
#import "MPStoredCard.h"
#import "MPCartItem.h"
#import "MPCheckoutTheme.h"
#import "MPCheckoutError.h"
#import "MPCheckoutProtocols.h"
#import "MPPaymentViewController.h"
#import "MPStoreCardViewController.h"
#import "MPUpdateStoredCardViewController.h"

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

@interface MPCheckout : NSObject

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

+ (void)applyTheme:(MPCheckoutTheme * _Nonnull)theme;

+ (void)getOrderStatus:(NSString * _Nonnull)orderId
       transactionType:(TransactionType)transactionType
            completion:(void (^ _Nullable)(NSInteger status, NSString * _Nonnull transactionRef))completion
               failure:(void (^ _Nullable)(MPCheckoutError * _Nonnull error))failure;

+ (void)refundTransaction:(NSString * _Nonnull)transactionRef
                fromOrder:(NSString * _Nonnull)orderId
                   amount:(CGFloat)amount
               completion:(void (^ _Nullable)(NSString * _Nonnull transactionRef))completion
                  failure:(void (^ _Nullable)(MPCheckoutError * _Nonnull error))failure;

@end
