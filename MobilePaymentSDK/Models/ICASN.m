//
//  ICASN.m
//  MobilePaymentSDK
//
//  Created by Valio Cholakov on 9/21/17.
//  Copyright © 2017 Intercard Finance AD. All rights reserved.
//

#import "ICASN.h"

@implementation NSData (ASN)

- (int)bytesToInt {
    unsigned char *bytes = (void*)[self bytes];
    
    int val = 0;
    int j   = 0;
    
    for (int i = (int)self.length - 1; i >= 0; --i) {
        val += (bytes[i] & 0xFF) << (8 * j);
        ++j;
    }
    
    return val;
}

@end

@implementation NSString (ASN)

- (NSData *)dataFromHexString {
    const char *chars = [self UTF8String];
    NSInteger i = 0, len = self.length;
    
    NSMutableData *data = [NSMutableData dataWithCapacity:len / 2];
    char byteChars[3] = {'\0','\0','\0'};
    unsigned long wholeByte;
    
    while (i < len) {
        byteChars[0] = chars[i++];
        byteChars[1] = chars[i++];
        wholeByte = strtoul(byteChars, NULL, 16);
        [data appendBytes:&wholeByte length:1];
    }
    
    return data;
}

@end

@interface ICASN () {
    NSArray<NSData *> *_items;
}

@end

@implementation ICASN

#pragma mark - Initializers

- (instancetype)initWithData:(NSData *)data {
    if (self = [super init]) {
        _items = @[];
        [self decode:data];
    }
    
    return self;
}

#pragma mark - Public Methods

- (NSData *)keyData {
    for (NSUInteger i = _items.count - 1; _items >= 0; i--) {
        NSData *sequence  = [_items objectAtIndex:i];
        NSData *lastBytes = [sequence subdataWithRange:NSMakeRange(sequence.length - 5, 5)];
        
        if ([lastBytes isEqualToData:[self keyEndingData]]) {
            return sequence;
        }
    }
    
    return nil;
}

#pragma mark - Private Methods

- (void)decode:(NSData *)data {
    //    unsigned char *bytes = (void *)[data bytes];
    
    //    for (int i = 0; i < (int)data.length; i++) {/Users/valiocholakov/Desktop/ViewController-1.swift
    //        NSLog(@"%02x", bytes[i]);
    //    }
    
    NSUInteger bytesRead  = 0;
    NSUInteger extraBytes = 0;
    
    while (bytesRead < data.length) {
        extraBytes = 0;
        
//        NSLog(@"Bytes read: %ld", (long)bytesRead);
        
        NSData *type = [data subdataWithRange:NSMakeRange(bytesRead, 1)];
        bytesRead++;
        
        if ([type isEqualToData:[@"00" dataFromHexString]]) {
//            NSLog(@"Ignore zero byte");
            continue;
        }
        
        NSString *plainType = [self type:((unsigned char *)(void *)[type bytes])[0]];
        
        if (bytesRead == data.length) {
            continue;
        }
        
        NSData *length = [data subdataWithRange:NSMakeRange(bytesRead, 1)];
        bytesRead++;
        
        if (bytesRead == data.length) {
            continue;
        }
        
        if ([length isEqualToData:[@"81" dataFromHexString]]) {
//            NSLog(@"Read 1 more byte for length");
            length = [data subdataWithRange:NSMakeRange(bytesRead, 1)];
            extraBytes = 2;
            bytesRead++;
        }
        else if ([length isEqualToData:[@"82" dataFromHexString]]) {
//            NSLog(@"Read 2 more bytes for length");
            length = [data subdataWithRange:NSMakeRange(bytesRead, 2)];
            extraBytes = 3;
            bytesRead += 2;
        }
//        NSLog(@"Length is %2@ (%d)", length, [length bytesToInt]);
        
        if (bytesRead == data.length) {
            continue;
        }
        
        NSUInteger bytesToRead = [length bytesToInt];
        
        if (bytesRead + bytesToRead > data.length) {
            return;
        }
        
        NSData *content = [data subdataWithRange:NSMakeRange(bytesRead, bytesToRead)];
        
        if ([plainType isEqualToString:@"SEQUENCE"]) {
            NSMutableArray *items = [_items mutableCopy];
            
            int start = (int)bytesRead - (int)extraBytes - (int)length.length;
            int size  = (int)bytesToRead + (int)extraBytes + (extraBytes > 0 ? 1 : 0);
            
            if (start >= 0 && start + size <= data.length) {
                [items addObject:[data subdataWithRange:NSMakeRange(start, size)]];
            }
            
            _items = items;
        }
        
//        NSLog(@"CONTENT: %2@", content);
        bytesRead += content.length;
        
        if ([plainType isEqualToString:@"PrintableString"]) {
//            NSLog(@"%@ = %@", plainType, [[NSString alloc] initWithData:content encoding:NSUTF8StringEncoding]);
        }
        else if ([plainType isEqualToString:@"INTEGER"]) {
//            NSLog(@"%@ = %d", plainType, [content bytesToInt]);
        }
        else if ([plainType isEqualToString:@"UTCTime"]) {
//            NSString *dateString = [[NSString alloc] initWithData:content encoding:NSUTF8StringEncoding];
//
//            NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
//            [dateFormatter setDateFormat:@"yyMMddHHmmss'Z'"];
            
//            NSLog(@"%@ = %@", plainType, [dateFormatter dateFromString:dateString] ? : dateString);
        }
        else if ([plainType isEqualToString:@"OBJECT_IDENTIFIER"]) {
            
        }
        else if ([plainType isEqualToString:@"BIT_STRING"]) {
            [self decode:content];
        }
        else {
            [self decode:content];
        }
    }
}

#pragma mark - Helpers

- (NSData *)keyEndingData {
    const unsigned char bytes[] = { 0x02, 0x03, 0x01, 0x00, 0x01 };
    return [NSData dataWithBytes:bytes length:sizeof(bytes)];
}

- (NSString *)type:(char)byte {
    switch (byte) {
        case 0x00: return @"EOC";
        case 0x01: return @"BOOLEAN";
        case 0x02: return @"INTEGER";
        case 0x03: return @"BIT_STRING";
        case 0x04: return @"OCTET_STRING";
        case 0x05: return @"NULL";
        case 0x06: return @"OBJECT_IDENTIFIER";
        case 0x07: return @"ObjectDescriptor";
        case 0x08: return @"EXTERNAL";
        case 0x09: return @"REAL";
        case 0x0A: return @"ENUMERATED";
        case 0x0B: return @"EMBEDDED_PDV";
        case 0x0C: return @"UTF8String";
        case 0x30: return @"SEQUENCE";
        case 0x31: return @"SET";
        case 0x12: return @"NumericString";
        case 0x13: return @"PrintableString";
        case 0x14: return @"TeletexString";
        case 0x15: return @"VideotexString";
        case 0x16: return @"IA5String";
        case 0x17: return @"UTCTime";
        case 0x18: return @"GeneralizedTime";
        case 0x19: return @"GraphicString";
        case 0x1A: return @"VisibleString";
        case 0x1B: return @"GeneralString";
        case 0x1C: return @"UniversalString";
        case 0x1E: return @"BMPString";
    }
    
    return @"N/A";
}

@end

