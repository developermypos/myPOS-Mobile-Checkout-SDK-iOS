//
//  MPCard.m
//  MPCheckout
//
//  Created by Valio Cholakov on 1/31/17.
//  Copyright © 2017 Intercard Finance AD. All rights reserved.
//

#import "MPCard.h"

@interface MPCard() {
    NSString *_expiryDate;
}

@end

@implementation MPCard

#pragma mark - Initializers

- (instancetype)initWithPan:(NSString *)pan
                 expiryDate:(NSString *)expiryDate
                        cvc:(NSString *)cvc
                 embossName:(NSString *)embossName
                 customName:(NSString *)customName
                      email:(NSString *)email{
    if (self = [super init]) {
        _pan        = pan;
        _cvc        = cvc;
        _embossName = embossName;
        _customName = customName;
        _expiryDate = expiryDate;
        _email      = email;
    }
    
    return self;
}

- (instancetype)initWithCard:(MPCard *)card {
    return [[MPCard alloc] initWithPan:card.pan
                          expiryDate:card.expiryDate
                                 cvc:card.cvc
                          embossName:card.embossName
                          customName:card.customName
                               email:card.email];
}

- (instancetype)copy {
    return [self copyWithZone:nil];
}

- (instancetype)copyWithZone:(NSZone *)zone {
    return [[MPCard allocWithZone:zone] initWithCard:self];
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
