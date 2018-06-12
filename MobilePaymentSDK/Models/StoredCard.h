//
//  StoredCard.h
//  MobilePaymentSDK
//
//  Created by Valio Cholakov on 6/12/18.
//  Copyright © 2018 Intercard Finance AD. All rights reserved.
//

#import "Card.h"

@interface StoredCard : NSObject

@property (nonatomic, strong, readonly) NSString *pan;
@property (nonatomic, strong, readonly) NSString *type;
@property (nonatomic, strong, readonly) NSString *token;
@property (nonatomic, strong, readonly) NSString *expiryDate;
@property (nonatomic, strong, readonly) NSString *embossName;
@property (nonatomic, strong, readonly) NSString *customName;

/*!
 * @method initWithCard:type:token:
 *
 * @param card  The card used in the store card request.
 * @param type  The type of the card.
 * @param token The stored card token.

 *
 * @return      Returns an initialized StoredCard object from the provided input parameters.
 */

- (instancetype)initWithCard:(Card *)card type:(NSString *)type token:(NSString *)token;

@end
