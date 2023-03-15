//
//  ICRSAManager.m
//  MPCheckout
//
//  Created by Valio Cholakov on 1/31/17.
//  Copyright © 2017 Intercard Finance AD. All rights reserved.
//

#import "ICRSAManager.h"
#import "CryptoUtil.h"
#import "ICLogger.h"
#import "ICConstants.h"
#import "ICMobilePaymentManager.h"
#import "ICASN.h"
#import "Base64.h"

@implementation ICRSAManager

#pragma mark - Singleton

+ (instancetype)sharedManager {
    static ICRSAManager *manager = nil;
    static dispatch_once_t onceToken;
    
    dispatch_once(&onceToken, ^{
        manager = [[self alloc] init];
    });
    
    return manager;
}

#pragma mark - Public Methods

- (NSString *)signString:(NSString *)string {
    if (!string) {
        [ICLogger log:@"Cannot sign nil"];
        return nil;
    }
    
    [ICLogger logDebug:[NSString stringWithFormat:@"Base64 data to sign: %@", string]];
    
    string = [[string componentsSeparatedByCharactersInSet:[NSCharacterSet newlineCharacterSet]] componentsJoinedByString:@""];
    [ICLogger logDebug:[NSString stringWithFormat:@"Base64 data to sign FIXED: %@", string]];
    
    SecKeyRef privateKey = [[ICMobilePaymentManager sharedManager] privateKey];
    
    if (!privateKey) {
        [ICLogger log:@"Could not load private key"];
        return nil;
    }
    
    NSData *signedData = [CryptoUtil signedString:string withKey:privateKey];
    
    if (!signedData) {
        [ICLogger logDebug:@"Signing error"];
        return nil;
    }
    
    return [signedData base64EncodedString];
}

- (BOOL)signatureIsValid:(NSString *)signedString plainString:(NSString *)plainString {
    if (!signedString || !plainString) {
        [ICLogger log:@"Cannot validate nil signature"];
        return NO;
    }
    
    if (signedString.length == 0) {
        [ICLogger log:@"Missing signature"];
        return NO;
    }
    
    SecKeyRef publicKey = [[ICMobilePaymentManager sharedManager] publicKey];
    
    if (!publicKey) {
        [ICLogger logDebug:@"Could not get public key"];
        return NO;
    }
    
    return [CryptoUtil signatureIsValid:signedString plain:plainString publicKey:publicKey];
}

- (NSString *)encryptedString:(NSString *)string {
    if (!string) {
        [ICLogger logDebug:@"Cannot encrypt nil"];
        return nil;
    }
    
    SecKeyRef publicKey = [[ICMobilePaymentManager sharedManager] publicKey];
    
    if (!publicKey) {
        [ICLogger logDebug:@"Could not get public key"];
        return nil;
    }
    
    NSData *encryptedString = [CryptoUtil encryptString:string withKey:publicKey padding:kSecPaddingPKCS1];
    
    if (!encryptedString) {
        [ICLogger logDebug:@"Encryption failed"];
        return nil;
    }
    
    string = [encryptedString base64EncodedString];
    string = [string stringByReplacingOccurrencesOfString:@"\n" withString:@""];
    
    return string;
}

- (NSString *)decryptedString:(NSString *)string {
    if (!string) {
        return nil;
    }
    
    SecKeyRef privateKey = [[ICMobilePaymentManager sharedManager] privateKey];
    
    if (!privateKey) {
        [ICLogger logDebug:@"Could not load private key"];
        return nil;
    }
    
    NSString *decryptedString = [CryptoUtil decryptString:string withKey:privateKey padding:kSecPaddingPKCS1];
    
    if (!decryptedString) {
        [ICLogger logDebug:@"Decryption failed"];
        return nil;
    }
    
    return decryptedString;
}

- (SecKeyRef)privateKeyFromFile:(NSData *)fileData {
    CFErrorRef error = NULL;
    SecKeyRef privateKey = SecKeyCreateWithData((CFDataRef)fileData, (CFDictionaryRef)[self attributesForRSAKey:kSecAttrKeyClassPrivate], &error);
    
    if (error != NULL) {
        NSLog(@"Invalid key data");
        CFRelease(error);
        return nil;
    }
    
    if (privateKey != NULL) {
        return privateKey;
    }
    
    NSLog(@"SecKeyCreateWithData failed without error");
    return nil;
}

- (SecKeyRef)publicKeyFromCertificate:(NSData *)certificateData {
    ICASN *asn = [[ICASN alloc] initWithData:certificateData];
    NSData *keyData = asn.keyData;
    
    if (!keyData || !keyData.length) {
        NSLog(@"Cannot extract key from certificate");
        return nil;
    }
    
    CFErrorRef error = NULL;
    SecKeyRef publicKey = SecKeyCreateWithData((CFDataRef)asn.keyData, (CFDictionaryRef)[self attributesForRSAKey:kSecAttrKeyClassPublic], &error);
    
    if (error != NULL) {
        NSLog(@"Invalid key data");
        CFRelease(error);
        return nil;
    }
    
    if (publicKey != NULL) {
        return publicKey;
    }
    
    NSLog(@"SecKeyCreateWithData failed without error");
    return nil;
}

#pragma mark - Helpers

- (NSDictionary *)attributesForRSAKey:(CFStringRef)keyClass {
    return @{
             (id)kSecAttrKeyType       : (id)kSecAttrKeyTypeRSA,
             (id)kSecAttrKeyClass      : (__bridge id)keyClass,
             (id)kSecAttrKeySizeInBits : [NSNumber numberWithInt:1024]
             };
}

@end

