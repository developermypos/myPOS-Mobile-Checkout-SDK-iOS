//
//  Card.m
//  MobilePaymentSDK
//
//  Created by Valio Cholakov on 1/31/17.
//  Copyright © 2017 Intercard Finance AD. All rights reserved.
//

#import "Card.h"

@interface Card() {
    NSString *_expiryDate;
}

@end

@implementation Card

#pragma mark - Initializers

- (instancetype)initWithPan:(NSString *)pan
                 expiryDate:(NSString *)expiryDate
                        cvc:(NSString *)cvc
                 embossName:(NSString *)embossName
                 customName:(NSString *)customName {
    if (self = [super init]) {
        _pan        = pan;
        _cvc        = cvc;
        _embossName = embossName;
        _customName = customName;
        _expiryDate = expiryDate;
    }
    
    return self;
}

- (void)dealloc {
    _expiryDate = nil;
}

#pragma mark - Public Methods

- (NSString *)expiryMonth {
    return [_expiryDate substringToIndex:2];
}

- (NSString *)expiryYear {
    return [_expiryDate substringFromIndex:_expiryDate.length - 2];
}

- (NSString *)expiryDate {
    return [NSString stringWithFormat:@"%@%@", [self expiryYear], [self expiryMonth]];
}

@end
