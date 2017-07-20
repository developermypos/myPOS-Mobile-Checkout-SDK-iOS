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

/*!
 * @enum TransactionType
 *
 * @constant TransactionTypeUnknown
 * @constant TransactionTypePurchase
 * @constant TransactionTypeRefund
 */
typedef NS_ENUM (NSUInteger, TransactionType) {
    TransactionTypeUnknown,
    TransactionTypePurchase,
    TransactionTypeRefund,
};

/*!
 * @enum Currency
 *
 * @constant CurrencyHRK
 * @constant CurrencyCZK
 * @constant CurrencyDKK
 * @constant CurrencyHUF
 * @constant CurrencyISK
 * @constant CurrencyNOK
 * @constant CurrencySEK
 * @constant CurrencyCHF
 * @constant CurrencyGBP
 * @constant CurrencyUSD
 * @constant CurrencyRON
 * @constant CurrencyBGN
 * @constant CurrencyEUR
 * @constant CurrencyPLN
 */
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

/*!
 * @method initializeWithAccountNumber:storeId:currency:certificate:privateKey:bundle:keyIndex:
 *
 * @param accountNumber     The account number of your account.
 * @param storeId           The id of the store which will accept the transactions.
 * @param currency          The currency in which to process transactions.
 * @param certificate       The generated public certificate.
 * @param privateKey        The generated private key.
 * @param bundle            In case of a custom bundle where the resources are held. Defaults to the Main.
 * @param keyIndex          The index of the generated keys (certificate/private key).
 *
 * @see                     Currency
 */
+ (void)initializeWithAccountNumber:(NSString * _Nonnull)accountNumber
                            storeId:(NSString * _Nonnull)storeId
                           currency:(Currency)currency
                        certificate:(NSString * _Nonnull)certificate
                         privateKey:(NSString * _Nonnull)privateKey
                             bundle:(NSBundle * _Nullable)bundle
                           keyIndex:(NSInteger)keyIndex;

/*!
 * @method initializeWithAccountNumber:storeId:currency:certificate:privateKey:bundle:keyIndex:inSandbox:
 *
 * @param accountNumber     The account number of your account.
 * @param storeId           The id of the store which will accept the transactions.
 * @param currency          The currency in which to process transactions.
 * @param certificate       The generated public certificate.
 * @param privateKey        The generated private key.
 * @param bundle            In case of a custom bundle where the resources are held. Defaults to the Main.
 * @param keyIndex          The index of the generated keys (certificate/private key).
 * @param inSandbox         Flag whether to use the Sandbox or Production environment. Defaults to NO.
 *
 * @see                     Currency
 */
+ (void)initializeWithAccountNumber:(NSString * _Nonnull)accountNumber
                            storeId:(NSString * _Nonnull)storeId
                           currency:(Currency)currency
                        certificate:(NSString * _Nonnull)certificate
                         privateKey:(NSString * _Nonnull)privateKey
                             bundle:(NSBundle * _Nullable)bundle
                           keyIndex:(NSInteger)keyIndex
                          inSandbox:(BOOL)inSandbox;

/*!
 * @method applyTheme:
 *
 * @param theme             A custom theme that will be applied accross the Payment screens.
 *
 * @see                     MobilePaymentTheme
 */
+ (void)applyTheme:(MobilePaymentTheme * _Nonnull)theme;

/*!
 * @method getOrderStatus:transactionType:completion:failure:
 *
 * @param orderId           The order id of the transaction.
 * @param transactionType   The type of the transaction.
 * @param completion        On success block containing the order status and transaction reference.
 * @param failure           On error block in case something fails with an error object containing more information.
 *
 * @see                     TransactionType
 * @seealso                 MobilePaymentSDKError
 */
+ (void)getOrderStatus:(NSString * _Nonnull)orderId
       transactionType:(TransactionType)transactionType
            completion:(void (^ _Nullable)(NSInteger status, NSString * _Nonnull transactionRef))completion
               failure:(void (^ _Nullable)(MobilePaymentSDKError * _Nonnull error))failure;

/*!
 * @method refundTransaction:fromOrder:amount:completion:failure:
 *
 * @param transactionRef    The reference of the transaction which to refund.
 * @param orderId           The custom order id of the transaction.
 * @param amount            The amount to refund.
 * @param completion        On success block containing the transaction reference of the refund itself.
 * @param failure           On error block in case something fails with an error object containing more information.
 *
 * @see                     MobilePaymentSDKError
 */
+ (void)refundTransaction:(NSString * _Nonnull)transactionRef
                fromOrder:(NSString * _Nonnull)orderId
                   amount:(CGFloat)amount
               completion:(void (^ _Nullable)(NSString * _Nonnull transactionRef))completion
                  failure:(void (^ _Nullable)(MobilePaymentSDKError * _Nonnull error))failure;

@end
