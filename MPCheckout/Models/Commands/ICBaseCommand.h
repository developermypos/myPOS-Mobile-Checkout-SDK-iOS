//
//  ICBaseCommand.h
//  MPCheckout
//
//  Created by Valio Cholakov on 1/31/17.
//  Copyright © 2017 Intercard Finance AD. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>

#import "ICConstants.h"
#import "ICHelpers.h"
#import "ICMobilePaymentManager.h"

@interface ICBaseCommand : NSObject {
    NSMutableDictionary <NSString *, NSString *> *_data;
}

- (NSDictionary *)data;
- (NSString *)requestInfo;
- (NSString *)responseInfo;

@end
