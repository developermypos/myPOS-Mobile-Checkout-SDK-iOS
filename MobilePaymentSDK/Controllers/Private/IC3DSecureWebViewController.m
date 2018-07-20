//
//  IC3DSecureWebViewController.m
//  MPCheckout
//
//  Created by Valio Cholakov on 1/31/17.
//  Copyright © 2017 Intercard Finance AD. All rights reserved.
//

#import "IC3DSecureWebViewController.h"

#import "ICMobilePaymentManager.h"
#import "ICConstants.h"
#import "ICHelpers.h"
#import "ICLogger.h"

#import "UIViewController+Helperes.h"

@interface IC3DSecureWebViewController () <UIWebViewDelegate>

@end

@implementation IC3DSecureWebViewController

#pragma mark - Controller Methods

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self customInit];
    [self applyTheme];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    if (!_urlRequest) {
        return;
    }
    
    [self.webView loadRequest:_urlRequest];
}

- (void)dealloc {
    _delegate   = nil;
    _urlRequest = nil;
}

#pragma mark - Localization

- (void)localize {
    self.navigationItem.title = ICLocalizedString(@"3D Secure");
    self.cancelButton.title   = ICLocalizedString(@"Cancel");
    
    [super localize];
}

#pragma mark - Actions

- (IBAction)cancel:(id)sender {
    if ([self.delegate respondsToSelector:@selector(didCancel3DS)]) {
        [self.delegate didCancel3DS];
    }
    
    [self.presenter dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - Web View Delegate

- (void)webViewDidFinishLoad:(UIWebView *)webView {
    NSString *url = webView.request.URL.absoluteString;
    
    if (url &&
        ![url containsString:@"icard"]   &&
        ![url containsString:@"leupay"]  &&
        ![url containsString:@"leupost"] &&
        ![url containsString:@"gateway"]) {
        [self hideLoadingHUD];
    }
    
    [ICLogger logDebug:url];
    [self readResponse];
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error {
    if (error.code == -1005) {
        [self.webView loadRequest:_urlRequest];
        return;
    }
    
    [ICLogger log:[NSString stringWithFormat:@"Web view error: %@", error]];
    [self hideLoadingHUD];
}

#pragma mark - Private Methods

- (void)customInit {
    self.webView.delegate = self;

    if (_urlRequest) {
        [self showLoadingHUD];
    }
}

- (void)applyTheme {
    [self.webView setOpaque:NO];
    [self.webView setBackgroundColor:[UIColor whiteColor]];
}

- (void)readResponse {
    NSString *body = [self.webView stringByEvaluatingJavaScriptFromString:@"document.body.innerHTML"];
    NSRange  range = [body rangeOfString:@"\\{.+\\}" options:NSRegularExpressionSearch];
    
    if (range.location == NSNotFound) {
        return;
    }
    
    NSString     *response = [body substringWithRange:range];
    NSError      *error    = nil;
    NSDictionary *json     = [NSJSONSerialization JSONObjectWithData:[response dataUsingEncoding:NSUTF8StringEncoding] options:NSJSONReadingAllowFragments error:&error];
    
    if (error || !json) {
        [ICLogger logDebug:[NSString stringWithFormat:@"Could not format response %@ to json. Error: %@", response, error ? : @"N/A"]];
        return;
    }
    
    if ([self.delegate respondsToSelector:@selector(didReceive3DSecureResponse:)]) {
        [self.delegate didReceive3DSecureResponse:json];
    }
    
    [self.presenter dismissViewControllerAnimated:YES completion:nil];
}

@end
