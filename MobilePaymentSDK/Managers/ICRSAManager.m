//
//  ICRSAManager.m
//  MobilePaymentSDK
//
//  Created by Valio Cholakov on 1/31/17.
//  Copyright © 2017 Intercard Finance AD. All rights reserved.
//

#import "ICRSAManager.h"
#import "CryptoUtil.h"
#import "ICLogger.h"
#import "ICPrivateKey.h"
#import "ICMobilePaymentManager.h"

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
    
    [ICLogger log:[NSString stringWithFormat:@"Base64 data to sign: %@", string]];
    
    ICPrivateKey *privateKey = [[ICMobilePaymentManager sharedManager] privateKey];
    
    if (!privateKey) {
        [ICLogger log:@"Could not load private key"];
        return nil;
    }
    
    NSData *signedData = [CryptoUtil signedString:string withKey:privateKey.reference];
    
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
    
    return [encryptedString base64EncodedString];
}

- (NSString *)decryptedString:(NSString *)string {
    if (!string) {
        return nil;
    }
    
    ICPrivateKey *privateKey = [[ICMobilePaymentManager sharedManager] privateKey];
    
    if (!privateKey) {
        [ICLogger logDebug:@"Could not load private key"];
        return nil;
    }
    
    NSString *decryptedString = [CryptoUtil decryptString:string withKey:privateKey.reference padding:kSecPaddingPKCS1];
    
    if (!decryptedString) {
        [ICLogger logDebug:@"Decryption failed"];
        return nil;
    }
    
    return decryptedString;
}

- (SecKeyRef)addKey:(NSData *)keyData withTag:(NSString *)tag isPublic:(BOOL)isPublic {
    if (!keyData) {
        return nil;
    }
    
    NSData *tagData = [tag dataUsingEncoding:NSUTF8StringEncoding];
    
    if (!tagData) {
        [ICLogger logDebug:[NSString stringWithFormat:@"Couldn't create tag data for %@ key", isPublic ? @"public" : @"private"]];
        return nil;
    }
    
    id keyClass = isPublic ? (id)kSecAttrKeyClassPublic : (id)kSecAttrKeyClassPrivate;
    
    CFTypeRef ref;
    NSDictionary *keyAddDict = @{
                                 (id)kSecClass               : (id)kSecClassKey,
                                 (id)kSecValueData           : keyData,
                                 (id)kSecAttrKeyType         : (id)kSecAttrKeyTypeRSA,
                                 (id)kSecAttrKeyClass        : keyClass,
                                 (id)kSecAttrAccessible      : (id)kSecAttrAccessibleWhenUnlocked,
                                 (id)kSecAttrApplicationTag  : tagData,
                                 (id)kSecReturnPersistentRef : [NSNumber numberWithBool:YES]
                                 };
    
    OSStatus status = SecItemAdd((CFDictionaryRef)keyAddDict, &ref);
    
    if (status != noErr && status != errSecDuplicateItem) {
        [ICLogger log:@"Provided key couldn't be added to the keychain"];
        return nil;
    }
    
    NSDictionary *keyCopyDict = @{
                                  (id)kSecClass              : (id)kSecClassKey,
                                  (id)kSecReturnRef          : [NSNumber numberWithBool:YES],
                                  (id)kSecAttrKeyType        : (id)kSecAttrKeyTypeRSA,
                                  (id)kSecAttrKeyClass       : keyClass,
                                  (id)kSecAttrAccessible     : (id)kSecAttrAccessibleWhenUnlocked,
                                  (id)kSecAttrApplicationTag : tagData
                                  };
    
    status = SecItemCopyMatching((CFDictionaryRef)keyCopyDict, &ref);
    
    if (!ref) {
        [ICLogger log:@"Couldn't get key reference from the keychain"];
        return nil;
    }
    
    return (SecKeyRef)ref;
}

- (void)removeKeyWithTag:(NSString *)tag {
    NSData *tagData = [tag dataUsingEncoding:NSUTF8StringEncoding];
    
    if (!tagData) {
        return;
    }
    
    NSDictionary *keyRemoveDict = @{
                                    (id)kSecClass              : (id)kSecClassKey,
                                    (id)kSecAttrKeyType        : (id)kSecAttrKeyTypeRSA,
                                    (id)kSecAttrApplicationTag : tagData
                                    };
    
    SecItemDelete((CFDictionaryRef)keyRemoveDict);
}

@end
