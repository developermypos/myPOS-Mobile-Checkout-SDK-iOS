//
//  MPCartItem.h
//  MPCheckout
//
//  Created by Valio Cholakov on 1/30/17.
//  Copyright © 2017 Intercard Finance AD. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MPCartItem : NSObject

@property (nonatomic, readonly) CGFloat price;
@property (nonatomic, readonly) NSInteger quantity;
@property (nonatomic, strong, readonly) NSString *name;

/*!
 * @method initWithName:price:cvc:quantity:
 *
 * @param name      The name of the cart item.
 * @param price     The price of the cart item.
 * @param quantity  The quantity of the cart item.
 *
 * @return          Returns an initialized CartItem object with the provided input parameters.
 */
- (instancetype)initWithName:(NSString *)name price:(CGFloat)price quantity:(NSInteger)quantity;

/*!
 * @method formattedData:
 *
 * @param number    The index of the cart item.
 *
 * @return          Returns a ready to send dictinary object with information about the cart item.
 */
- (NSDictionary <NSString *, NSString *> *)formattedData:(NSInteger)number;

@end
