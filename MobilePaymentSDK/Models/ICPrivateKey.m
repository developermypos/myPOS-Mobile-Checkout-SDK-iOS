//
//  ICPrivateKey.m
//  MobilePaymentSDK
//
//  Created by Valio Cholakov on 3/16/17.
//  Copyright © 2017 Intercard Finance AD. All rights reserved.
//

#import "ICPrivateKey.h"
#import "ICRSAManager.h"

@implementation ICPrivateKey

#pragma mark - Initializers

- (instancetype)initWithData:(NSData *)keyData {
    if (self = [super init]) {
        _tag       = [self uuid];
        _reference = [[ICRSAManager sharedManager] addKey:keyData withTag:_tag isPublic:NO];
    }
    
    return _reference == nil ? nil : self;
}

#pragma mark - Helpers

- (NSString *)uuid {
    CFUUIDRef theUUID  = CFUUIDCreate(NULL);
    CFStringRef string = CFUUIDCreateString(NULL, theUUID);
    CFRelease(theUUID);
    
    return (__bridge NSString *)string;
}

@end
