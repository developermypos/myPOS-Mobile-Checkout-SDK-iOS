//
//  ICUpdateStoredCardCommand.h
//  MPCheckout
//
//  Created by Valio Cholakov on 1/31/17.
//  Copyright © 2017 Intercard Finance AD. All rights reserved.
//

#import "ICStoreCardCommand.h"

@interface ICUpdateStoredCardCommand : ICStoreCardCommand

- (instancetype)initWithToken:(NSString *)token
                          pan:(NSString *)pan
                          cvc:(NSString *)cvc
                   expiryDate:(NSString *)expiryDate
                   embossName:(NSString *)embossName
                   customName:(NSString *)customName
                       amount:(NSString *)amount
                    extraData:(NSDictionary *)extraData;

@end
