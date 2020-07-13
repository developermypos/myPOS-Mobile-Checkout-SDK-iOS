//
//  ICGetPreAuthorizationStatusCommand.h
//  MPCheckout
//
//  Created by Valio Cholakov on 9.07.20.
//  Copyright © 2020 Intercard Finance AD. All rights reserved.
//

#import "ICBaseCommand.h"

NS_ASSUME_NONNULL_BEGIN

@interface ICGetPreAuthorizationStatusCommand : ICBaseCommand

- (instancetype)initWithOrderId:(NSString * _Nonnull)orderId;

@end

NS_ASSUME_NONNULL_END
