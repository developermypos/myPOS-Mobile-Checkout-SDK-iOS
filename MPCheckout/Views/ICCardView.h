//
//  ICCardView.h
//  MPCheckout
//
//  Created by Valio Cholakov on 1/31/17.
//  Copyright © 2017 Intercard Finance AD. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ICCardView : UIView

+ (instancetype)cardViewWithFrame:(CGRect)frame withoutCustomName:(BOOL)withoutCustomName;

- (BOOL)withoutCustomName;
- (BOOL)isFilled;
- (BOOL)isValidEmail;
- (NSString *)pan;
- (NSString *)cvc;
- (NSString *)expiryDate;
- (NSString *)embossName;
- (NSString *)customName;
- (NSString *)email;

@end
