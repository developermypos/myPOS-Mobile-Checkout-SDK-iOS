//
//  ICCommunicationManager.m
//  MPCheckout
//
//  Created by Valio Cholakov on 1/31/17.
//  Copyright © 2017 Intercard Finance AD. All rights reserved.
//

#import "ICCommunicationManager.h"
#import "ICMobilePaymentManager.h"

#import "MPCard.h"
#import "ICUtil.h"
#import "MPCartItem.h"
#import "ICLogger.h"
#import "ICHelpers.h"
#import "ICConstants.h"
#import "MPURLRequest.h"
#import "ICReachability.h"
#import "ICHTTPOperation.h"
#import "MPAuthorization.h"

#import "ICPurchaseCommand.h"
#import "ICReversalCommand.h"
#import "ICRefundCommand.h"
#import "ICStoreCardCommand.h"
#import "ICGetCardDataCommand.h"
#import "ICUpdateStoredCardCommand.h"
#import "ICGetTransactionStatusCommand.h"

#import "ICPreAuthorizationCommand.h"
#import "ICPreAuthorizationCompletionCommand.h"
#import "ICPreAuthorizationCancellationCommand.h"
#import "ICGetPreAuthorizationStatusCommand.h"

#import "ICAuthorizationCommand.h"
#import "ICAuthorizationCaptureCommand.h"
#import "ICAuthorizationReverseCommand.h"
#import "ICAuthorizationListCommand.h"

#import "NSString+Helpers.h"
#import "NSDictionary+Helpers.h"

@interface ICCommunicationManager() {
    NSOperationQueue *_operationQueue;
    dispatch_queue_t _communicationQueue;
    ICReachability *_reachability;
}


@end

@implementation ICCommunicationManager

static char * const kCommunicationQueue = "com.mypos.MPCheckout-communication";

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
        __weak ICCommunicationManager *weakSelf = self;
        
        _operationQueue     = [[NSOperationQueue alloc] init];
        _communicationQueue = dispatch_queue_create(kCommunicationQueue, NULL);
        
        _reachability = [ICReachability reachabilityWithHostname:@"www.google.com"];
        _reachability.unreachableBlock = ^(ICReachability *reach) {
            [weakSelf cancelOperations];
        };
        
        [_reachability startNotifier];
    }
    
    return self;
}

- (void)cancelOperations {
    [_operationQueue cancelAllOperations];
}

#pragma mark - Public Methods

- (void)makePurchaseForItems:(NSArray<MPCartItem *> *)cartItems
                     orderId:(NSString *)orderId
                   cardToken:(NSString *)cardToken
                  completion:(void (^)(NSString *transactionRef))completionBlock
                     failure:(void (^)(MPCheckoutError *error))errorBlock {
    
    NSDictionary *cardData = @{ ICParameterCardToken : cardToken };
    
    [self makePurchaseForItems:cartItems orderId:orderId cardData:cardData completion:completionBlock failure:errorBlock];
}

- (void)makePurchaseForItems:(NSArray<MPCartItem *> *)cartItems
                     orderId:(NSString *)orderId
                        card:(MPCard *)card
                    cardData:(NSDictionary *)cardData
                  completion:(void (^)(NSString *transactionRef))completionBlock
                     failure:(void (^)(MPCheckoutError *error))errorBlock {
    
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
                           failure:(void (^)(MPCheckoutError *error))errorBlock {
    
    ICReversalCommand *command = [[ICReversalCommand alloc] initWithTransactionRef:transactionRef];
    [self sendCommand:command completion:[self financeOperationCompletion:completionBlock failure:errorBlock]];
}

- (void)makeRefundFor:(NSString *)amount
       transactionRef:(NSString *)transactionRef
              orderId:(NSString *)orderId
           completion:(void (^)(NSString *transactionRef))completionBlock
              failure:(void (^)(MPCheckoutError *error))errorBlock {
    
    ICRefundCommand *command = [[ICRefundCommand alloc] initWithTransactionRef:transactionRef orderId:orderId amount:amount];
    [self sendCommand:command completion:[self financeOperationCompletion:completionBlock failure:errorBlock]];
}

- (void)storeCard:(NSString *)pan
       expiryDate:(NSString *)expiryDate
              cvc:(NSString *)cvc
       embossName:(NSString *)embossName
       customName:(NSString *)customName
           amount:(NSString *)amount
      autoReverse:(BOOL)autoReverse
        extraData:(NSDictionary *)extraData
       completion:(void (^)(NSString *cardToken, NSString *transactionRef))completionBlock
          failure:(void (^)(MPCheckoutError *error))errorBlock {
    
    ICStoreCardCommand *command = [[ICStoreCardCommand alloc] initWithPan:pan
                                                                      cvc:cvc
                                                               expiryDate:expiryDate
                                                               embossName:embossName
                                                               customName:customName
                                                                   amount:amount
                                                              autoReverse:autoReverse
                                                                extraData:extraData];
    
    [self sendCommand:command completion:[self fullOperationCompletion:@[ICParameterCardToken, ICParameterTransactionRef]
                                                            completion:^(NSDictionary *data) {
                                                                completionBlock([data objectForKey:ICParameterCardToken],
                                                                                [[data objectForKey:ICParameterTransactionRef] isKindOfClass:[NSNumber class]] ? [[data objectForKey:ICParameterTransactionRef] stringValue] : [[data objectForKey:ICParameterTransactionRef] stringValue]);
                                                            } failed:errorBlock]];
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
                 failure:(void (^)(MPCheckoutError *error))errorBlock {
    
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
            failure:(void (^)(MPCheckoutError *error))errorBlock {
    
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
                     transactionType:(MPTransactionType)transactionType
                          completion:(void (^)(NSInteger status, NSString *transactionRef))completion
                             failure:(void (^)(MPCheckoutError *error))errorBlock {
    
    ICGetTransactionStatusCommand *command = [[ICGetTransactionStatusCommand alloc] initWithOrderId:orderId transactionType:transactionType];
    [self sendCommand:command completion:[self fullOperationCompletion:@[ICParameterTransactionStatus, ICParameterTransactionReference]
                                                            completion:^(NSDictionary *data) {
                                                                id trnRef = [data objectForKey:ICParameterTransactionReference];
                                                                NSString *transactionRef = [trnRef isKindOfClass:[NSNumber class]] ? [trnRef stringValue] : trnRef;
                                                                completion([[data objectForKey:ICParameterTransactionStatus] integerValue],
                                                                           transactionRef);
                                                            } failed:errorBlock]];
}

- (void)makePreAuthorizationFor:(CGFloat)amount
                       itemName:(NSString *)itemName
                        orderId:(NSString *)orderId
                           card:(MPCard *)card
                       cardData:(NSDictionary *)cardData
                     completion:(void (^)(NSString *))completion
                        failure:(void (^)(MPCheckoutError *))errorBlock {
    
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
    
    NSMutableDictionary<NSString *, NSString *> *extraData = [@{
                                                                ICParameterOrderId  : orderId,
                                                                ICParameterItemName : itemName
                                                                }
                                                              mutableCopy];
    
    [extraData addEntriesFromDictionary:cardData];
    
    ICPreAuthorizationCommand *command = [[ICPreAuthorizationCommand alloc] initWithAmount:ICFormatterAmount(amount) extraData:extraData];
    [self sendCommand:command completion:[self financeOperationCompletion:completion failure:errorBlock]];
}

- (void)completePreAuthorization:(NSString *)orderId
                       forAmount:(CGFloat)amount
                      inCurrency:(MPCurrency)currency
                      completion:(void (^)(NSString *orderId))completion
                         failure:(void (^)(MPCheckoutError *error))errorBlock {
    
    ICPreAuthorizationCompletionCommand *command = [[ICPreAuthorizationCompletionCommand alloc] initWithOrderId:orderId amount:ICFormatterAmount(amount)];
    [self sendCommand:command completion:[self fullOperationCompletion:@[ICParameterAmount, ICParameterCurrency, ICParameterOrderId]
                                                            completion:^(NSDictionary *data) {
        completion([data objectForKey:ICParameterOrderId]);
    }
                                                                failed:errorBlock]];
}

- (void)cancelPreAuthorization:(NSString *)orderId
                    completion:(void (^)(void))completion
                       failure:(void (^)(MPCheckoutError *error))errorBlock {
    
    ICPreAuthorizationCancellationCommand *command = [[ICPreAuthorizationCancellationCommand alloc] initWithOrderId:orderId];
    [self sendCommand:command completion:[self fullOperationCompletion:@[ICParameterAmount, ICParameterCurrency]
                                                            completion:^(NSDictionary *data) { completion(); }
                                                                failed:errorBlock]];
}

- (void)getPreAuthorizationStatus:(NSString *)orderId
                       completion:(void (^)(MPPreAuthorizationStatus status, NSString *expiryDate))completion
                          failure:(void (^)(MPCheckoutError *error))errorBlock {
    
    ICGetPreAuthorizationStatusCommand *command = [[ICGetPreAuthorizationStatusCommand alloc] initWithOrderId:orderId];
    [self sendCommand:command completion:[self fullOperationCompletion:@[ICParameterOrderId, IPCParameterPreAuthStatus, ICParameterPreAuthExpDate]
                                                            completion:^(NSDictionary *data) {
        completion((MPPreAuthorizationStatus)[[data objectForKey:IPCParameterPreAuthStatus] integerValue],
                   [data objectForKey:ICParameterPreAuthExpDate]);
    }
                                                                failed:errorBlock]];
}

- (void)makeAuthorizationFor:(CGFloat)amount
                    itemName:(NSString *)itemName
                     orderId:(NSString *)orderId
                   cardToken:(NSString *)cardToken
                  completion:(void (^)(NSString *transactionReference))completion
                     failure:(void (^)(MPCheckoutError *))errorBlock {
    
    ICAuthorizationCommand *command = [[ICAuthorizationCommand alloc] initWithAmount:ICFormatterAmount(amount)
                                                                             orderId:orderId
                                                                            itemName:itemName
                                                                           cardToken:cardToken];
    [self sendCommand:command completion:[self fullOperationCompletion:@[ICParameterOrderId, ICParameterAuthorizationTrnRef, ICParameterPreAuthExpDate]
                                                            completion:^(NSDictionary *data) {
        completion([data objectForKey:ICParameterAuthorizationTrnRef]);
    } failed:errorBlock]];
}

- (void)captureAuthorizationAmounr:(CGFloat)amount
                         fromOrder:(NSString *)orderId
                        completion:(void (^)(NSString *transactionReference))completion
                           failure:(void (^)(MPCheckoutError *))errorBlock {
    
    ICAuthorizationCaptureCommand *command = [[ICAuthorizationCaptureCommand alloc] initWithAmount:ICFormatterAmount(amount) orderId:orderId];
    [self sendCommand:command completion:[self fullOperationCompletion:@[ICParameterOrderId, ICParameterAuthorizationTrnRef]
                                                            completion:^(NSDictionary *data) {
        completion([data objectForKey:ICParameterAuthorizationTrnRef]);
    }
                                                                failed:errorBlock]];
}

- (void)cancelAuthorization:(NSString *)orderId
                 completion:(void (^)(NSString *transactionReference))completion
                    failure:(void (^)(MPCheckoutError *))errorBlock {
    
    ICAuthorizationReverseCommand *command = [[ICAuthorizationReverseCommand alloc] initWithOrderId:orderId];
    [self sendCommand:command completion:[self fullOperationCompletion:@[ICParameterOrderId]
                                                            completion:^(NSDictionary *data) {
        completion([data objectForKey:ICParameterOrderId]);
    }
                                                                failed:errorBlock]];
}

- (void)listAuthorizationsWithCompletion:(void (^)(NSArray<MPAuthorization *> *authorizations))completion
                                 failure:(void (^)(MPCheckoutError *))errorBlock {
    
    ICAuthorizationListCommand *command = [[ICAuthorizationListCommand alloc] init];
    [self sendCommand:command completion:[self fullOperationCompletion:@[ICParameterAuthorization]
                                                            completion:^(NSDictionary *data) {
        NSArray *authorizationsData = [data objectForKey:ICParameterAuthorization];
        NSMutableArray<MPAuthorization *> *authorizations = [[NSMutableArray alloc] initWithCapacity:authorizationsData.count];
        
        for (NSDictionary *authorizationData in authorizationsData) {
            [authorizations addObject:[[MPAuthorization alloc] initFromData:authorizationData]];
        }
        
        completion(authorizations);
    }
                                                                failed:errorBlock]];
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
        
        signature = [[signature componentsSeparatedByCharactersInSet:[NSCharacterSet newlineCharacterSet]] componentsJoinedByString:@""];
        
        NSString *requestData = [NSString stringWithFormat:@"%@&%@=%@",
                                 [command.data formData], ICParameterSignature, [signature urlEncoded]];
        
        [ICLogger log:command.requestInfo];
        [ICLogger logDebug:[NSString stringWithFormat:@"Request: %@?%@", [ICMobilePaymentManager apiUrl], requestData]];
        
        NSData *body = [requestData dataUsingEncoding:NSUTF8StringEncoding];
        
        if (!body) {
            [ICLogger logDebug:@"Invalid request data"];
            dispatch_async(dispatch_get_main_queue(), communicationErrorBlock);
            return;
        }
        
        MPURLRequest    *request   = [[MPURLRequest alloc] initWithBody:body];
        ICHTTPOperation *operation = [[ICHTTPOperation alloc] initWithRequest:request
                                                                 successBlock:^(NSDictionary * _Nonnull response) { completion(response); }
                                                                   errorBlock:^(MPCheckoutError * _Nonnull error) { completion(error); }];
        [self->_operationQueue addOperation:operation];
    });
}

#pragma mark - Helpers

- (void)makePurchaseForItems:(NSArray<MPCartItem *> *)cartItems
                     orderId:(NSString *)orderId
                    cardData:(NSDictionary<NSString *, NSString *> *)cardData
                  completion:(void (^)(NSString *transactionRef))completionBlock
                     failure:(void (^)(MPCheckoutError *error))errorBlock {
    
    __block CGFloat amount = 0.0f;
    NSMutableDictionary<NSString *, NSString *> *extraData = [@{
                                                                ICParameterOrderId   : orderId,
                                                                ICParameterCartItems : ICIntegerToString(cartItems.count)
                                                                }
                                                              mutableCopy];
    
    [cartItems enumerateObjectsUsingBlock:^(MPCartItem * _Nonnull cartItem, NSUInteger idx, BOOL * _Nonnull stop) {
        amount += (cartItem.price * cartItem.quantity);
        
        [extraData addEntriesFromDictionary:[cartItem formattedData:idx + 1]];
    }];
    
    [extraData addEntriesFromDictionary:cardData];
    
    ICPurchaseCommand *command = [[ICPurchaseCommand alloc] initWithAmount:ICFormatterAmount(amount) extraData:extraData];
    [self sendCommand:command completion:[self financeOperationCompletion:completionBlock failure:errorBlock]];
}

- (void (^)(id response))financeOperationCompletion:(void (^)(NSString *transactionRef))completionBlock failure:(void (^)(MPCheckoutError *error))errorBlock {
    return [self operationCompletion:ICParameterTransactionRef completion:completionBlock failed:errorBlock];
}

- (void (^)(id response))cardOperationCompletion:(void (^)(NSString *transactionRef))completionBlock failure:(void (^)(MPCheckoutError *error))errorBlock {
    return [self operationCompletion:ICParameterCardToken completion:completionBlock failed:errorBlock];
}

- (void (^)(id response))operationCompletion:(NSString *)paramName
                                  completion:(void (^)(NSString *data))completion
                                      failed:(void (^)(MPCheckoutError *error))failed {
    return ^(id response) {
        if ([response isKindOfClass:[MPCheckoutError class]]) {
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
                                     failed:(void (^)(MPCheckoutError *error))failed {
    return ^(id response) {
        if ([response isKindOfClass:[MPCheckoutError class]]) {
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
                if (![response objectForKey:paramName]) {
                    continue;
                }
                
                [parameters setObject:[response objectForKey:paramName] forKey:paramName];
            }
        }
        
        completion(parameters);
    };
}

- (MPCheckoutError *)communicationError {
    return [MPCheckoutError communicationError];
}

- (MPCheckoutError *)unknownError {
    return [MPCheckoutError undefinedError];
}

@end
