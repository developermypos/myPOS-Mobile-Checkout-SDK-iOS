//
//  CartItem.m
//  MobilePaymentSDK
//
//  Created by Valio Cholakov on 1/30/17.
//  Copyright © 2017 Intercard Finance AD. All rights reserved.
//

#import "CartItem.h"
#import "ICConstants.h"
#import "ICHelpers.h"
#import "ICMobilePaymentManager.h"

#import "NSString+Helpers.h"

@implementation CartItem

#define ICParamName(name, number) [NSString stringWithFormat:@"%@_%@", name, [@(number) stringValue]]
#define ICFormattedPrice(price)   [NSString stringWithFormat:@"%.02f", price]

#pragma mark - Initialziers

- (instancetype)initWithName:(NSString *)name price:(CGFloat)price quantity:(NSInteger)quantity {
    if (self = [super init]) {
        _name     = name;
        _price    = price;
        _quantity = quantity;
    }
    
    return self;
}

#pragma mark - Public Methods

- (NSDictionary <NSString *, NSString *> *)formattedData:(NSInteger)number {
    return @{
             ICParamName(ICParameterArticle,  number) : self.name,
             ICParamName(ICParameterPrice,    number) : ICFormatterAmount(self.price),
             ICParamName(ICParameterQuantity, number) : ICIntegerToString(self.quantity),
             ICParamName(ICParameterAmount,   number) : self.amount,
             ICParamName(ICParameterCurrency, number) : [[ICMobilePaymentManager sharedManager] currency]
             };
}

#pragma mark - Private Methods

- (NSString *)amount {
    return [NSString stringWithFormat:@"%.02f", self.price * self.quantity];
}

#pragma mark - Description

- (NSString *)description {
    return [NSString stringWithFormat:@"Cart item {"
            "   name = %@\r"
            "   price = %f\r"
            "   quantity = %ld\r"
            "}",
            self.name,
            self.price,
            (long)self.quantity];
}

@end
