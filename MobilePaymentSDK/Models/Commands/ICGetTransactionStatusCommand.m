//
//  ICGetTransactionStatusCommand.m
//  MobilePaymentSDK
//
//  Created by Valio Cholakov on 1/31/17.
//  Copyright © 2017 Intercard Finance AD. All rights reserved.
//

#import "ICGetTransactionStatusCommand.h"

@implementation ICGetTransactionStatusCommand

#pragma mark - Initializers

- (instancetype)initWithOrderId:(NSString *)orderId transactionType:(TransactionType)transactionType {
    if (self = [super init]) {
        [_data setObject:orderId                            forKey:ICParameterOrderId];
        [_data setObject:ICMethodGetTransactionStatus       forKey:ICParameterMethod];
        [_data setObject:ICIntegerToString(transactionType) forKey:ICParameterTransactionType];
    }
    
    return self;
}

#pragma mark - Abstract Methods

- (NSString *)requestInfo {
    return @"Getting tansaction status";
}

- (NSString *)responseInfo {
    return @"Tansaction status received";
}

@end
