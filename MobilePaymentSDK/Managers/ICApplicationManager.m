//
//  ICApplicationManager.m
//  MobilePaymentSDK
//
//  Created by Valio Cholakov on 1/31/17.
//  Copyright © 2017 Intercard Finance AD. All rights reserved.
//

#import "ICApplicationManager.h"

@interface ICApplicationManager() {
    NSInteger _processingCommands;
}

@end

@implementation ICApplicationManager


#pragma mark - Singleton

+ (instancetype)sharedManager {
    static ICApplicationManager *manager = nil;
    static dispatch_once_t onceToken;
    
    dispatch_once(&onceToken, ^{
        manager = [[self alloc] init];
    });
    
    return manager;
}

#pragma mark - Public Methods

- (void)networkActivityDidStart {
    _processingCommands++;
    [self updateNetworkActivityIndocator];
}

- (void)networkActivityDidFinish {
    _processingCommands--;
    [self updateNetworkActivityIndocator];
}

#pragma mark - Private Methods

- (void)updateNetworkActivityIndocator {
    if (_processingCommands < 0) {
        _processingCommands = 0;
    }
    
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:_processingCommands > 0];
}

@end
