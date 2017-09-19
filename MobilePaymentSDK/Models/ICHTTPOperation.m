//
//  ICHTTPOperation.m
//  MobilePaymentSDK
//
//  Created by Valio Cholakov on 1/31/17.
//  Copyright © 2017 Intercard Finance AD. All rights reserved.
//

#import "ICHTTPOperation.h"
#import "ICURLRequest.h"
#import "ICLogger.h"
#import "ICConstants.h"

#import "Base64.h"
#import "NSString+Helpers.h"

@interface ICHTTPOperation() <NSURLConnectionDataDelegate> {
    BOOL _finished;
    BOOL _executing;
    
    id _response;
    NSURLRequest *_urlRequest;
    NSMutableData *_responseData;
    NSURLConnection *_urlConnection;
    
    dispatch_queue_t _operationQueue;
    
    ICHTTPOperatonErrorBlock   _errorBlock;
    ICHTTPOperatonSuccessBlock _successBlock;
}

@end

@implementation ICHTTPOperation

static const char *kOperationQueue = "com.ipay.mobilePaymentSDK-operation";

#pragma mark - Initializers

- (instancetype)initWithRequest:(ICURLRequest *)request successBlock:(ICHTTPOperatonSuccessBlock)successBlock errorBlock:(ICHTTPOperatonErrorBlock)errorBlock {
    if (self = [super init]) {
        _urlRequest     = request.urlRequest;
        _errorBlock     = errorBlock;
        _successBlock   = successBlock;
        _responseData   = [[NSMutableData alloc] init];
        _operationQueue = dispatch_queue_create(kOperationQueue, NULL);
    }
    
    return self;
}

#pragma mark - Deinitializer

- (void)dealloc {
    _response     = nil;
    _urlRequest   = nil;
    _errorBlock   = nil;
    _successBlock = nil;
    
    if (_urlConnection) {
        [_urlConnection cancel];
        [self completeOperation];
        _urlConnection = nil;
    }
}

#pragma mark - Operation Methods

- (void)main {
    _urlConnection = [[NSURLConnection alloc] initWithRequest:_urlRequest delegate:self];
    
    while (!_finished && ![self isCancelled]) {
        [[NSRunLoop currentRunLoop] runMode:NSDefaultRunLoopMode beforeDate:[NSDate distantFuture]];
    }
}

- (void)start {
    dispatch_async(_operationQueue, ^{
        [self main];
    });
    
    if ([self isCancelled]) {
        [self willChangeValueForKey:@"isFinished"];
        _finished = YES;
        [self didChangeValueForKey:@"isFinished"];
        return;
    }
    
    _executing = YES;
}

- (void)cancel {
    if (_urlConnection) {
        [_urlConnection cancel];
        _urlConnection = nil;
    }
    
    [self completeOperation];
    [self connectivityError];
}

#pragma mark - NSURLConnection Delegate

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error {
    [ICLogger logDebug:[NSString stringWithFormat:@"Connection failed: %@", error.localizedDescription]];
    
    dispatch_async(dispatch_get_main_queue(), ^{
        [self operationEncounteredAnError:error];
        [self completeOperation];
    });
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data {
    [_responseData appendData:data];
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection {
    dispatch_async(dispatch_get_main_queue(), ^{
        [self readResponse];
        [self completeOperation];
    });
}

- (BOOL)isFinished {
    return _finished;
}

- (BOOL)isExecuting {
    return _executing;
}

- (BOOL)isConcurrent {
    return YES;
}

#pragma mark - Private Methods

- (void)completeOperation {
    _urlConnection = nil;
    _finished      = YES;
    _executing     = NO;
    
    [_responseData setLength:0];
}

- (void)readResponse {
    if ([_responseData length] == 0) {
        return;
    }
    
    NSString *rawResponse = [[NSString alloc] initWithData:_responseData encoding:NSUTF8StringEncoding];
    
    if (!rawResponse) {
        [ICLogger logDebug:@"Empty response"];
        [self communicationError];
        return;
    }
    
    NSMutableArray *rawResponseData = [[rawResponse componentsSeparatedByString:@",\""] mutableCopy];
    
    NSError      *error    = nil;
    NSDictionary *response = [NSJSONSerialization JSONObjectWithData:_responseData options:NSJSONReadingMutableContainers error:&error];
    
    if (error) {
        [ICLogger logDebug:@"Cannot parse response to JSON"];
        [self communicationError];
        return;
    }
    
    if (!response) {
        [self communicationError];
        return;
    }
    
    [ICLogger logDebug:[NSString stringWithFormat:@"Response: %@", response]];
    
    NSString *_status   = [response objectForKey:ICParameterStatus];
    NSString *signature = [response objectForKey:ICParameterSignature];
    NSString *statusMsg = [response objectForKey:ICParameterStatusMessage];
    
    if (!_status || !statusMsg) {
        [ICLogger logDebug:@"Missing data in response"];
        [self communicationError];
        return;
    }
    
    [ICLogger log:[NSString stringWithFormat:@"Status: %@ - %@", _status, statusMsg]];
    [ICLogger log:@"Validating response..."];
    
    NSInteger status = [_status integerValue];
    NSString *dataToValidate = @"";
    
    if (!signature) {
        [self signatureError];
        return;
    }
    
    [rawResponseData removeLastObject]; // Remove signature
    
    for (NSString *rawData in rawResponseData) {
        @autoreleasepool {
            NSString *value = [[rawData componentsSeparatedByString:@"\":"] lastObject];
            
            if (!value) {
                continue;
            }
            
            dataToValidate = [NSString stringWithFormat:@"%@-%@", dataToValidate, value];
        }
    }
    
    dataToValidate = [[dataToValidate substringFromIndex:1] stringByReplacingOccurrencesOfString:@"\"" withString:@""];
    
    [ICLogger logDebug:[NSString stringWithFormat:@"Signature must match %@", dataToValidate]];
    
    BOOL signatureIsValid = [signature isValidSignatureOf:[dataToValidate base64EncodedString]];
    
    [ICLogger log:[NSString stringWithFormat:@"Response is %@valid", signatureIsValid ? @"" : @"in"]];
    
    if (!signatureIsValid) {
        [self signatureError];
        return;
    }
    
    if (status != ICResponseStatusOK) {
        [self completeWithStatus:status];
        return;
    }
    
    if (_successBlock) {
        _successBlock(response);
    }
    
    [self completeOperation];
}

- (void)communicationError {
    [self completeWithStatus:MobilePaymentSDKCommunicationError];
}

- (void)connectivityError {
    [self completeWithStatus:MobilePaymentSDKConnectivityChangedError];
}

- (void)signatureError {
    [self completeWithStatus:MobilePaymentSDKSignatureValidationError];
}

- (void)completeWithStatus:(NSInteger)status {
    if (_errorBlock) {
        _errorBlock([MobilePaymentSDKError errorWithStatus:status]);
    }
    
    [self completeOperation];
}

- (void)operationEncounteredAnError:(NSError *)error {
    if (!_errorBlock) {
        _errorBlock((MobilePaymentSDKError *)error);
    }
    
    [self completeOperation];
}

@end
