//
//  MobilePaymentSDKProtocols.h
//  MobilePaymentSDK
//
//  Created by Valio Cholakov on 1/30/17.
//  Copyright © 2017 Intercard Finance AD. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MobilePaymentSDKError.h"
#import "StoredCard.h"

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
 * @method storeCardDidCompleteWithData:
 *
 * @param storedCard The stored card with all it's data.
 */
- (void)storeCardDidCompleteWithData:(nonnull StoredCard *)storedCard;

/*!
 * @method storeCardDidFailWithError:
 *
 * @param error Information about an error that occured while storing a card.
 */
- (void)storeCardDidFailWithError:(nonnull MobilePaymentSDKError *)error;

/*!
 * @method updateStoredCardDidCompleteWithData:forCardWithName:
 *
 * @param storedCard The updared stored card with all it's data.
 * @param cardToken  The old token of the successfully updated stored card.
 */
- (void)updateStoredCardDidCompleteWithData:(nonnull StoredCard *)storedCard forCardWithToken:(nonnull NSString *)cardToken;

/*!
 * @method updateStoredCardDidFailWithError:
 *
 * @param error Information about an error that occured while updating a stored card.
 */
- (void)updateStoredCardDidFailWithError:(nonnull MobilePaymentSDKError *)error;

@end
