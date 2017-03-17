//
//  ICGetCardDataCommand.h
//  MobilePaymentSDK
//
//  Created by Valio Cholakov on 1/31/17.
//  Copyright © 2017 Intercard Finance AD. All rights reserved.
//

#import "ICBaseCommand.h"

@interface ICGetCardDataCommand : ICBaseCommand

- (instancetype)initWithPan:(NSString *)pan;

@end
