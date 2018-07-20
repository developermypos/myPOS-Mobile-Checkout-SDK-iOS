//
//  ICCommunicationManager.h
//  MPCheckout
//
//  Created by Valio Cholakov on 1/31/17.
//  Copyright © 2017 Intercard Finance AD. All rights reserved.
//

#import "ICBaseManager.h"
#import "MPCheckout.h"

@class MPCard;
@class MPCartItem;
@class MPCheckoutError;

@interface ICCommunicationManager : ICBaseManager

- (void)makePurchaseForItems:(NSArray<MPCartItem *> *)cartItems
                     orderId:(NSString *)orderId
                   cardToken:(NSString *)cardToken
                  completion:(void (^)(NSString *transactionRef))completionBlock
                     failure:(void (^)(MPCheckoutError *error))errorBlock;

- (void)makePurchaseForItems:(NSArray<MPCartItem *> *)cartItems
                     orderId:(NSString *)orderId
                        card:(MPCard *)card
                    cardData:(NSDictionary *)cardData
                  completion:(void (^)(NSString *transactionRef))completionBlock
                     failure:(void (^)(MPCheckoutError *error))errorBlock;

- (void)makeReversalForTransaction:(NSString *)transactionRef
                        completion:(void (^)(NSString *transactionRef))completionBlock
                           failure:(void (^)(MPCheckoutError *error))errorBlock;

- (void)makeRefundFor:(NSString *)amount
       transactionRef:(NSString *)transactionRef
              orderId:(NSString *)orderId
           completion:(void (^)(NSString *transactionRef))completionBlock
              failure:(void (^)(MPCheckoutError *error))errorBlock;

- (void)storeCard:(NSString *)pan
       expiryDate:(NSString *)expiryDate
              cvc:(NSString *)cvc
       embossName:(NSString *)embossName
       customName:(NSString *)customName
           amount:(NSString *)amount
        extraData:(NSDictionary *)extraData
       completion:(void (^)(NSString *cardToken))completionBlock
          failure:(void (^)(MPCheckoutError *error))errorBlock;

- (void)updateStoredCard:(NSString *)token
                     pan:(NSString *)pan
              expiryDate:(NSString *)expiryDate
                     cvc:(NSString *)cvc
              embossName:(NSString *)embossName
              customName:(NSString *)customName
                  amount:(NSString *)amount
               extraData:(NSDictionary *)extraData
              completion:(void (^)(NSString *cardToken))completionBlock
                 failure:(void (^)(MPCheckoutError *error))errorBlock;

- (void)getCardData:(NSString *)pan
         completion:(void (^)(NSDictionary *data))completionBlock
            failure:(void (^)(MPCheckoutError *error))errorBlock;

- (void)getTransactionStatusForOrder:(NSString *)orderId
                     transactionType:(TransactionType)transactionType
                          completion:(void (^)(NSInteger status, NSString *transactionRef))completion
                             failure:(void (^)(MPCheckoutError *error))errorBlock;

@end
