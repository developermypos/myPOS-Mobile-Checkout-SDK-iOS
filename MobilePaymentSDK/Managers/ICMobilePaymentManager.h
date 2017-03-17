//
//  ICMobilePaymentManager.h
//  MobilePaymentSDK
//
//  Created by Valio Cholakov on 1/31/17.
//  Copyright © 2017 Intercard Finance AD. All rights reserved.
//

#import "ICBaseManager.h"
#import "MobilePaymentSDK.h"

@class ICPrivateKey;

@interface ICMobilePaymentManager : ICBaseManager

@property (nonatomic, readonly) NSInteger keyIndex;
@property (nonatomic, readonly) SecKeyRef publicKey;
@property (nonatomic, strong, readonly) NSBundle *bundle;
@property (nonatomic, strong, readonly) NSString *storeId;
@property (nonatomic, strong, readonly) NSString *language;
@property (nonatomic, strong, readonly) NSString *currency;
@property (nonatomic, strong, readonly) NSString *walletNumber;

- (void)setWalletNumber:(NSString *)walletNumber
                storeId:(NSString *)storeId
               currency:(Currency)currency
              publicKey:(NSString *)publicKey
             privateKey:(NSString *)privateKey
                 bundle:(NSBundle *)bundle
               language:(NSString *)language
               keyIndex:(NSInteger)keyIndex;

- (BOOL)isInitialized;
- (ICPrivateKey *)privateKey;

@end
