//
//  Card.h
//  MobilePaymentSDK
//
//  Created by Valio Cholakov on 1/31/17.
//  Copyright © 2017 Intercard Finance AD. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Card : NSObject <NSCopying>

@property (nonatomic, strong, readonly) NSString *pan;
@property (nonatomic, strong, readonly) NSString *cvc;
@property (nonatomic, strong, readonly) NSString *embossName;
@property (nonatomic, strong, readonly) NSString *customName;

/*!
 * @method initWithPan:expiryDate:cvc:embossName:customName:
 *
 * @param pan           The pan of the credit/debit card.
 * @param expiryDate    The expiry date of the credit/debit card.
 * @param cvc           The cvc of the credit/debit card.
 * @param embossName    The emboss name on the credit/debit card.
 * @param customName    A custom name for reference.
 *
 * @return              Returns an initialized Card object with the provided input parameters.
 */
- (instancetype)initWithPan:(NSString *)pan
                 expiryDate:(NSString *)expiryDate
                        cvc:(NSString *)cvc
                 embossName:(NSString *)embossName
                 customName:(NSString *)customName;

/*!
 * @method expiryMonth
 *
 * @return Returns the expiry month of the credit/debit card.
 */
- (NSString *)expiryMonth;

/*!
 * @method expiryYear
 *
 * @return Returns the expiry year of the credit/debit card.
 */
- (NSString *)expiryYear;

/*!
 * @method expiryDate
 *
 * @return Returns the expiry date of the credit/debit card with format yymm
 */
- (NSString *)expiryDate;

@end
