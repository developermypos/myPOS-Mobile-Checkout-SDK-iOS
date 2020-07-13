//
//  ICAuthorizationCommand.h
//  MPCheckout
//
//  Created by Valio Cholakov on 10.07.20.
//  Copyright © 2020 Intercard Finance AD. All rights reserved.
//

#import "ICBaseCommand.h"

NS_ASSUME_NONNULL_BEGIN

@interface ICAuthorizationCommand : ICBaseCommand

- (nullable instancetype)initWithAmount:(nonnull NSString *)amount
                                orderId:(nonnull NSString *)orderId
                               itemName:(nonnull NSString *)itemName
                              cardToken:(nonnull NSString *)cardToken;

@end

NS_ASSUME_NONNULL_END
