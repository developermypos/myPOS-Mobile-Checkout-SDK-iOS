//
//  ICCardView.h
//  MobilePaymentSDK
//
//  Created by Valio Cholakov on 1/31/17.
//  Copyright © 2017 Intercard Finance AD. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ICThemedTextField;
@class TPKeyboardAvoidingScrollView;

@protocol ICCardViewDelegate <NSObject>

@end

@interface ICCardView : UIView

@property (weak, nonatomic) id<ICCardViewDelegate> delegate;

+ (instancetype)cardViewWithFrame:(CGRect)frame;

- (NSString *)pan;
- (NSString *)cvc;
- (NSString *)expiryDate;
- (NSString *)embossName;
- (NSString *)customName;

@end
