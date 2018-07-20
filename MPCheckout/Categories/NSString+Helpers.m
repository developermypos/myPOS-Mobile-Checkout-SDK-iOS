//
//  NSString+Helpers.m
//  MPCheckout
//
//  Created by Valio Cholakov on 1/30/17.
//  Copyright © 2017 Intercard Finance AD. All rights reserved.
//

#import "NSString+Helpers.h"
#import "NSRegularExpression+Helpers.h"

#import "ICRSAManager.h"

@implementation NSString (Helpers)

static NSString * const ICCardTypeMastercard   = @"1";
static NSString * const ICCardTypeMaestro      = @"2";
static NSString * const ICCardTypeVisa         = @"3";
static NSString * const ICCardTypeVisaElectron = @"4";
static NSString * const ICCardTypeVPay         = @"5";
static NSString * const ICCardTypeJCB          = @"6";

#pragma mark - Public Methods

- (BOOL)isValidSignatureOf:(NSString *)plainText {
    return [[ICRSAManager sharedManager] signatureIsValid:self plainString:plainText];
}

- (BOOL)matchesRegEx:(NSString *)regEx {
    return [NSRegularExpression string:self matchesRegularExpression:regEx];
}

- (NSString *)shortPan {
    if (self.length > 4) {
        return [NSString stringWithFormat:@"*%@", [self substringFromIndex:self.length - 4]];
    }
    
    return self;
}

- (NSString *)plainCardType {
    if ([self isEqualToString:ICCardTypeMastercard]) {
        return @"Mastercard";
    }
    
    if ([self isEqualToString:ICCardTypeMaestro]) {
        return @"Maestro";
    }
    
    if ([self isEqualToString:ICCardTypeVisa]) {
        return @"Visa";
    }
    
    if ([self isEqualToString:ICCardTypeVisaElectron]) {
        return @"Visa Electron";
    }
    
    if ([self isEqualToString:ICCardTypeVPay]) {
        return @"VPay";
    }
    
    if ([self isEqualToString:ICCardTypeJCB]) {
        return @"JCB";
    }
    
    return @"";
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

+ (NSString *)uuid {
    CFUUIDRef theUUID  = CFUUIDCreate(NULL);
    CFStringRef string = CFUUIDCreateString(NULL, theUUID);
    CFRelease(theUUID);
    
    return (__bridge NSString *)string;
}

@end
