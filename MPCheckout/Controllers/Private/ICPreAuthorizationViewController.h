//
//  ICPreAuthorizationViewController.h
//  MPCheckout
//
//  Created by Valio Cholakov on 8.07.20.
//  Copyright © 2020 Intercard Finance AD. All rights reserved.
//

#import "ICCardViewController.h"

NS_ASSUME_NONNULL_BEGIN

@interface ICPreAuthorizationViewController : ICCardViewController

@property (nonatomic) CGFloat amount;
@property (nonatomic, strong) NSString *orderId;
@property (nonatomic, strong) NSString *itemName;

@end

NS_ASSUME_NONNULL_END
