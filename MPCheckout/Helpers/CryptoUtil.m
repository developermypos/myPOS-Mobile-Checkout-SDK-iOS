//
//  CryptoUtil.m
//  ICEncryptionUtils,
//
//  Created by Valio Cholakov on 1/3/17.
//  Copyright © 2017 Intercard Finance AD. All rights reserved.
//

#include <CommonCrypto/CommonDigest.h>

#import "CryptoUtil.h"
#import "Base64.h"

@implementation CryptoUtil

#pragma mark - Encrypt/Decrypt

+ (NSData *)encryptString:(NSString *)original withKey:(SecKeyRef)publicKey padding:(SecPadding)padding {
    @try {
        size_t encryptedLength = SecKeyGetBlockSize(publicKey);
        uint8_t encrypted[encryptedLength];
        
        const char* cStringValue = [original UTF8String];
        OSStatus status = SecKeyEncrypt(publicKey,
                                        padding,
                                        (const uint8_t*)cStringValue,
                                        strlen(cStringValue),
                                        encrypted,
                                        &encryptedLength);
        if (status != noErr) {
            NSLog(@"Encryption error: %d", (int)status);
            return nil;
        }
        
        return [[NSData alloc] initWithBytes:(const void*)encrypted length:encryptedLength];
    } @catch (NSException * exception) {
        NSLog(@"Exception: %@", exception);
    }
    
    return nil;
}

+ (NSString *)decryptString:(NSString *)encrypted withKey:(SecKeyRef)key padding:(SecPadding)padding {
    @try {
        NSData  *content    = [encrypted base64DecodedData];
        size_t  cipherLen   = [content length];
        void    *cipher     = malloc(cipherLen);
        
        [content getBytes:cipher length:cipherLen];
        
        size_t keyBufferSize = [content length];
        NSMutableData *bits  = [NSMutableData dataWithLength:keyBufferSize];
        OSStatus sanityCheck = SecKeyDecrypt(key,
                                             padding,
                                             cipher,
                                             cipherLen,
                                             [bits mutableBytes],
                                             &keyBufferSize);
        
        free(cipher);
        
        if (sanityCheck != noErr) {
            NSLog(@"Decryption error: %d", (int)sanityCheck);
            return nil;
        }
        
        [bits setLength:keyBufferSize];
        
        return [[NSString alloc] initWithData:bits encoding:NSUTF8StringEncoding];
    } @catch (NSException * exception) {
        NSLog(@"Exception: %@", exception);
    }
    
    return nil;
}

#pragma mark - Sign/Verify

+ (NSData *)signedString:(NSString *)string withKey:(SecKeyRef)privateKey {
    @try {
        NSData *plainData = [string dataUsingEncoding:NSUTF8StringEncoding];
        
        size_t   signedHashBytesSize = SecKeyGetBlockSize(privateKey);
        uint8_t* signedHashBytes     = malloc(signedHashBytesSize);
        
        memset(signedHashBytes, 0x0, signedHashBytesSize);
        
        size_t   hashBytesSize = CC_SHA256_DIGEST_LENGTH;
        uint8_t* hashBytes     = malloc(hashBytesSize);
        
        if (!CC_SHA256([plainData bytes], (CC_LONG)[plainData length], hashBytes)) {
            return nil;
        }
        
        OSStatus status = SecKeyRawSign(privateKey,
                                        kSecPaddingPKCS1SHA256,
                                        hashBytes,
                                        hashBytesSize,
                                        signedHashBytes,
                                        &signedHashBytesSize);
        
        if (status != noErr) {
            NSLog(@"Signing error: %d", (int)status);
            return nil;
        }
        
        NSData *signedHash = [NSData dataWithBytes:signedHashBytes length:(NSUInteger)signedHashBytesSize];
        
        if (hashBytes) {
            free(hashBytes);
        }
        
        if (signedHashBytes) {
            free(signedHashBytes);
        }
        
        return signedHash;
    } @catch (NSException *exception) {
        NSLog(@"Exception: %@", exception);
    }
    
    return nil;
}

+ (BOOL)signatureIsValid:(NSString *)signature plain:(NSString *)plain publicKey:(SecKeyRef)publicKey {
    NSData *plainData = [plain dataUsingEncoding:NSUTF8StringEncoding];
    
    size_t      signedHashBytesSize = SecKeyGetBlockSize(publicKey);
    const void* signedHashBytes     = [[signature base64DecodedData] bytes];
    
    size_t   hashBytesSize = CC_SHA256_DIGEST_LENGTH;
    uint8_t* hashBytes     = malloc(hashBytesSize);
    
    if (!CC_SHA256([plainData bytes], (CC_LONG)[plainData length], hashBytes)) {
        return NO;
    }
    
    OSStatus status = SecKeyRawVerify(publicKey,
                                      kSecPaddingPKCS1SHA256,
                                      hashBytes,
                                      hashBytesSize,
                                      signedHashBytes,
                                      signedHashBytesSize);
    
    return status == errSecSuccess;
}

@end
