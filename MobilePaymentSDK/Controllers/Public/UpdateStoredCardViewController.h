//
//  UpdateStoredCardViewController.h
//  MobilePaymentSDK
//
//  Created by Valio Cholakov on 1/31/17.
//  Copyright © 2017 Intercard Finance AD. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "MobilePaymentSDKProtocols.h"

@interface UpdateStoredCardViewController : UINavigationController

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
                                 delegate:(nullable id<StoreCardDelegate>)delegate;

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
                                 delegate:(nullable id<StoreCardDelegate>)delegate
                        withoutCustomName:(BOOL)withoutCustomName;

@end
