//
//  ICReversalCommand.h
//  MobilePaymentSDK
//
//  Created by Valio Cholakov on 1/31/17.
//  Copyright © 2017 Intercard Finance AD. All rights reserved.
//

#import "ICBaseCommand.h"

@interface ICReversalCommand : ICBaseCommand

- (instancetype)initWithTransactionRef:(NSString *)transactionRef;

@end
