//
//  ICApplicationManager.h
//  MobilePaymentSDK
//
//  Created by Valio Cholakov on 1/31/17.
//  Copyright © 2017 Intercard Finance AD. All rights reserved.
//

#import "ICBaseManager.h"

@interface ICApplicationManager : ICBaseManager

- (void)networkActivityDidStart;
- (void)networkActivityDidFinish;

@end
