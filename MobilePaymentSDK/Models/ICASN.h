//
//  ICASN.h
//  MPCheckout
//
//  Created by Valio Cholakov on 9/21/17.
//  Copyright © 2017 Intercard Finance AD. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ICASN : NSObject

- (instancetype)initWithData:(NSData *)data;

- (NSData *)keyData;

@end
