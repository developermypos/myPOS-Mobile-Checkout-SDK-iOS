//
//  ICCommunicationManager.h
//  MobilePaymentSDK
//
//  Created by Valio Cholakov on 1/31/17.
//  Copyright © 2017 Intercard Finance AD. All rights reserved.
//

#import "ICBaseManager.h"
#import "MobilePaymentSDK.h"

@class Card;
@class CartItem;
@class MobilePaymentSDKError;

@interface ICCommunicationManager : ICBaseManager

- (void)makePurchaseForItems:(NSArray<CartItem *> *)cartItems
                     orderId:(NSString *)orderId
                   cardToken:(NSString *)cardToken
                  completion:(void (^)(NSString *transactionRef))completionBlock
                     failure:(void (^)(MobilePaymentSDKError *error))errorBlock;

- (void)makePurchaseForItems:(NSArray<CartItem *> *)cartItems
                     orderId:(NSString *)orderId
                        card:(Card *)card
                    cardData:(NSDictionary *)cardData
                  completion:(void (^)(NSString *transactionRef))completionBlock
                     failure:(void (^)(MobilePaymentSDKError *error))errorBlock;

- (void)makeReversalForTransaction:(NSString *)transactionRef
                        completion:(void (^)(NSString *transactionRef))completionBlock
                           failure:(void (^)(MobilePaymentSDKError *error))errorBlock;

- (void)makeRefundFor:(NSString *)amount
       transactionRef:(NSString *)transactionRef
              orderId:(NSString *)orderId
           completion:(void (^)(NSString *transactionRef))completionBlock
              failure:(void (^)(MobilePaymentSDKError *error))errorBlock;

- (void)storeCard:(NSString *)pan
       expiryDate:(NSString *)expiryDate
              cvc:(NSString *)cvc
       embossName:(NSString *)embossName
       customName:(NSString *)customName
           amount:(NSString *)amount
        extraData:(NSDictionary *)extraData
       completion:(void (^)(NSString *cardToken))completionBlock
          failure:(void (^)(MobilePaymentSDKError *error))errorBlock;

- (void)updateStoredCard:(NSString *)token
                     pan:(NSString *)pan
              expiryDate:(NSString *)expiryDate
                     cvc:(NSString *)cvc
              embossName:(NSString *)embossName
              customName:(NSString *)customName
                  amount:(NSString *)amount
               extraData:(NSDictionary *)extraData
              completion:(void (^)(NSString *cardToken))completionBlock
                 failure:(void (^)(MobilePaymentSDKError *error))errorBlock;

- (void)getCardData:(NSString *)pan
         completion:(void (^)(NSDictionary *data))completionBlock
            failure:(void (^)(MobilePaymentSDKError *error))errorBlock;

- (void)getTransactionStatusForOrder:(NSString *)orderId
                     transactionType:(TransactionType)transactionType
                          completion:(void (^)(NSInteger status, NSString *transactionRef))completion
                             failure:(void (^)(MobilePaymentSDKError *error))errorBlock;

@end
