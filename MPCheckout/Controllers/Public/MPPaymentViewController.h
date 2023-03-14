//
//  MPPaymentViewController.h
//  MPCheckout
//
//  Created by Valio Cholakov on 1/31/17.
//  Copyright © 2017 Intercard Finance AD. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "MPCartItem.h"
#import "MPCheckoutController.h"
#import "MPCheckoutProtocols.h"

@interface MPPaymentViewController : MPCheckoutController

/*!
 * @method initWithCartItems:orderId:delegate:
 *
 * @param cartItems An array of CartItem objects.
 * @param orderId   A custom order id for reference.
 * @param delegate  A delegate to implement the PaymentDelegate protocol methods.
 *
 * @see             CartItem
 * @seealso         PaymentDelegate
 */
- (nonnull instancetype)initWithCartItems:(nonnull NSArray<MPCartItem *> *)cartItems
                                  orderId:(nonnull NSString *)orderId
                             requestToken:(BOOL)requestToken
                                 delegate:(nullable id<MPPaymentDelegate>)delegate;

/*!
 * @method initWithCartItems:orderId:cardToken:delegate:
 *
 * @param cartItems An array of CartItem objects.
 * @param orderId   A custom order id for reference.
 * @param cardToken The token of the stored card.
 * @param delegate  A delegate to implement the PaymentDelegate protocol methods.
 *
 * @see             CartItem
 * @seealso         PaymentDelegate
 */
- (nonnull instancetype)initWithCartItems:(nonnull NSArray<MPCartItem *> *)cartItems
                                  orderId:(nonnull NSString *)orderId
                                cardToken:(nonnull NSString *)cardToken
                                 forceTDS:(BOOL)forceTDS
                                 delegate:(nullable id<MPPaymentDelegate>)delegate;

@end
