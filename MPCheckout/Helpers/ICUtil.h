//
//  ICUtil.h
//  MPCheckout
//
//  Created by Valio Cholakov on 1/31/17.
//  Copyright © 2017 Intercard Finance AD. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>

@class MPCard;
@class MPCartItem;
@class ICPaymentViewController;
@class ICStoreCardViewController;
@class ICUpdateStoredCardViewController;
@class ICPreAuthorizationViewController;

@interface ICUtil : NSObject

+ (ICPaymentViewController *)paymentController;
+ (ICStoreCardViewController *)storeCardController;
+ (ICUpdateStoredCardViewController *)updateCardController;
+ (ICPreAuthorizationViewController *)preAuthorizationController;

+ (NSString *)signedData:(NSDictionary<NSString *, NSString *> *)data;
+ (NSString *)itemsTotalAmount:(NSArray<MPCartItem *> *)cartItems;
+ (NSURLRequest *)cardValidationURLRequest:(MPCard *)card
                                  cardData:(NSDictionary *)cardData
                                    amount:(NSString *)amount
                                     email:(NSString *)email;

@end
