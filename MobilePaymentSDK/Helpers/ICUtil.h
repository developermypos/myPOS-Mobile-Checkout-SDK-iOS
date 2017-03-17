//
//  ICUtil.h
//  MobilePaymentSDK
//
//  Created by Valio Cholakov on 1/31/17.
//  Copyright © 2017 Intercard Finance AD. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>

@class Card;
@class CartItem;
@class ICPaymentViewController;
@class ICStoreCardViewController;
@class ICUpdateStoredCardViewController;

@interface ICUtil : NSObject

+ (ICPaymentViewController *)paymentController;
+ (ICStoreCardViewController *)storeCardController;
+ (ICUpdateStoredCardViewController *)updateCardController;

+ (NSString *)signedData:(NSDictionary<NSString *, NSString *> *)data;
+ (NSString *)itemsTotalAmount:(NSArray<CartItem *> *)cartItems;
+ (NSURLRequest *)cardValidationURLRequest:(Card *)card cardData:(NSDictionary *)cardData amount:(NSString *)amount;

@end
