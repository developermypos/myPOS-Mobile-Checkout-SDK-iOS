//
//  ICMobilePaymentManager.m
//  MPCheckout
//
//  Created by Valio Cholakov on 1/31/17.
//  Copyright © 2017 Intercard Finance AD. All rights reserved.
//

#import "ICMobilePaymentManager.h"
#import "ICLogger.h"
#import "ICHelpers.h"
#import "ICConstants.h"
#import "Base64.h"

#import "ICRSAManager.h"

@interface ICMobilePaymentManager () {
    BOOL _inSandbox;
    NSString *_publicKeyName;
    NSString *_privateKeyName;
}

@end;

@implementation ICMobilePaymentManager

@synthesize publicKey  = _publicKey;
@synthesize privateKey = _privateKey;

#pragma mark - Singleton

+ (instancetype)sharedManager {
    static ICMobilePaymentManager *manager = nil;
    static dispatch_once_t onceToken;
    
    dispatch_once(&onceToken, ^{
        manager = [[self alloc] init];
    });
    
    return manager;
}

- (void)dealloc {
    _publicKeyName  = nil;
    _privateKeyName = nil;
    
    if (_publicKey)  { CFRelease(_publicKey);  }
    if (_privateKey) { CFRelease(_privateKey); }
}

#pragma mark - Public Methods

- (void)setWalletNumber:(NSString *)walletNumber
                storeId:(NSString *)storeId
               currency:(MPCurrency)currency
              publicKey:(NSString *)publicKey
             privateKey:(NSString *)privateKey
                 bundle:(NSBundle *)bundle
               language:(NSString *)language
               keyIndex:(NSInteger)keyIndex
              inSandbox:(BOOL)inSandbox {
    
    _bundle         = bundle;
    _storeId        = storeId;
    _currency       = [self currencyRawValue:currency];
    _language       = language;
    _keyIndex       = keyIndex;
    _inSandbox      = inSandbox;
    _publicKeyName  = publicKey;
    _privateKeyName = privateKey;
    _walletNumber   = walletNumber;
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
    
    if (!self.privateKey) {
        [ICLogger log:@"Private key file is corrupted"];
        return NO;
    }
    
    if (!self.publicKey) {
        [ICLogger log:@"Certificate (public key) file is corrupted"];
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

- (SecKeyRef)privateKey {
    if (_privateKey) {
        return _privateKey;
    }
    
    NSData *keyData = [self pemToDer:_privateKeyName];
    
    if (!keyData || !keyData.length) {
        [ICLogger log:@"Private key data is nil"];
        return nil;
    }
    
    _privateKey = [[ICRSAManager sharedManager] privateKeyFromFile:keyData];
    return _privateKey;
}

- (SecKeyRef)publicKey {
    if (_publicKey) {
        return _publicKey;
    }

    NSData *certData = [self pemToDer:_publicKeyName];

    if (!certData || !certData.length) {
        [ICLogger log:@"Certificate data is nil"];
        return nil;
    }

    _publicKey = [[ICRSAManager sharedManager] publicKeyFromCertificate:certData];
    return _publicKey;
}

#pragma mark - Helpers

- (NSData *)pemToDer:(NSString *)pemFileName {
    NSURL *url = [self.bundle URLForResource:pemFileName withExtension:@"txt"];
    
    if (!url) {
        [ICLogger log:[NSString stringWithFormat:@"Cannot get url for file '%@'", pemFileName]];
        return nil;
    }
    
    NSError  *error  = nil;
    NSString *rawPem = [NSString stringWithContentsOfURL:url encoding:NSUTF8StringEncoding error:&error];
    
    if (error) {
        [ICLogger log:[NSString stringWithFormat:@"stringWithContentsOfURL error: %@", error]];
        return nil;
    }
    
    NSString *cleanPem  = @"";
    NSArray  *keyValues = [rawPem componentsSeparatedByString:@"\n"];
    
    for (NSString *keyValue in keyValues) {
        if ([keyValue hasPrefix:@"-"]) {
            continue;
        }
        
        cleanPem = [NSString stringWithFormat:@"%@%@\n", cleanPem, keyValue];
    }
    
    return [[NSData alloc] initWithBase64EncodedString:cleanPem options:NSDataBase64DecodingIgnoreUnknownCharacters];
}

- (NSString *)currencyRawValue:(MPCurrency)currency {
    switch (currency) {
        case MPCurrencyHRK:
            return @"HRK";
            
        case MPCurrencyCZK:
            return @"CZK";
            
        case MPCurrencyDKK:
            return @"DKK";
            
        case MPCurrencyHUF:
            return @"HUF";
            
        case MPCurrencyISK:
            return @"ISK";
            
        case MPCurrencyNOK:
            return @"NOK";
            
        case MPCurrencySEK:
            return @"SEK";
            
        case MPCurrencyCHF:
            return @"CHF";
            
        case MPCurrencyGBP:
            return @"GBP";
            
        case MPCurrencyUSD:
            return @"USD";
            
        case MPCurrencyRON:
            return @"RON";
            
        case MPCurrencyBGN:
            return @"BGN";
            
        case MPCurrencyEUR:
            return @"EUR";
            
        case MPCurrencyPLN:
            return @"PLN";
    }
}

@end
