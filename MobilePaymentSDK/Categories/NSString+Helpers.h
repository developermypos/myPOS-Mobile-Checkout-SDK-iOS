//
//  NSString+Helpers.h
//  MobilePaymentSDK
//
//  Created by Valio Cholakov on 1/30/17.
//  Copyright © 2017 Intercard Finance AD. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (Helpers)

- (BOOL)matchesRegEx:(NSString *)regEx;
- (BOOL)isValidSignatureOf:(NSString *)plainText;

- (NSString *)trimmed;
- (NSString *)encrypted;
- (NSString *)decrypted;
- (NSString *)signature;
- (NSString *)urlEncoded;
- (NSString *)urlDecoded;
+ (NSString *)uuid;

@end
