//
//  ICPaymentViewController.h
//  MobilePaymentSDK
//
//  Created by Valio Cholakov on 1/31/17.
//  Copyright © 2017 Intercard Finance AD. All rights reserved.
//

#import "ICCardViewController.h"

@interface ICPaymentViewController : ICCardViewController

@property (nonatomic, strong) NSArray<CartItem *> *cartItems;
@property (nonatomic, strong) NSString *orderId;
@property (nonatomic, strong) NSString *cardToken;

@end
