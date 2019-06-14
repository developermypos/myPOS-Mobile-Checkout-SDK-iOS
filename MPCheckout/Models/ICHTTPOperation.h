//
//  ICHTTPOperation.h
//  MPCheckout
//
//  Created by Valio Cholakov on 1/31/17.
//  Copyright © 2017 Intercard Finance AD. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>

#import "MPCheckoutError.h"

@class MPURLRequest;

typedef void (^ _Nullable ICHTTPOperatonSuccessBlock)(NSDictionary * _Nonnull response);
typedef void (^ _Nullable ICHTTPOperatonErrorBlock)(MPCheckoutError * _Nonnull error);

@interface ICHTTPOperation : NSOperation

- (nullable instancetype)initWithRequest:(nonnull MPURLRequest *)request
                            successBlock:(nullable ICHTTPOperatonSuccessBlock)successBlock
                              errorBlock:(nullable ICHTTPOperatonErrorBlock)errorBlock;

@end
