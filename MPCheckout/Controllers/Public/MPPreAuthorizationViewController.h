//
//  MPPreAuthorizationViewController.h
//  MPCheckout
//
//  Created by Valio Cholakov on 9.07.20.
//  Copyright © 2020 Intercard Finance AD. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "MPCartItem.h"
#import "MPCheckoutController.h"
#import "MPCheckoutProtocols.h"

NS_ASSUME_NONNULL_BEGIN

@interface MPPreAuthorizationViewController : MPCheckoutController

/*!
 * @method initWithCartItems:orderId:delegate:
 *
 * @param itemName The name of the item.
 * @param orderId    A custom order id for reference.
 * @param delegate  A delegate to implement the PaymentDelegate protocol methods.
 *
 * @seealso         PaymentDelegate
 */
- (nonnull instancetype)initWithItemName:(nonnull NSString *)itemName
                                  amount:(CGFloat)amount
                                  orderId:(nonnull NSString *)orderId
                                 delegate:(nullable id<MPPaymentDelegate>)delegate;

@end

NS_ASSUME_NONNULL_END
