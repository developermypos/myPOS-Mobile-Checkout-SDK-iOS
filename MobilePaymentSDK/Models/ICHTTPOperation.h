//
//  ICHTTPOperation.h
//  MobilePaymentSDK
//
//  Created by Valio Cholakov on 1/31/17.
//  Copyright © 2017 Intercard Finance AD. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>

#import "MobilePaymentSDKError.h"

@class ICURLRequest;

typedef void (^ _Nullable ICHTTPOperatonSuccessBlock)(NSDictionary * _Nonnull response);
typedef void (^ _Nullable ICHTTPOperatonErrorBlock)(MobilePaymentSDKError * _Nonnull error);

@interface ICHTTPOperation : NSOperation

- (nullable instancetype)initWithRequest:(nonnull ICURLRequest *)request
                            successBlock:(nullable ICHTTPOperatonSuccessBlock)successBlock
                              errorBlock:(nullable ICHTTPOperatonErrorBlock)errorBlock;

@end
