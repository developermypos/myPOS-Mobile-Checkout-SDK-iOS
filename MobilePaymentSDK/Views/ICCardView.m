//
//  ICCardView.m
//  MobilePaymentSDK
//
//  Created by Valio Cholakov on 1/31/17.
//  Copyright © 2017 Intercard Finance AD. All rights reserved.
//

#import "ICCardView.h"
#import "ICThemedTextField.h"
#import "BSKeyboardControls.h"
#import "TPKeyboardAvoidingScrollView.h"

#import "ICHelpers.h"
#import "ICConstants.h"
#import "ICMobilePaymentManager.h"

@interface ICCardView() <UITextFieldDelegate, BSKeyboardControlsDelegate> {
    BSKeyboardControls *_keyboardControls;
}

@property (weak, nonatomic) IBOutlet TPKeyboardAvoidingScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UILabel *panLabel;
@property (weak, nonatomic) IBOutlet ICThemedTextField *panTextField;
@property (weak, nonatomic) IBOutlet UILabel *expiryDateLabel;
@property (weak, nonatomic) IBOutlet ICThemedTextField *expiryDateTextField;
@property (weak, nonatomic) IBOutlet UILabel *cvcLabel;
@property (weak, nonatomic) IBOutlet ICThemedTextField *cvcTextField;
@property (weak, nonatomic) IBOutlet UILabel *embossNameLabel;
@property (weak, nonatomic) IBOutlet ICThemedTextField *embossNameTextField;
@property (weak, nonatomic) IBOutlet UILabel *customNameLabel;
@property (weak, nonatomic) IBOutlet ICThemedTextField *customNameTextField;

@end

@implementation ICCardView

#pragma mark - Initializers

+ (instancetype)cardViewWithFrame:(CGRect)frame {
    ICCardView *cardView = [[[NSBundle bundleForClass:[ICMobilePaymentManager class]] loadNibNamed:NSStringFromClass([self class]) owner:self options:nil] firstObject];;
    
    [cardView setFrame:frame];
    [cardView customInit];
    [cardView localize];
    [cardView applyTheme];
    [cardView layoutIfNeeded];
    
    return cardView;
}

#pragma mark - Text Field Delegate

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    if ([textField isEqual:self.embossNameTextField]) {
        [self.customNameTextField becomeFirstResponder];
    }
    else if ([textField isEqual:self.customNameTextField]) {
        [textField resignFirstResponder];
    }
    
    return NO;
}

- (void)textFieldDidBeginEditing:(UITextField *)textField {
    _keyboardControls.activeField = textField;
    
    [self.scrollView scrollToActiveTextField];
}

- (void)textFieldDidEndEditing:(UITextField *)textField {
    _keyboardControls.activeField = nil;
}

#pragma mark - Keyboard Controls Delegate

- (void)keyboardControlsDonePressed:(BSKeyboardControls *)keyboardControls {
    [keyboardControls.activeField resignFirstResponder];
}

- (void)keyboardControls:(BSKeyboardControls *)keyboardControls selectedField:(UIView *)field inDirection:(BSKeyboardControlsDirection)direction {
    [field becomeFirstResponder];
}

#pragma mark - Public Methods

- (NSString *)pan {
    return self.panTextField.text;
}

- (NSString *)cvc {
    return self.cvcTextField.text;
}

- (NSString *)expiryDate {
    return self.expiryDateTextField.text;
}

- (NSString *)embossName {
    return self.embossNameTextField.text;
}

- (NSString *)customName {
    return self.customNameTextField.text;
}

#pragma mark - Private Methods

- (void)customInit {
    NSArray<UITextField *> *fields = @[self.panTextField, self.expiryDateTextField, self.cvcTextField, self.embossNameTextField, self.customNameTextField];
    
    for (UITextField *field in fields) {
        field.delegate = self;
    }
    
    _keyboardControls = [[BSKeyboardControls alloc] initWithFields:fields];
    _keyboardControls.delegate = self;
}

- (void)localize {
    self.panLabel.text        = ICLocalizedString(@"Card number");
    self.expiryDateLabel.text = ICLocalizedString(@"Expiry date");
    self.cvcLabel.text        = ICLocalizedString(@"CVC");
    self.embossNameLabel.text = ICLocalizedString(@"Emboss name");
    self.customNameLabel.text = ICLocalizedString(@"Custom name");
    
    self.panTextField.placeholder        = ICLocalizedString(@"Enter card number");
    self.cvcTextField.placeholder        = ICLocalizedString(@"Enter CVC code");
    self.embossNameTextField.placeholder = ICLocalizedString(@"Enter name on card");
    self.customNameTextField.placeholder = ICLocalizedString(@"Enter custom name");
}

- (void)applyTheme {
    
}

@end
