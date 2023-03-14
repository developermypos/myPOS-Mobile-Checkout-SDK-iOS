//
//  ICCardViewController.h
//  MPCheckout
//
//  Created by Valio Cholakov on 1/31/17.
//  Copyright © 2017 Intercard Finance AD. All rights reserved.
//

#import "ICBaseViewController.h"
#import "IC3DSecureWebViewController.h"

#import "ICCardView.h"

#import "MPCard.h"
#import "ICUtil.h"
#import "ICLogger.h"
#import "ICHelpers.h"
#import "ICConstants.h"

#import "ICCommunicationManager.h"
#import "ICMobilePaymentManager.h"

@class ICCardView;

@interface ICCardViewController : ICBaseViewController <IC3DSecureDelegate> {
    ICCardView *_cardView;
    
    NSDictionary<NSString *, NSString *> *_cardData;
    NSDictionary<NSString *, NSString *> *_extraData;
}

@property (weak, nonatomic) IBOutlet UIBarButtonItem *cancelButton;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *confirmButton;
@property (weak, nonatomic) IBOutlet UIView *contentView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *cardViewHeight;

@property (nonatomic) BOOL withoutCustomName;
@property (nonatomic) BOOL autoReverse;
@property (nonatomic) BOOL forceTDS;
@property (weak, nonatomic) id<MPPaymentDelegate> paymentDelegate;
@property (weak, nonatomic) id<MPStoreCardDelegate> storeCardDelegate;

@property (nonatomic) CGFloat cardVerificationAmount;

- (MPCard *)card;

- (void)dismiss:(void (^)(void))completion;

@end
