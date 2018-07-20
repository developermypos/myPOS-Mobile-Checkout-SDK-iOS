//
//  IC3DSecureWebViewController.h
//  MPCheckout
//
//  Created by Valio Cholakov on 1/31/17.
//  Copyright © 2017 Intercard Finance AD. All rights reserved.
//

#import "ICBaseViewController.h"

@protocol IC3DSecureDelegate <NSObject>

- (void)didReceive3DSecureResponse:(NSDictionary *)response;
- (void)didCancel3DS;

@end

@interface IC3DSecureWebViewController : ICBaseViewController

@property (weak, nonatomic) IBOutlet UIWebView *webView;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *cancelButton;

@property (nonatomic, strong) NSURLRequest *urlRequest;
@property (weak, nonatomic) id<IC3DSecureDelegate> delegate;

@end
