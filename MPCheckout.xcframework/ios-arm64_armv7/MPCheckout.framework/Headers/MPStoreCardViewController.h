//
//  MPStoreCardViewController.h
//  MPCheckout
//
//  Created by Valio Cholakov on 1/31/17.
//  Copyright © 2017 Intercard Finance AD. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "MPCheckoutController.h"
#import "MPCheckoutProtocols.h"

@interface MPStoreCardViewController : MPCheckoutController

/*!
 * @method initWithVerificationAmount:delegate:
 *
 * @param verificationAmount    A veritification amount.
 * @param delegate              A delegate to implement the StoreCardDelegate protocol methods.
 *
 * @see                         StoreCardDelegate
 */
- (nonnull instancetype)initWithVerificationAmount:(CGFloat)verificationAmount
                                          delegate:(nullable id<MPStoreCardDelegate>)delegate;

/*!
 * @method initWithVerificationAmount:delegate:
 *
 * @param verificationAmount    A veritification amount.
 * @param delegate              A delegate to implement the StoreCardDelegate protocol methods.
 * @param withoutCustomName     An optional parameter whether to hide a field for custom card name Default is NO.
 *
 * @see                         StoreCardDelegate
 */
- (nonnull instancetype)initWithVerificationAmount:(CGFloat)verificationAmount
                                          delegate:(nullable id<MPStoreCardDelegate>)delegate
                                 withoutCustomName:(BOOL)withoutCustomName;

@end
