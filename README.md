# myPOS™ Mobile Checkout iOS
Accepting mobile payments for merchants

### Table of Contents

* [Security and availability](#security-and-availability)

* [Introduction](#introduction)

* [Test myPOS™ Mobile Checkout iOS SDK](#test-mypos-mobile-checkout-ios-sdk)

* [Integration](#integration)
  
  * [Requirements](#requirements)
  
  * [Setup](#setup)
  
  * [Perform a Payment](#perform-a-payment)
  
  * [Perform a Payment with a Stored Card](#perform-a-payment-with-a-stored-card)
  
  * [Add a Card](#add-a-card)
  
  * [Update a Stored Card](#update-a-stored-card)
  
  * [Perform a Refund](#perform-a-refund)
  
  * [Check transaction status](#check-transaction-status)
  
* [UI customization](#ui-customization)
  
* [Build in parameters](#build-in-parameters)
 

  # Security and availability
  
  Connection between Merchant and iCARD is handled through internet using HTTPS protocol (SSL over HTTP). Requests and responses are digitally signed both. iCARD host is located at tier IV datacenter in Luxembourg. The system is designed specifically for the unique challenges of mobile fraud and comes as standard in our SDK. It is powered by the latest machine learning algorithms, as well as trusted methodologies. The SDK comes with built-in checks and security features, including real-time error detection, 3D Secure, data and address validation for frictionless card data capture.
  
  Exchange folder for partners (if needed) is located at a SFTP server which enables encrypted file sharing between parties. The partner receives the account and password for the SFTP directory via fax, email or SMS.
  
  # Introduction
  
  This document describes the methods and interface for mobile checkout. The Merchants should integrate the myPOS™ Mobile Checkout iOS SDK to their mobile apps to accept card payments. The myPOS™ Mobile Checkout iOS SDK will gain access to the entry point of the payment gateway managed by Intercard Finance AD (iCARD). The cardholder will be guided during the payment process and iCARD will check the card sensitive data and will process a payment transaction through card schemes (VISA and MasterCard).
  
  The myPOS™ Mobile Checkout iOS SDK will provide:
  * Secured communication channel with the Merchant
  * Storing of merchant private data (shopping cart, amount, payment methods, transaction details etc.)
  * Financial transactions to VISA, MasterCard – transparent for the Merchant
  * Operations for the front-end: Purchase transaction
  * Operations for the back-end: Refund, Void, Payment
  * 3D processing
  * Card Storage

  Out of scope for this document: 
  * Merchant statements and payouts
  * Merchant back-end
  
  The purpose of this document is to specify the myPOS™ Mobile Checkout iOS SDK Interface and demonstrate how it is used in the most common way.
  All techniques used within the interface are standard throughout the industry and should be very easy to implement on any platform.
  
  # Test myPOS™ Mobile Checkout iOS SDK
  
  To help you integrate and test your project, use the sandbox and live environments before release.
  
  The sandbox environment is best used to test all possible scenarios, as well as all possible results including error handling, additional security features, etc. Make sure that you are not jumping into the live environment before you are comfortable that everything is working as expected in sandbox.
  
  A “by appointment” test service is available which allows the validation of the myPOS™ Mobile Checkout iOS SDK calls. Testers should negotiate an exclusive access to the testing service and ensure monitoring by iCARD engineer.
  
  Depending on your business requirements, we encourage you to test your project in all the possible scenarios and using all the supported card networks. This means:
  
  # Integration
  
  ## Requirements
  
  * Xcode 8 and above
  
  ## Setup
  
  Start using myPOS™ Mobile Checkout iOS SDK by initializing it. Find your account’s unique number on the Dashboard. Choose a store, which will accept the payments. Provide its store id to the SDK. Set the currency to match the store’s one and in which payments will be processed. Follow the instructions regarding the key generation on page.
 
 Save the certificate to a file with .txt extension.
 Save the private key to a file with .txt extension.
 
 Note: Include the certificate and private key files in your project. Then go to Build Phases -> Copy Bundle Resource and add the files.
 
 Only thing left is to provide all this data to the SDK.
 
Swift:
```Swift
MPCheckout.initialize(accountNumber: "1234567890",
                      storeId: "12345",
                      currency: .eur,
                      certificate: "public_cert",
                      privateKey: "private_key")
```
  
Objective-C:
```ObjectiveC
[MPCheckout initializeWithAccountNumber:@"1234567890"
                                storeId:@"12345"
                               currency:MPCurrencyEUR
                            certificate:@"public_cert"
                             privateKey:@"private_key"
                                 bundle:[NSBundle mainBundle]
                               keyIndex:1];
```
  
  Note: “bundle” and “keyIndex” are optional in Swift and default to main bundle and first key index. The key index represents the sequence of the generated key. In Objective-C we need to provide those to the SDK. The bundle will be used to look for the certificate, private key and localization files.
  
The SDK allows further configuration by using the existing settings. These are the options:
  * Supported card networks – Allows you to determine the accepted card networks when using your app. The default value includes Visa, Visa Electron, MasterCard, Maestro and VPay.
  * Address Verification Service (AVS) – You will be able to capture the consumer’s country and postcode as an additional security layer.
  
  ## Perform a Payment
  
  Create an instance of PaymentViewController with a list of CartItem object, a unique order id and a delegate to handle various outcomes of the operation:
  
Swift:
```Swift
let controller = MPPaymentViewController(cartItems: selectedCartItems, 
                                         orderId: ICUtils.randomOrderId, 
                                         delegate: self)

self.present(controller, animated: true, completion: nil)
```
  
Objective-C:
```ObjectiveC
MPPaymentViewController *controller = [[MPPaymentViewController alloc] initWithCartItems:_selectedCartItems 
                                                                                 orderId:[ICUtils randomOrderId] 
                                                                                delegate:self];

[self presentViewController:controller animated:YES completion:nil];
```

The delegate must implement PaymentDelegate’s methods:
  
Swift:
```Swift
func didMakePayment(transactionRef: String)
func paymentFailed(error: MPCheckoutError)
```
  
Objective-C:
```ObjectiveC
- (void)didMakePaymentWithTransactionRef:(NSString *)transactionRef;
- (void)paymentFailedWithError:(MPCheckoutError *)error;
```
  
  ## Perform a Payment with a Stored Card
  
  Performing a payment with a stored card is almost the same. Only difference is using a different initializing method of PaymentViewController which includes a cardToken parameter:
 
Swift:
```Swift
let controller = MPPaymentViewController(cartItems: selectedCartItems, 
                                         orderId: ICUtils.randomOrderId, 
                                         cardToken: selectedCardToken,
                                         delegate: self)

self.present(controller, animated: true, completion: nil)
```
  
Objective-C:
```ObjectiveC
MPPaymentViewController *controller = [[MPPaymentViewController alloc] initWithCartItems:_selectedCartItems 
                                                                                 orderId:[ICUtils randomOrderId]
                                                                               cardToken:_selectedCardToken
                                                                                delegate:self];

[self presentViewController:controller animated:YES completion:nil];
```

The same delegate methods are called after completion:

Swift:
```Swift
func didMakePayment(transactionRef: String)
func paymentFailed(error: MPCheckoutError)
```
  
Objective-C:
```ObjectiveC
- (void)didMakePaymentWithTransactionRef:(NSString *)transactionRef;
- (void)paymentFailedWithError:(MPCheckoutError *)error;
```

  ## Add a Card

Create an instance of StoreCardViewController with a verification amount and a delegate to handle various outcomes of the operation:

Swift:
```Swift
let controller = MPStoreCardViewController(verificationAmount: 1.00, 
                                           delegate: self)

present(controller, animated: true, completion: nil)
```
  
Objective-C:
```ObjectiveC
MPStoreCardViewController *controller = [[MPStoreCardViewController alloc] initWithVerificationAmount:1.00
                                                                                             delegate:self];

[self presentViewController:controller animated:YES completion:nil];
```

The delegate must implement StoreCardDelegate’s methods.

Swift:
```Swift
func storeCardDidComplete(withData storedCard: MPStoredCard)
func storeCardDidFailWithError(_ error: MPCheckoutError)
```
  
Objective-C:
```ObjectiveC
- (void)storeCardDidCompleteWithData:(MPStoredCard *)storedCard
- (void)storeCardDidFailWithError:(MPCheckoutError *)error;
```

  ## Update a Stored Card

Create an instance of UpdateStoredCardViewController with a verification amount and a delegate to handle various outcomes of the operation:


Swift:
```Swift
let controller = MPUpdateStoredCardViewController(cardToken: selectedCard.token
                                                  verificationAmount: 1.00, 
                                                  delegate: self)

present(controller, animated: true, completion: nil)
```
  
Objective-C:
```ObjectiveC
MPUpdateStoredCardViewController *controller = [[MPUpdateStoredCardViewController alloc] initWithCardToken:_card.token
                                                                                        verificationAmount:1.00
                                                                                                  delegate:self];
[self presentViewController:controller animated:YES completion:nil];
```

The delegate must implement StoreCardDelegate’s methods.

Swift:
```Swift
func updateStoredCardDidComplete(withData storedCard: MPStoredCard, forCardWithToken cardToken: String)
func updateStoredCardDidFailWithError(_ error: MPCheckoutError)
```
  
Objective-C:
```ObjectiveC
- (void)updateStoredCardDidCompleteWithData:(MPStoredCard *)storedCard forCardWithToken:(NSString *)cardToken
- (void)updateStoredCardDidFailWithError:(MPCheckoutError *)error
```

  ## Perform a Refund
  
Refunding a payment requires that you have the transaction reference and order id of the payment. The amount should also be specified. A completion block with the transaction reference and a failed block with a MPCheckoutError object should be provided.

Swift:
```Swift
MPCheckout.refundTransaction(transaction.reference, 
                             orderId: transaction.orderId, 
                             amount: amount, 
                             completed: { (transactionRef) in
                              showAlertWithText("Refund completed successfully")
},
                             failed: { (error) in 
                              showAlertWithText("Refund failed. Error: \(error.message)")
})
```
  
Objective-C:
```ObjectiveC
[MPCheckout refundTransaction:_transaction.reference
                      orderId:_transaction.orderId
                       amount:_amount
                    completed:^(NSString * _Nonnull transactionRef) {
                        [self showAlertWithText:@"Refund completed successfully"];
                    } failed:^(MPCheckoutError * _Nonnull error) {
                        [self showAlertWithText:[@"Refund failed. Error: "                                 
                                                 stringByAppendingString:error.message]];
                    }];
```

Note: Please make sure that you are using the correct Transaction Reference ID for the transaction that you want to be refunded.

  ## Check transaction status

To check the status of a transaction, you need its order id and type, whether it’s a Purchase or a Refund. The method will retrieve the transaction’s status and reference:

Swift:
```Swift
MPCheckout.getOrderStatusFor(orderId,
                             transactionType: type,
                             completed: { (status, reference) in
                              self.showAlertWithText("Order \(orderId). " +
                                                     "Status - \(status) | " + 
                                                     "Reference - \(reference)")
},
                             failed: { (error) in
                              self.showAlertWithText("Error while getting order status: " +
                                                     "\(error.message)")
})
```
  
Objective-C:
```ObjectiveC
[MPCheckout getOrderStatusFor:_orderId
              transactionType:_transactionType
                    completed:^(NSInteger status, NSString * _Nonnull paymentRef) {
                        [self showAlertWithText:[NSString stringWithFormat:
                                                @"Order %@. Status - %ld | Reference - %@",
                                                orderId, status, paymentRef]];
                     } failed:^(MPCheckoutError * _Nonnull error) {
                        [self showAlertWithText:[NSString stringWithFormat:
                                                @"Error while getting order status: %ld",
                                                status]];
                    }];
```

# UI customization

Use myPOS™ Mobile Checkout iOS SDK UI components for a frictionless checkout in your app. Minimize your PCI scope with a UI that can be themed to match your brand colors and style.

Built-in features include quick data entry, optional security checks and fraud prevention that let you focus on developing other areas of your app.

The myPOS™ Mobile Checkout iOS SDK supports a range of UI customization options to allow you to match payment screen appearance to your app's branding.

Create a new MobilePaymentTheme object and set its properties. Here is an example of the default theme.

Swift:
```Swift
var theme                  = MPCheckoutTheme()
theme.labelFontSize        = 13.0
theme.textFieldFont        = UIFont.systemFont(ofSize: 14.0)
theme.labelTextColor       = UIColor.defaultTextColor
theme.placeholderColor     = UIColor.lightGray
theme.barButtonItemColor   = UIColor.buttonEnabled
theme.textFieldTextColor   = UIColor.defaultTextColor
theme.placeholderFontSize  = 13.0
theme.textFieldBorderColor = UIColor.gray.withAlphaComponent(0.3)
theme.navigationTitleColor = UIColor.defaultTextColor
theme.placeholderAlignment = .left
```
  
Objective-C:
```ObjectiveC
MPCheckout *theme          = [MPCheckout new];
theme.labelFontSize        = 13.0f;
theme.textFieldFont        = [UIFont systemFontOfSize:14.0f];
theme.labelTextColor       = [UIColor defaultTextColor];
theme.placeholderColor     = [UIColor lightGrayColor];
theme.barButtonItemColor   = [UIColor buttonEnabled];
theme.textFieldTextColor   = [UIColor defaultTextColor];
theme.placeholderFontSize  = 13.0f;
theme.textFieldBorderColor = [[UIColor grayColor] colorWithAlphaComponent:.3];
theme.navigationTitleColor = [UIColor defaultTextColor];
theme.placeholderAlignment = NSTextAlignmentLeft;
```

After settings up the theme, tell the SDK to apply it:

Swift:
```Swift
MPCheckout.applyTheme(theme)
```
  
Objective-C:
```ObjectiveC
[MPCheckout applyTheme:theme];
```

Note: Each method in the SDK has Xcode style documentation accessible in the Utilities Quick help section or by holding “alt” and mouse clicking on the method.

# Build in parameters

Currency values:

Swift:
```Swift
.hrk, .czk, .dkk, .huf, .isk, .nok, .sek, .chf, .gbp, .usd, .ron, .bgn, .eur, .pln
```

Objective C:
```ObjectiveC
MPCurrencyHRK, MPCurrencyCZK, MPCurrencyDKK, MPCurrencyHUF, MPCurrencyISK, MPCurrencyNOK, MPCurrencySEK, MPCurrencyCHF, MPCurrencyGBP, MPCurrencyUSN, MPCurrencyRON, MPCurrencyBGN, MPCurrencyEUR, MPCurrencyPLN
```

Transaction types:

Swift:
```Swift
.purchase, .refund
```

Objective C:
```ObjectiveC
MPTransactionTypePurchase, MPTransactionTypeRefund
```



