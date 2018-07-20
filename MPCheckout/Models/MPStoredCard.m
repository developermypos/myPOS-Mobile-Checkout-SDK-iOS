//
//  MPStoredCard.m
//  MPCheckout
//
//  Created by Valio Cholakov on 6/12/18.
//  Copyright © 2018 Intercard Finance AD. All rights reserved.
//

#import "MPStoredCard.h"

#import "NSString+Helpers.h"

@implementation MPStoredCard

- (instancetype)initWithCard:(MPCard *)card type:(NSString *)type token:(NSString *)token {
    if (self = [self init]) {
        _pan        = card.pan.shortPan;
        _type       = type;
        _token      = token;
        _expiryDate = card.expiryDate;
        _embossName = card.embossName;
        _customName = card.customName;
    }
    
    return self;
}

- (NSString *)description {
    return [NSString stringWithFormat:@"Stored Card {\r"
            "   pan = %@\r"
            "   type = %@\r"
            "   token = %@\r"
            "   expiry date = %@\r"
            "   emboss name = %@\r"
            "   custom name = %@\r"
            "}",
            self.pan,
            self.type,
            self.token,
            self.expiryDate,
            self.embossName,
            self.customName];
}

@end
