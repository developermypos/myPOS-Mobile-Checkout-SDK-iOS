//
//  ICBaseViewController.m
//  MobilePaymentSDK
//
//  Created by Valio Cholakov on 1/31/17.
//  Copyright © 2017 Intercard Finance AD. All rights reserved.
//

#import "ICBaseViewController.h"

#import "MBProgressHUD.h"

#import "ICConstants.h"

@interface ICBaseViewController ()

@end

@implementation ICBaseViewController

#pragma mark - Controller Methods

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self addListeners];
    [self localize];
    [self applyTheme];
}

- (void)dealloc {
    [self removeListeners];
}

#pragma mark - Abstract Methods

- (void)localize {
    // Should be implemeted by inheriting controllers
}

- (void)applyTheme {
    // Should be implemeted by inheriting controllers
}

#pragma mark - Public Methods

- (void)showLoadingHUD {
    [self hideLoadingHUD];

    UIView *view = [self.navigationController view];
    
    if (!view) {
        return;
    }
    
    dispatch_async(dispatch_get_main_queue(), ^{
        [MBProgressHUD showHUDAddedTo:view animated:YES];
    });
}

- (void)hideLoadingHUD {
    UIView *view = [self.navigationController view];
    
    if (!view) {
        return;
    }
    
    dispatch_async(dispatch_get_main_queue(), ^{
        [MBProgressHUD hideAllHUDsForView:view animated:YES];
    });
}

#pragma mark - Private Methods

- (void)addListeners {
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(applyTheme) name:ICNotificationThemeChanged object:nil];
}

- (void)removeListeners {
    [[NSNotificationCenter defaultCenter] removeObserver:self name:ICNotificationThemeChanged object:nil];
}

@end
