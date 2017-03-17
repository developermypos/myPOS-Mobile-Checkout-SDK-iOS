//
//  ICURLRequest.h
//  MobilePaymentSDK
//
//  Created by Valio Cholakov on 1/31/17.
//  Copyright © 2017 Intercard Finance AD. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>

@interface ICURLRequest : NSURLRequest

- (instancetype)initWithBody:(NSData *)body;

- (NSURLRequest *)urlRequest;

@end
