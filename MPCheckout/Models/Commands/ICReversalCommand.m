//
//  ICReversalCommand.m
//  MPCheckout
//
//  Created by Valio Cholakov on 1/31/17.
//  Copyright © 2017 Intercard Finance AD. All rights reserved.
//

#import "ICReversalCommand.h"

@implementation ICReversalCommand

#pragma mark - Initialziers

- (instancetype)initWithTransactionRef:(NSString *)transactionRef {
    if (self = [super init]) {
        [_data setObject:transactionRef   forKey:ICParameterTransactionRef];
        [_data setObject:ICMethodReversal forKey:ICParameterMethod];
    }
    
    return self;
}

#pragma mark - Abstract Methods

- (NSString *)requestInfo {
    NSString *transactionRef = [_data objectForKey:ICParameterTransactionRef];
    
    if (!transactionRef) {
        return [super requestInfo];
    }
    
    return [NSString stringWithFormat:@"Reversal request for transaction %@ has been sent", transactionRef];
}

- (NSString *)responseInfo {
    NSString *transactionRef = [_data objectForKey:ICParameterTransactionRef];
    
    if (!transactionRef) {
        return [super requestInfo];
    }
    
    return [NSString stringWithFormat:@"Received response for reversal of %@", transactionRef];
}

@end
