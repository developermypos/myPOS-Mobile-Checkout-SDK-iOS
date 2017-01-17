//
//  CryptoUtil.h
//  ICEncryptionUtils,
//
//  Created by Valio Cholakov on 1/3/17.
//  Copyright © 2017 Intercard Finance AD. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CryptoUtil : NSObject

+ (nullable NSData *)encryptString:(nonnull NSString *)original withKey:(nonnull SecKeyRef)publicKey padding:(SecPadding)padding;
+ (nullable NSString *)decryptString:(nonnull NSString *)encrypted withKey:(nonnull SecKeyRef)key padding:(SecPadding)padding;

+ (nullable NSString *)signedString:(nonnull NSString *)string withKey:(nonnull SecKeyRef)privateKey;
+ (BOOL)signatureIsValid:(nonnull NSString *)signature plain:(nonnull NSString *)plain publicKey:(nonnull SecKeyRef)publicKey;

@end
