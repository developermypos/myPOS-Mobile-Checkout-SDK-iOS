//
//  ICPurchaseWithTokenCommand.h
//  MPCheckout
//
//  Created by Ivaylo Zhelev on 13.03.23.
//  Copyright © 2023 Intercard Finance AD. All rights reserved.
//

#import "ICBaseCommand.h"

@interface ICPurchaseWithTokenCommand : ICBaseCommand

- (instancetype)initWithAmount:(NSString *)amount
               dsTransactionId:(NSString *)dsTransactionId
                tdsReferenceId:(NSString *)tdsReferenceId
               programProtocol:(NSString *)programProtocol
                     extraData:(NSDictionary *)extraData;

@end
