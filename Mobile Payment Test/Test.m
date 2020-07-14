//
//  Test.m
//  Mobile Payment Test
//
//  Created by Valio Cholakov on 8.07.20.
//  Copyright © 2020 Intercard Finance AD. All rights reserved.
//

#import "Test.h"
@import MPCheckout;

@implementation Test

- (void)shit {
    [MPCheckout initializeInCurrency:MPCurrencyEUR
                withConfigurationKey:@"eyJzaWQiOi...IjoiMyJ9"];
}

@end
