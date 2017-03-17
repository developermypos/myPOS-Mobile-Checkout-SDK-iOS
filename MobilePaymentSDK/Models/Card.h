//
//  Card.h
//  MobilePaymentSDK
//
//  Created by Valio Cholakov on 1/31/17.
//  Copyright © 2017 Intercard Finance AD. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Card : NSObject

@property (nonatomic, strong, readonly) NSString *pan;
@property (nonatomic, strong, readonly) NSString *cvc;
@property (nonatomic, strong, readonly) NSString *embossName;
@property (nonatomic, strong, readonly) NSString *customName;

- (instancetype)initWithPan:(NSString *)pan
                 expiryDate:(NSString *)expiryDate
                        cvc:(NSString *)cvc
                 embossName:(NSString *)embossName
                 customName:(NSString *)customName;

- (NSString *)expiryMonth;
- (NSString *)expiryYear;
- (NSString *)expiryDate;

@end
