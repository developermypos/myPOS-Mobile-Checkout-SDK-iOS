//
//  ICCardView.h
//  MobilePaymentSDK
//
//  Created by Valio Cholakov on 1/31/17.
//  Copyright © 2017 Intercard Finance AD. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ICCardView : UIView

+ (instancetype)cardViewWithFrame:(CGRect)frame;

- (BOOL)isFilled;
- (NSString *)pan;
- (NSString *)cvc;
- (NSString *)expiryDate;
- (NSString *)embossName;
- (NSString *)customName;

@end
