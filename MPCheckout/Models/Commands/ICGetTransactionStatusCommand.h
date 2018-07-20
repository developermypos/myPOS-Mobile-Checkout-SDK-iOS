//
//  ICGetTransactionStatusCommand.h
//  MPCheckout
//
//  Created by Valio Cholakov on 1/31/17.
//  Copyright © 2017 Intercard Finance AD. All rights reserved.
//

#import "ICBaseCommand.h"
#import "MPCheckout.h"

@interface ICGetTransactionStatusCommand : ICBaseCommand

- (instancetype)initWithOrderId:(NSString *)orderId transactionType:(TransactionType)transactionType;

@end
