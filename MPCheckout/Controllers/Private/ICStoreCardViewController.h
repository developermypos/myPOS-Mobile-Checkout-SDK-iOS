//
//  ICStoreCardViewController.h
//  MPCheckout
//
//  Created by Valio Cholakov on 1/31/17.
//  Copyright © 2017 Intercard Finance AD. All rights reserved.
//

#import "ICCardViewController.h"

@interface ICStoreCardViewController : ICCardViewController

@property (weak, nonatomic) id<MPStoreCardDelegate> delegate;

@end
