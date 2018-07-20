//
//  MPUpdateStoredCardViewController.h
//  MPCheckout
//
//  Created by Valio Cholakov on 1/31/17.
//  Copyright © 2017 Intercard Finance AD. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "MPCheckoutController.h"
#import "MPCheckoutProtocols.h"

@interface MPUpdateStoredCardViewController : MPCheckoutController

/*!
 * @method initWithCardToken:verificationAmount:delegate:
 *
 * @param cardToken             The token of the stored card to be updated.
 * @param verificationAmount    A veritification amount.
 * @param delegate              A delegate to implement the StoreCardDelegate protocol methods.
 *
 * @see                         StoreCardDelegate
 */
- (nonnull instancetype)initWithCardToken:(nonnull NSString *)cardToken
                       verificationAmount:(CGFloat)verificationAmount
                                 delegate:(nullable id<MPStoreCardDelegate>)delegate;

/*!
 * @method initWithCardToken:verificationAmount:delegate:
 *
 * @param cardToken             The token of the stored card to be updated.
 * @param verificationAmount    A veritification amount.
 * @param delegate              A delegate to implement the StoreCardDelegate protocol methods.
 * @param withoutCustomName     An optional parameter whether to hide a field for custom card name Default is NO.
 *
 * @see                         StoreCardDelegate
 */
- (nonnull instancetype)initWithCardToken:(nonnull NSString *)cardToken
                       verificationAmount:(CGFloat)verificationAmount
                                 delegate:(nullable id<MPStoreCardDelegate>)delegate
                        withoutCustomName:(BOOL)withoutCustomName;

@end
