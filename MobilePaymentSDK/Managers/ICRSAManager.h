//
//  ICRSAManager.h
//  MobilePaymentSDK
//
//  Created by Valio Cholakov on 1/31/17.
//  Copyright © 2017 Intercard Finance AD. All rights reserved.
//

#import "ICBaseManager.h"

@interface ICRSAManager : ICBaseManager

- (NSString *)signString:(NSString *)string;
- (BOOL)signatureIsValid:(NSString *)signedString plainString:(NSString *)plainString;
- (NSString *)encryptedString:(NSString *)string;
- (NSString *)decryptedString:(NSString *)string;

- (SecKeyRef)publicKeyFromCertificate:(NSData *)certificateData;
- (SecKeyRef)privateKeyFromFile:(NSData *)fileData;

@end
