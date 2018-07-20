//
//  ICHelpers.h
//  MPCheckout
//
//  Created by Valio Cholakov on 1/30/17.
//  Copyright © 2017 Intercard Finance AD. All rights reserved.
//

#ifndef ICHelpers_h
#define ICHelpers_h

#define ICIntegerToString(var)      [@(var) stringValue]
#define ICFormatterAmount(var)      [NSString stringWithFormat:@"%.02f", var]
#define kCustomerIdent              [NSString stringWithFormat:@"Store%@", [[ICMobilePaymentManager sharedManager] storeId]]
#define kSDKVersion                 [[[NSBundle bundleForClass:[ICBaseManager class]] infoDictionary] valueForKey:@"CFBundleShortVersionString"] ? : @""
#define ICLocalizedString(string)   [[[ICMobilePaymentManager sharedManager] bundle] localizedStringForKey:string value:string table:kLocalizationsTable]

#define SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(v)  ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] != NSOrderedAscending)

// NSLog only if in Debug mode.
#ifndef ICLog
#ifdef DEBUG
#define ICLog(_format_, ...) NSLog((_format_ @" %s [Line %d]"), ##__VA_ARGS__, __PRETTY_FUNCTION__, __LINE__)
#else
#define ICLog(_format_, ...)
#endif
#endif

#endif /* ICHelpers_h */
