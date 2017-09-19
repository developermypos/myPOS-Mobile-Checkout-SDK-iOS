//
//  ICURLRequest.m
//  MobilePaymentSDK
//
//  Created by Valio Cholakov on 1/31/17.
//  Copyright © 2017 Intercard Finance AD. All rights reserved.
//

#import "ICURLRequest.h"
#import "ICConstants.h"
#import "ICMobilePaymentManager.h"

@interface ICURLRequest() {
    NSMutableURLRequest *_urlRequest;
}

@end

@implementation ICURLRequest

#pragma mark - Initializers

- (instancetype)initWithBody:(NSData *)body {
    if (self = [super init]) {
        _urlRequest = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:[ICMobilePaymentManager apiUrl]]];
        
        [_urlRequest setHTTPBody:body];
        [_urlRequest setHTTPMethod:ICHTTPMethodPOST];
        [_urlRequest setValue:kURLEncoded forHTTPHeaderField:kContentType];
    }
    
    return self;
}

#pragma mark - Public Methods

- (NSURLRequest *)urlRequest {
    return (NSURLRequest *)_urlRequest;
}

@end
