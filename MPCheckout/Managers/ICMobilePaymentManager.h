//
//  ICMobilePaymentManager.h
//  MPCheckout
//
//  Created by Valio Cholakov on 1/31/17.
//  Copyright © 2017 Intercard Finance AD. All rights reserved.
//

#import "ICBaseManager.h"
#import "MPCheckout.h"

@class ICPrivateKey;
@class ICCertificate;

@interface ICMobilePaymentManager : ICBaseManager

@property (nonatomic, readonly) NSInteger keyIndex;
@property (nonatomic, readonly) SecKeyRef publicKey;
@property (nonatomic, readonly) SecKeyRef privateKey;
@property (nonatomic, strong, readonly) NSBundle *bundle;
@property (nonatomic, strong, readonly) NSString *storeId;
@property (nonatomic, strong, readonly) NSString *language;
@property (nonatomic, strong, readonly) NSString *currency;
@property (nonatomic, strong, readonly) NSString *walletNumber;

- (void)setWalletNumber:(NSString *)walletNumber
                storeId:(NSString *)storeId
               currency:(MPCurrency)currency
              publicKey:(NSString *)publicKey
             privateKey:(NSString *)privateKey
                 bundle:(NSBundle *)bundle
               language:(NSString *)language
               keyIndex:(NSInteger)keyIndex
              inSandbox:(BOOL)inSandbox
   usesConfigurationKey:(BOOL)usesConfigurationKey;

- (BOOL)isInitialized;
- (BOOL)isInSandbox;
+ (NSString *)apiUrl;
+ (NSString *)secureUrl;

@end
