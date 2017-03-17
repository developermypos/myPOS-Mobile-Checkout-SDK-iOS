//
//  ICCommunicationManager.m
//  MobilePaymentSDK
//
//  Created by Valio Cholakov on 1/31/17.
//  Copyright © 2017 Intercard Finance AD. All rights reserved.
//

#import "ICCommunicationManager.h"

#import "Card.h"
#import "ICUtil.h"
#import "CartItem.h"
#import "ICLogger.h"
#import "ICHelpers.h"
#import "ICConstants.h"
#import "ICURLRequest.h"
#import "ICHTTPOperation.h"

#import "ICPurchaseCommand.h"
#import "ICReversalCommand.h"
#import "ICRefundCommand.h"
#import "ICStoreCardCommand.h"
#import "ICGetCardDataCommand.h"
#import "ICUpdateStoredCardCommand.h"
#import "ICGetTransactionStatusCommand.h"

#import "NSString+Helpers.h"
#import "NSDictionary+Helpers.h"

@interface ICCommunicationManager() {
    NSOperationQueue *_operationQueue;
    dispatch_queue_t _communicationQueue;
}


@end

@implementation ICCommunicationManager

static char * const kCommunicationQueue = "com.ipay.MobilePaymentSDK-communication";

#pragma mark - Singleton

+ (instancetype)sharedManager {
    static ICCommunicationManager *manager = nil;
    static dispatch_once_t onceToken;
    
    dispatch_once(&onceToken, ^{
        manager = [[self alloc] init];
    });
    
    return manager;
}

#pragma mark - Initializers

- (instancetype)init {
    if (self = [super init]) {
        _operationQueue     = [[NSOperationQueue alloc] init];
        _communicationQueue = dispatch_queue_create(kCommunicationQueue, NULL);
    }
    
    return self;
}

#pragma mark - Public Methods

- (void)makePurchaseForItems:(NSArray<CartItem *> *)cartItems
                     orderId:(NSString *)orderId
                   cardToken:(NSString *)cardToken
                  completion:(void (^)(NSString *transactionRef))completionBlock
                     failure:(void (^)(MobilePaymentSDKError *error))errorBlock {
    
    NSDictionary *cardData = @{ ICParameterCardToken : cardToken };
    
    [self makePurchaseForItems:cartItems orderId:orderId cardData:cardData completion:completionBlock failure:errorBlock];
}

- (void)makePurchaseForItems:(NSArray<CartItem *> *)cartItems
                     orderId:(NSString *)orderId
                        card:(Card *)card
                    cardData:(NSDictionary *)cardData
                  completion:(void (^)(NSString *transactionRef))completionBlock
                     failure:(void (^)(MobilePaymentSDKError *error))errorBlock {
    
    NSString *pan        = [card.pan        encrypted];
    NSString *cvc        = [card.cvc        encrypted];
    NSString *expiryDate = [card.expiryDate encrypted];
    
    if (!pan || !cvc || !expiryDate) {
        if (errorBlock) {
            errorBlock([self unknownError]);
        }
        
        [ICLogger logDebug:@"Internal error"];
        return;
    }
    
    NSMutableDictionary *fullCardData = [@{
                                           ICParameterPAN        : pan,
                                           ICParameterCVC        : cvc,
                                           ICParameterExpiryDate : expiryDate,
                                           ICParameterCustomName : card.customName,
                                           ICParameterEmbossName : card.embossName
                                          }
                                         mutableCopy];
    
    [fullCardData addEntriesFromDictionary:cardData];
    [self makePurchaseForItems:cartItems orderId:orderId cardData:fullCardData completion:completionBlock failure:errorBlock];
}

- (void)makeReversalForTransaction:(NSString *)transactionRef
                        completion:(void (^)(NSString *transactionRef))completionBlock
                           failure:(void (^)(MobilePaymentSDKError *error))errorBlock {
    
    ICReversalCommand *command = [[ICReversalCommand alloc] initWithTransactionRef:transactionRef];
    [self sendCommand:command completion:[self financeOperationCompletion:completionBlock failure:errorBlock]];
}

- (void)makeRefundFor:(NSString *)amount
       transactionRef:(NSString *)transactionRef
              orderId:(NSString *)orderId
           completion:(void (^)(NSString *transactionRef))completionBlock
              failure:(void (^)(MobilePaymentSDKError *error))errorBlock {
    
    ICRefundCommand *command = [[ICRefundCommand alloc] initWithTransactionRef:transactionRef orderId:orderId amount:amount];
    [self sendCommand:command completion:[self financeOperationCompletion:completionBlock failure:errorBlock]];
}

- (void)storeCard:(NSString *)pan
       expiryDate:(NSString *)expiryDate
              cvc:(NSString *)cvc
       embossName:(NSString *)embossName
       customName:(NSString *)customName
           amount:(NSString *)amount
        extraData:(NSDictionary *)extraData
       completion:(void (^)(NSString *cardToken))completionBlock
          failure:(void (^)(MobilePaymentSDKError *error))errorBlock {
    
    ICStoreCardCommand *command = [[ICStoreCardCommand alloc] initWithPan:pan cvc:cvc
                                                               expiryDate:expiryDate
                                                               embossName:embossName
                                                               customName:customName
                                                                   amount:amount
                                                                extraData:extraData];
    
    [self sendCommand:command completion:[self cardOperationCompletion:completionBlock failure:errorBlock]];
}

- (void)updateStoredCard:(NSString *)token
                     pan:(NSString *)pan
              expiryDate:(NSString *)expiryDate
                     cvc:(NSString *)cvc
              embossName:(NSString *)embossName
              customName:(NSString *)customName
                  amount:(NSString *)amount
               extraData:(NSDictionary *)extraData
              completion:(void (^)(NSString *cardToken))completionBlock
                 failure:(void (^)(MobilePaymentSDKError *error))errorBlock {
    
    ICUpdateStoredCardCommand *command = [[ICUpdateStoredCardCommand alloc] initWithToken:token
                                                                                      pan:pan
                                                                                      cvc:cvc
                                                                               expiryDate:expiryDate
                                                                               embossName:embossName
                                                                               customName:customName
                                                                                   amount:amount
                                                                                extraData:extraData];
    
    [self sendCommand:command completion:[self cardOperationCompletion:completionBlock failure:errorBlock]];
}

- (void)getCardData:(NSString *)pan
         completion:(void (^)(NSDictionary *data))completionBlock
            failure:(void (^)(MobilePaymentSDKError *error))errorBlock {
    
    NSArray<NSString *> *parameters = @[
                                        ICParameterMID,
                                        ICParameterBIN,
                                        ICParameterCardType,
                                        ICParameterWalletId,
                                        ICParameterIs3DEnabled,
                                        ICParameterBillingDescriptor
                                        ];
    
    ICGetCardDataCommand *command = [[ICGetCardDataCommand alloc] initWithPan:pan];
    [self sendCommand:command completion:[self fullOperationCompletion:parameters completion:completionBlock failed:errorBlock]];
}

- (void)getTransactionStatusForOrder:(NSString *)orderId
                     transactionType:(TransactionType)transactionType
                          completion:(void (^)(NSInteger status, NSString *transactionRef))completion
                             failure:(void (^)(MobilePaymentSDKError *error))errorBlock {
    
    ICGetTransactionStatusCommand *command = [[ICGetTransactionStatusCommand alloc] initWithOrderId:orderId transactionType:transactionType];
    [self sendCommand:command completion:[self fullOperationCompletion:@[ICParameterTransactionStatus, ICParameterTransactionReference]
                                                            completion:^(NSDictionary *data) {
                                                                completion([[data objectForKey:ICParameterTransactionStatus] integerValue],
                                                                           [data objectForKey:ICParameterTransactionReference]);
                                                            } failed:errorBlock]];
}

#pragma mark - Private Methods

- (void)sendCommand:(ICBaseCommand *)command completion:(void (^)(id response))completion {
    dispatch_async(_communicationQueue, ^{
        NSString *signature = [ICUtil signedData:command.data];
        
        dispatch_block_t communicationErrorBlock = ^{
            if (completion) {
                completion([self communicationError]);
            }
        };
        
        if (!signature) {
            [ICLogger logDebug:@"Could not sign data"];
            dispatch_async(dispatch_get_main_queue(), communicationErrorBlock);
            return;
        }
        
        NSString *requestData = [NSString stringWithFormat:@"%@&%@=%@",
                                 [command.data formData], ICParameterSignature, [signature urlEncoded]];
        
        [ICLogger log:command.requestInfo];
        [ICLogger logDebug:[NSString stringWithFormat:@"Request: %@?%@", ICURLAPI, requestData]];
        
        NSData *body = [requestData dataUsingEncoding:NSUTF8StringEncoding];
        
        if (!body) {
            [ICLogger logDebug:@"Invalid request data"];
            dispatch_async(dispatch_get_main_queue(), communicationErrorBlock);
            return;
        }
        
        ICURLRequest    *request   = [[ICURLRequest alloc] initWithBody:body];
        ICHTTPOperation *operation = [[ICHTTPOperation alloc] initWithRequest:request
                                                                 successBlock:^(NSDictionary * _Nonnull response) { completion(response); }
                                                                   errorBlock:^(MobilePaymentSDKError * _Nonnull error) { completion(error); }];
        [_operationQueue addOperation:operation];
    });
}

#pragma mark - Helpers

- (void)makePurchaseForItems:(NSArray<CartItem *> *)cartItems
                     orderId:(NSString *)orderId
                    cardData:(NSDictionary<NSString *, NSString *> *)cardData
                  completion:(void (^)(NSString *transactionRef))completionBlock
                     failure:(void (^)(MobilePaymentSDKError *error))errorBlock {
    
    __block CGFloat amount = 0.0f;
    NSMutableDictionary<NSString *, NSString *> *extraData = [@{
                                                                ICParameterOrderId   : orderId,
                                                                ICParameterCartItems : ICIntegerToString(cartItems.count)
                                                                }
                                                              mutableCopy];
    
    [cartItems enumerateObjectsUsingBlock:^(CartItem * _Nonnull cartItem, NSUInteger idx, BOOL * _Nonnull stop) {
        amount += (cartItem.price * cartItem.quantity);
        
        [extraData addEntriesFromDictionary:[cartItem formattedData:idx + 1]];
    }];
    
    [extraData addEntriesFromDictionary:cardData];
    
    ICPurchaseCommand *command = [[ICPurchaseCommand alloc] initWithAmount:ICFormatterAmount(amount) extraData:extraData];
    [self sendCommand:command completion:[self financeOperationCompletion:completionBlock failure:errorBlock]];
}

- (void (^)(id response))financeOperationCompletion:(void (^)(NSString *transactionRef))completionBlock failure:(void (^)(MobilePaymentSDKError *error))errorBlock {
    return [self operationCompletion:ICParameterTransactionRef completion:completionBlock failed:errorBlock];
}

- (void (^)(id response))cardOperationCompletion:(void (^)(NSString *transactionRef))completionBlock failure:(void (^)(MobilePaymentSDKError *error))errorBlock {
    return [self operationCompletion:ICParameterCardToken completion:completionBlock failed:errorBlock];
}

- (void (^)(id response))operationCompletion:(NSString *)paramName
                             completion:(void (^)(NSString *data))completion
                                 failed:(void (^)(MobilePaymentSDKError *error))failed {
    return ^(id response) {
        if ([response isKindOfClass:[MobilePaymentSDKError class]]) {
            failed(response);
            return;
        }
        
        if (![response isKindOfClass:[NSDictionary class]]) {
            failed([self communicationError]);
            return;
        }
        
        NSString *parameter = [response objectForKey:paramName];
        
        if (!parameter) {
            failed([self communicationError]);
            return;
        }
        
        completion(parameter);
    };
}

- (void (^)(id response))fullOperationCompletion:(NSArray<NSString *> *)paramNames
                                 completion:(void (^)(NSDictionary *data))completion
                                     failed:(void (^)(MobilePaymentSDKError *error))failed {
    return ^(id response) {
        if ([response isKindOfClass:[MobilePaymentSDKError class]]) {
            failed(response);
            return;
        }
        
        if (![response isKindOfClass:[NSDictionary class]]) {
            failed([self communicationError]);
            return;
        }
        
        if (![response objectForKey:ICParameterStatus]) {
            failed([self communicationError]);
            return;
        }
        
        NSInteger status = [[response objectForKey:ICParameterStatus] integerValue];
        
        
        if (status != ICResponseStatusOK) {
            failed([self communicationError]);
            return;
        }
        
        NSMutableDictionary *parameters = [NSMutableDictionary new];
        
        for (NSString *paramName in paramNames) {
            @autoreleasepool {
                [parameters setObject:[response objectForKey:paramName] forKey:paramName];
            }
        }
        
        completion(parameters);
    };
}

- (MobilePaymentSDKError *)communicationError {
    return [MobilePaymentSDKError communicationError];
}

- (MobilePaymentSDKError *)unknownError {
    return [MobilePaymentSDKError undefinedError];
}

@end
