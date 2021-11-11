//
//  ICStoreCardCommand.h
//  MPCheckout
//
//  Created by Valio Cholakov on 1/31/17.
//  Copyright © 2017 Intercard Finance AD. All rights reserved.
//

#import "ICBaseCommand.h"

@interface ICStoreCardCommand : ICBaseCommand

- (instancetype)initWithPan:(NSString *)pan
                        cvc:(NSString *)cvc
                 expiryDate:(NSString *)expiryDate
                 embossName:(NSString *)embossName
                 customName:(NSString *)customName
                     amount:(NSString *)amount
                autoReverse:(BOOL)autoReverse
                  extraData:(NSDictionary *)extraData;

@end
