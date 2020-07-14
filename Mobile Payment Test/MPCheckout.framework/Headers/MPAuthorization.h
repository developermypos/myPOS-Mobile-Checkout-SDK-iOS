//
//  MPAuthorization.h
//  MPCheckout
//
//  Created by Valio Cholakov on 10.07.20.
//  Copyright © 2020 Intercard Finance AD. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface MPAuthorization : NSObject

@property (nonatomic) CGFloat amount;
@property (nonatomic, strong) NSString *date;
@property (nonatomic, strong) NSString *currency;
@property (nonatomic, strong) NSString *orderId;
@property (nonatomic, strong) NSString *trnReference;

- (instancetype)initFromData:(NSDictionary *)data;

@end

NS_ASSUME_NONNULL_END
