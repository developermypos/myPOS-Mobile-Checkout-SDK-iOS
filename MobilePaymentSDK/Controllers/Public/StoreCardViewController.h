//
//  StoreCardViewController.h
//  MobilePaymentSDK
//
//  Created by Valio Cholakov on 1/31/17.
//  Copyright © 2017 Intercard Finance AD. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "MobilePaymentSDKProtocols.h"

@interface StoreCardViewController : UINavigationController

/*!
 * @method initWithVerificationAmount:delegate:
 *
 * @param verificationAmount    A veritification amount.
 * @param delegate              A delegate to implement the StoreCardDelegate protocol methods.
 *
 * @see                         StoreCardDelegate
 */
- (nonnull instancetype)initWithVerificationAmount:(CGFloat)verificationAmount delegate:(nullable id<StoreCardDelegate>)delegate;

@end
