//
//  ICPurchaseCommand.h
//  MPCheckout
//
//  Created by Valio Cholakov on 1/31/17.
//  Copyright © 2017 Intercard Finance AD. All rights reserved.
//

#import "ICBaseCommand.h"

@interface ICPurchaseCommand : ICBaseCommand

- (instancetype)initWithAmount:(NSString *)amount
               dsTransactionId:(NSString *)dsTransactionId
               programProtocol:(NSString *)programProtocol
                  requestToken:(BOOL)requestToken
                     extraData:(NSDictionary *)extraData;

- (instancetype)initWithAmount:(NSString *)amount
                     extraData:(NSDictionary *)extraData;

@end
