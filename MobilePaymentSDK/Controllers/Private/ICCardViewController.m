//
//  ICCardViewController.m
//  MobilePaymentSDK
//
//  Created by Valio Cholakov on 1/31/17.
//  Copyright © 2017 Intercard Finance AD. All rights reserved.
//

#import "ICCardViewController.h"

#import "NSString+Helpers.h"
#import "UIAlertController+Helpers.h"
#import "UIViewController+Helperes.h"

@implementation ICCardViewController

static NSString * const kSecureSegue = @"3DSecure";

#pragma mark - Controller Methods

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _cardView = [ICCardView cardViewWithFrame:self.contentView.bounds withoutCustomName:self.withoutCustomName];
    [self.contentView addSubview:_cardView];
}

- (void)localize {
    self.cancelButton.title = ICLocalizedString(@"Cancel");
    
    [super localize];
}

- (void)dealloc {
    [_cardView removeFromSuperview];
    
    _cardView          = nil;
    _extraData         = nil;
    _paymentDelegate   = nil;
    _storeCardDelegate = nil;
}

#pragma mark - Actions

- (IBAction)cancel:(id)sender {
    [self.presenter dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)confirm:(id)sender {
    if (![_cardView isFilled]) {
        [UIAlertController showAlert:ICLocalizedString(@"Please fill all fields") withTitle:ICLocalizedString(@"Empty fields") inController:self];
        return;
    }
    
    [self showLoadingHUD];
    [[ICCommunicationManager sharedManager] getCardData:_cardView.pan completion:[self getCardDataCompleted] failure:[self getCardDataFailed]];
}

#pragma mark - Navigation

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if (![segue.identifier isEqualToString:kSecureSegue]) {
        return;
    }
    
    UINavigationController      *navigationController = segue.destinationViewController;
    IC3DSecureWebViewController *secureController     = navigationController.viewControllers.firstObject;
    
    secureController.delegate   = self;
    secureController.urlRequest = [ICUtil cardValidationURLRequest:[self card] cardData:_cardData amount:ICFormatterAmount(self.cardVerificationAmount)];
}

#pragma mark - 3DSecure Delegate

- (void)didCancel3DS {
    [ICLogger log:@"Card verified failed - canceled by user"];
}

- (void)didReceive3DSecureResponse:(NSDictionary *)response {
    _extraData = nil;
    
//    [ICLogger logDebug:[NSString stringWithFormat:@"3DS response: %@", response]];
    
    NSString *_status = [response objectForKey:IC3DSParameterStatus];
    
    if (!_status) {
        [ICLogger logDebug:@"3DS response did not return status"];
        return;
    }
    
    NSInteger status = [_status integerValue];
    
    if (status == ICSecureResponseStatusParamError || status == ICSecureResponseStatusOtherParamError) {
        [ICLogger log:@"Invalid card data"];
        return;
    }
    
    if (status != ICResponseStatusOK) {
        [ICLogger logDebug:@"3DS error"];
        return;
    }
    
    NSString *avv  = [response objectForKey:IC3DSParameterAVV];
    NSString *eci  = [response objectForKey:IC3DSParameterECI];
    NSString *xid  = [response objectForKey:IC3DSParameterXID];
    NSString *cavv = [response objectForKey:IC3DSParameterCAVV];
    
    if (!avv || !eci || !xid || !cavv) {
        [ICLogger logDebug:@"Missing avv, eci, xid or cavv"];
        return;
    }
    
    _extraData = @{
                   IC3DSParameterAVV   : avv,
                   IC3DSParameterECI   : eci,
                   IC3DSParameterXID   : xid,
                   IC3DSParameterCAVV  : cavv,
                   ICParameterCardType : [_cardData objectForKey:ICParameterCardType] ? : @"",
                   };
    
    [ICLogger log:@"Card verified"];
}

#pragma mark - Public Methods

- (void)dismiss:(void (^)(void))completion {
    [self hideLoadingHUD];
    [self.presenter dismissViewControllerAnimated:YES completion:completion];
}

#pragma mark - Helpers

- (Card *)card {
    NSString *cardType = [_extraData objectForKey:ICParameterCardType] ? : @"";
    return [[Card alloc] initWithPan:_cardView.pan
                          expiryDate:_cardView.expiryDate
                                 cvc:_cardView.cvc
                          embossName:_cardView.embossName
                          customName:_cardView.withoutCustomName ? [NSString stringWithFormat:@"%@ %@", [cardType plainCardType], [_cardView.pan shortPan]] : _cardView.customName];
}

- (void (^)(NSDictionary *data))getCardDataCompleted {
    return ^(NSDictionary *cardData) {
        [self hideLoadingHUD];
        
        if (![cardData objectForKey:ICParameterIs3DEnabled] || ![cardData objectForKey:ICParameterIs3DEnabled]) {
            [self.presenter dismissViewControllerAnimated:YES completion:^{
                if ([self.storeCardDelegate respondsToSelector:@selector(storeCardDidFailWithError:)]) {
                    [self.storeCardDelegate storeCardDidFailWithError:[MobilePaymentSDKError communicationError]];
                }
            }];
            return;
        }
        
        NSInteger is3DSecured = [[cardData objectForKey:ICParameterIs3DEnabled] integerValue];
        NSString  *cardType   = [cardData objectForKey:ICParameterCardType];
    
        self->_cardData = cardData;
        
        if (is3DSecured == 1) {
            [self performSegueWithIdentifier:kSecureSegue sender:self];
            return;
        }
        
        [self didReceive3DSecureResponse:@{
                                           IC3DSParameterStatus : ICIntegerToString(ICResponseStatusOK),
                                           IC3DSParameterAVV    : @"",
                                           IC3DSParameterECI    : [self cardEci:cardType],
                                           IC3DSParameterXID    : @"",
                                           IC3DSParameterCAVV   : @""
                                           }];
    };
}

- (void (^)(MobilePaymentSDKError *error))getCardDataFailed {
    return ^(MobilePaymentSDKError *error) {
        [self dismiss:^{
            if ([self.storeCardDelegate respondsToSelector:@selector(storeCardDidFailWithError:)]) {
                [self.storeCardDelegate storeCardDidFailWithError:error];
            }
        }];
    };
}

- (NSString *)cardEci:(NSString *)cardType {
    return [cardType isEqualToString:ICCardTypeMastercard] || [cardType isEqualToString:ICCardTypeMaestro] ? @"00" : @"07";
}

@end
