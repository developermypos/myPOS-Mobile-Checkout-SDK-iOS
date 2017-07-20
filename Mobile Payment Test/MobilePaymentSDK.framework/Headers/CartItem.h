//
//  CartItem.h
//  MobilePaymentSDK
//
//  Created by Valio Cholakov on 1/30/17.
//  Copyright © 2017 Intercard Finance AD. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CartItem : NSObject

@property (nonatomic, readonly) CGFloat price;
@property (nonatomic, readonly) NSInteger quantity;
@property (nonatomic, strong, readonly) NSString *name;

- (instancetype)initWithName:(NSString *)name price:(CGFloat)price quantity:(NSInteger)quantity;

- (NSDictionary <NSString *, NSString *> *)formattedData:(NSInteger)number;

@end
