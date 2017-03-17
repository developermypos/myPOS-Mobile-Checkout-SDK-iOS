//
//  ICRefundCommand.h
//  MobilePaymentSDK
//
//  Created by Valio Cholakov on 1/31/17.
//  Copyright © 2017 Intercard Finance AD. All rights reserved.
//

#import "ICBaseCommand.h"

@interface ICRefundCommand : ICBaseCommand

- (instancetype)initWithTransactionRef:(NSString *)transactionRef orderId:(NSString *)orderId amount:(NSString *)amount;

@end
