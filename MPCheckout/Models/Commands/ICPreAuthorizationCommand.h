//
//  ICPreAuthorizationCommand.h
//  MPCheckout
//
//  Created by Valio Cholakov on 8.07.20.
//  Copyright © 2020 Intercard Finance AD. All rights reserved.
//

#import "ICBaseCommand.h"

NS_ASSUME_NONNULL_BEGIN

@interface ICPreAuthorizationCommand : ICBaseCommand

- (instancetype)initWithAmount:(NSString *)amount extraData:(NSDictionary *)extraData dsTransactionId:(NSString *)dsTransactionId programProtocol:(NSString *)programProtocol;

@end

NS_ASSUME_NONNULL_END
