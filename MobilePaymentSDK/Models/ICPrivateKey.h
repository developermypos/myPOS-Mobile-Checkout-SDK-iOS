//
//  ICPrivateKey.h
//  MobilePaymentSDK
//
//  Created by Valio Cholakov on 3/16/17.
//  Copyright © 2017 Intercard Finance AD. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>

@interface ICPrivateKey : NSObject

- (instancetype)initWithData:(NSData *)data;

@property (nonatomic, readonly) SecKeyRef reference;
@property (nonatomic, strong, readonly) NSString *tag;

@end
