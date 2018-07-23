//
//  MPStoredCard.h
//  MPCheckout
//
//  Created by Valio Cholakov on 6/12/18.
//  Copyright © 2018 Intercard Finance AD. All rights reserved.
//

#import "MPCard.h"

@interface MPStoredCard : NSObject

@property (nonatomic, strong, readonly, nonnull) NSString *pan;
@property (nonatomic, strong, readonly, nonnull) NSString *type;
@property (nonatomic, strong, readonly, nonnull) NSString *token;
@property (nonatomic, strong, readonly, nonnull) NSString *expiryDate;
@property (nonatomic, strong, readonly, nonnull) NSString *embossName;
@property (nonatomic, strong, readonly, nonnull) NSString *customName;

/*!
 * @method initWithCard:type:token:
 *
 * @param card  The card used in the store card request.
 * @param type  The type of the card.
 * @param token The stored card token.

 *
 * @return      An initialized StoredCard object from the provided input parameters.
 */

- (nullable instancetype)initWithCard:(nonnull MPCard *)card type:(nonnull NSString *)type token:(nonnull NSString *)token;

@end
