//
//  ICPaymentViewController.h
//  MPCheckout
//
//  Created by Valio Cholakov on 1/31/17.
//  Copyright © 2017 Intercard Finance AD. All rights reserved.
//

#import "ICCardViewController.h"

@interface ICPaymentViewController : ICCardViewController

@property (nonatomic, strong) NSArray<MPCartItem *> *cartItems;
@property (nonatomic, strong) NSString *orderId;
@property (nonatomic, strong) NSString *cardToken;
@property (nonatomic) BOOL requestToken;

@end
