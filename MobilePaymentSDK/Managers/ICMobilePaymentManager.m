//
//  ICMobilePaymentManager.m
//  MobilePaymentSDK
//
//  Created by Valio Cholakov on 1/31/17.
//  Copyright © 2017 Intercard Finance AD. All rights reserved.
//

#import "ICMobilePaymentManager.h"
#import "ICLogger.h"
#import "ICHelpers.h"
#import "ICPrivateKey.h"
#import "ICConstants.h"
#import "Base64.h"

@interface ICMobilePaymentManager () {
    BOOL _inSandbox;
    NSString *_publicKey;
    NSString *_privateKey;
}

@end;

@implementation ICMobilePaymentManager

#pragma mark - Singleton

+ (instancetype)sharedManager {
    static ICMobilePaymentManager *manager = nil;
    static dispatch_once_t onceToken;
    
    dispatch_once(&onceToken, ^{
        manager = [[self alloc] init];
    });
    
    return manager;
}

#pragma mark - Public Methods

- (void)setWalletNumber:(NSString *)walletNumber
                storeId:(NSString *)storeId
               currency:(Currency)currency
              publicKey:(NSString *)publicKey
             privateKey:(NSString *)privateKey
                 bundle:(NSBundle *)bundle
               language:(NSString *)language
               keyIndex:(NSInteger)keyIndex
              inSandbox:(BOOL)inSandbox {
    
    _bundle       = bundle;
    _storeId      = storeId;
    _currency     = [self currencyRawValue:currency];
    _language     = language;
    _keyIndex     = keyIndex;
    _inSandbox    = inSandbox;
    _publicKey    = publicKey;
    _privateKey   = privateKey;
    _walletNumber = walletNumber;
}

- (BOOL)isInitialized {
    if (_storeId.length == 0) {
        [ICLogger log:@"Store id not provided"];
        return NO;
    }
    
    if (_walletNumber.length == 0) {
        [ICLogger log:@"Account number not provided"];
        return NO;
    }
    
    if (!self.publicKey) {
        [ICLogger log:@"Certificate (public key) file is corrupted"];
        return NO;
    }
    
    if (!self.privateKey) {
        [ICLogger log:@"Private key file is corrupted"];
        return NO;
    }
    
    return YES;
}

- (BOOL)isInSandbox {
    return _inSandbox;
}

+ (NSString *)apiUrl {
    return [[ICMobilePaymentManager sharedManager] isInSandbox] ? ICSandboxApiUrl : ICProductionApiUrl;
}

+ (NSString *)secureUrl {
    return [[ICMobilePaymentManager sharedManager] isInSandbox] ? ICSandbox3DSecureUrl : ICProduction3DSecureUrl;
}

- (ICPrivateKey *)privateKey {
    NSURL *keyURL = [self.bundle URLForResource:_privateKey withExtension:@"txt"];
    
    if (!keyURL) {
        [ICLogger log:@"Cannot get url for private key"];
        return nil;
    }
    
    NSData *keyData = [NSData dataWithContentsOfURL:keyURL];
    
    if (!keyData) {
        [ICLogger log:@"Private key data is nil"];
        return nil;
    }
    
    NSString *cleanKey      = @"";
    NSString *base64Encoded = [[NSString alloc] initWithData:keyData encoding:NSUTF8StringEncoding];
    NSArray  *keyValues     = [base64Encoded componentsSeparatedByString:@"\n"];
    
    for (NSString *keyValue in keyValues) {
        if ([keyValue hasPrefix:@"-"]) {
            continue;
        }
        
        cleanKey = [NSString stringWithFormat:@"%@%@\n", cleanKey, keyValue];
    }
    
    NSData *cleanKeyData = [cleanKey base64DecodedData];
    
    if (!keyData) {
        [ICLogger log:@"Private key data is nil after decoding"];
        return nil;
    }
    
    return [[ICPrivateKey alloc] initWithData:cleanKeyData];
}

- (SecKeyRef)publicKey {
    NSURL *certURL = [self.bundle URLForResource:_publicKey withExtension:@"der"];
    
    if (!certURL) {
        [ICLogger log:@"Cannot get url for certificate"];
        return nil;
    }
    
    NSData *certData = [NSData dataWithContentsOfURL:certURL];
    
    if (!certData) {
        [ICLogger log:@"Certificate data is nil"];
        return nil;
    }
    
    SecKeyRef    key    = NULL;
    SecTrustRef  trust  = NULL;
    SecPolicyRef policy = NULL;
    
    SecCertificateRef cert = SecCertificateCreateWithData(NULL, (CFDataRef)certData);
    
    if (cert != NULL) {
        policy = SecPolicyCreateBasicX509();
        
        if (!policy) {
            [ICLogger log:@"Certificate policy initialization failed"];
            return nil;
        }
        
        OSStatus status = SecTrustCreateWithCertificates((CFTypeRef)cert, policy, &trust);
        
        if (status == noErr) {
            SecTrustResultType result;
            SecTrustEvaluate(trust, &result);
            
            [ICLogger log:[NSString stringWithFormat:@"SecTrustResultType from SecTrustEvaluate returned %d", result]];
            
            key = SecTrustCopyPublicKey(trust);
        }
        else {
            [ICLogger log:[NSString stringWithFormat:@"SecTrustCreateWithCertificates failed with status %d", (int)status]];
        }
    }
    
    if (policy) CFRelease(policy);
    if (trust)  CFRelease(trust);
    if (cert)   CFRelease(cert);
    
    return key;
}

#pragma mark - Helpers

- (NSString *)currencyRawValue:(Currency)currency {
    switch (currency) {
        case CurrencyHRK:
            return @"HRK";
            
        case CurrencyCZK:
            return @"CZK";
            
        case CurrencyDKK:
            return @"DKK";
            
        case CurrencyHUF:
            return @"HUF";
            
        case CurrencyISK:
            return @"ISK";
            
        case CurrencyNOK:
            return @"NOK";
            
        case CurrencySEK:
            return @"SEK";
            
        case CurrencyCHF:
            return @"CHF";
            
        case CurrencyGBP:
            return @"GBP";
            
        case CurrencyUSD:
            return @"USD";
            
        case CurrencyRON:
            return @"RON";
            
        case CurrencyBGN:
            return @"BGN";
            
        case CurrencyEUR:
            return @"EUR";
            
        case CurrencyPLN:
            return @"PLN";
    }
}

@end
