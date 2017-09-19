//
//  NSString+Helpers.m
//  MobilePaymentSDK
//
//  Created by Valio Cholakov on 1/30/17.
//  Copyright © 2017 Intercard Finance AD. All rights reserved.
//

#import "NSString+Helpers.h"
#import "NSRegularExpression+Helpers.h"

#import "ICRSAManager.h"

@implementation NSString (Helpers)

#pragma mark - Public Methods

- (BOOL)isValidSignatureOf:(NSString *)plainText {
    return [[ICRSAManager sharedManager] signatureIsValid:self plainString:plainText];
}

- (BOOL)matchesRegEx:(NSString *)regEx {
    return [NSRegularExpression string:self matchesRegularExpression:regEx];
}

- (NSString *)trimmed {
    return [self stringByReplacingOccurrencesOfString:@" " withString:@""];
}

- (NSString *)encrypted {
    return [[ICRSAManager sharedManager] encryptedString:self];
}

- (NSString *)decrypted {
    return [[ICRSAManager sharedManager] decryptedString:self];
}

- (NSString *)signature {
    return [[ICRSAManager sharedManager] signString:self];
}

- (NSString *)urlDecoded {
    return [self stringByRemovingPercentEncoding];
}

- (NSString *)urlEncoded {
    NSMutableString *output = [NSMutableString string];
    const unsigned char *source = (const unsigned char *)[self UTF8String];
    unsigned long sourceLen = strlen((const char *)source);
    
    for (int i = 0; i < sourceLen; ++i) {
        const unsigned char thisChar = source[i];
        
        if (thisChar == ' ') {
            [output appendString:@"%20"];
            continue;
        }
        
        if ((thisChar >= 'a' && thisChar <= 'z') ||
            (thisChar >= 'A' && thisChar <= 'Z') ||
            (thisChar >= '0' && thisChar <= '9'))
        {
            [output appendFormat:@"%c", thisChar];
            continue;
        }
        
        [output appendFormat:@"%%%02X", thisChar];
    }
    
    return output;
}

@end
