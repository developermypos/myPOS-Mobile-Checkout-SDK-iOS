//
//  ICAuthorizationListCommand.m
//  MPCheckout
//
//  Created by Valio Cholakov on 10.07.20.
//  Copyright © 2020 Intercard Finance AD. All rights reserved.
//

#import "ICAuthorizationListCommand.h"

@implementation ICAuthorizationListCommand

#pragma mark - Initialziers

- (instancetype)init {
    
    if (self = [super init]) {
        [_data setObject:ICMethodListAuthorizations forKey:ICParameterMethod];
    }
    
    return self;
}

#pragma mark - Abstract Methods

- (NSString *)requestInfo {
    return @"List authorization request has been sent";
}

- (NSString *)responseInfo {
    NSArray *authorizations = [_data objectForKey:ICParameterAuthorization];
    
    if (!authorizations) {
        return [super responseInfo];
    }
    
    return [NSString stringWithFormat:@"Response for list authorizations request has been received: %@", authorizations];
}

@end
