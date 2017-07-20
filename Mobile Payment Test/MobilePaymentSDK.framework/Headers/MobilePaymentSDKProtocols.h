//
//  MobilePaymentSDKProtocols.h
//  MobilePaymentSDK
//
//  Created by Valio Cholakov on 1/30/17.
//  Copyright © 2017 Intercard Finance AD. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MobilePaymentSDKError.h"

@protocol PaymentDelegate <NSObject>

/*!
 * @method paymentDidCompleteWithReference:
 *
 * @param transactionReference  The reference of the successfull transaction.
 */
- (void)paymentDidCompleteWithReference:(nonnull NSString *)transactionReference;

/*!
 * @method paymentDidFailWithError:
 *
 * @param error Information about an error that occured during a payment.
 */
- (void)paymentDidFailWithError:(nonnull MobilePaymentSDKError *)error;

@end

@protocol StoreCardDelegate <NSObject>

/*!
 * @method storeCardDidCompleteWithToken:forCardWithName:
 *
 * @param cardToken The token of the successfully stored card.
 * @param cardName  The custom name of the successfully stored card.
 */
- (void)storeCardDidCompleteWithToken:(nonnull NSString *)cardToken forCardWithName:(nonnull NSString *)cardName;

/*!
 * @method storeCardDidFailWithError:
 *
 * @param error Information about an error that occured while storing a card.
 */
- (void)storeCardDidFailWithError:(nonnull MobilePaymentSDKError *)error;

/*!
 * @method updateStoredCardDidCompleteWithToken:forCardWithName:
 *
 * @param cardToken The token of the successfully updated stored card.
 * @param cardName  The custom name of the successfully updated stored card.
 */
- (void)updateStoredCardDidCompleteWithToken:(nonnull NSString *)cardToken forCardWithName:(nonnull NSString *)cardName;

/*!
 * @method updateStoredCardDidFailWithError:
 *
 * @param error Information about an error that occured while updating a stored card.
 */
- (void)updateStoredCardDidFailWithError:(nonnull MobilePaymentSDKError *)error;

@end
