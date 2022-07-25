//
//  ICCardView.m
//  MPCheckout
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
#import "ICThemeManager.h"
#import "ICMobilePaymentManager.h"

#import "NSString+Helpers.h"

@interface ICCardView() <UITextFieldDelegate, BSKeyboardControlsDelegate> {
    BOOL _withoutCustomName;
    BSKeyboardControls *_keyboardControls;
}

@property (weak, nonatomic) IBOutlet UILabel *panLabel;
@property (weak, nonatomic) IBOutlet ICThemedTextField *panTextField;
@property (weak, nonatomic) IBOutlet UILabel *expiryDateLabel;
@property (weak, nonatomic) IBOutlet ICThemedTextField *expiryDateTextField;
@property (weak, nonatomic) IBOutlet UILabel *cvcLabel;
@property (weak, nonatomic) IBOutlet ICThemedTextField *cvcTextField;
@property (weak, nonatomic) IBOutlet UILabel *embossNameLabel;
@property (weak, nonatomic) IBOutlet ICThemedTextField *embossNameTextField;
@property (weak, nonatomic) IBOutlet UILabel *useLatinLettersLabel;
@property (weak, nonatomic) IBOutlet UILabel *customNameLabel;
@property (weak, nonatomic) IBOutlet ICThemedTextField *customNameTextField;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *noCustomNameConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *hasCustomNameConstraint;
@property (weak, nonatomic) IBOutlet UILabel *emailLabel;
@property (weak, nonatomic) IBOutlet ICThemedTextField *emailTextField;

@end

@implementation ICCardView

static NSInteger const kMaxLength     = 30;
static NSInteger const kExpDateLength = 5;
static NSInteger const kCVCMaxLength  = 4;
static NSInteger const kPanMaxLength  = 19;

#pragma mark - Initializers

+ (instancetype)cardViewWithFrame:(CGRect)frame withoutCustomName:(BOOL)withoutCustomName {
    ICCardView *cardView = [[[NSBundle bundleForClass:[ICMobilePaymentManager class]] loadNibNamed:NSStringFromClass([self class])
                                                                                             owner:self
                                                                                           options:nil] firstObject];
    
    [cardView setFrame:frame];
    [cardView customInit];
    [cardView localize];
    [cardView applyTheme];
    
    if (withoutCustomName) {
        [cardView hideCustomName];
    }
    
    [cardView layoutIfNeeded];
    
    return cardView;
}

#pragma mark - Text Field Delegate

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    if ([textField isEqual:self.embossNameTextField]) {
        [self.customNameTextField becomeFirstResponder];
    }
    else if ([textField isEqual:self.emailTextField]) {
        [self.customNameTextField becomeFirstResponder];
    }
    else if ([textField isEqual:self.customNameTextField]) {
        [textField resignFirstResponder];
    }
    
    return NO;
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    if (string.length == 0) {
        [self.useLatinLettersLabel setHidden:YES];
        return YES;
    }
    
    if ([textField isEqual:self.expiryDateTextField] && [textField.text length] == 2) {
        textField.text = [textField.text stringByAppendingString:@"/"];
    }
    
    NSString *newString = [textField.text stringByReplacingCharactersInRange:range withString:string];
    
    if ([textField isEqual:self.panTextField] && newString.length > kPanMaxLength) {
        return NO;
    }
    
    if (([textField isEqual:self.expiryDateTextField] && newString.length > kExpDateLength)) {
        return NO;
    }
    
    if (([textField isEqual:self.cvcTextField] && newString.length > kCVCMaxLength)) {
        return NO;
    }
    
    if (([textField isEqual:self.embossNameTextField] || [textField isEqual:self.customNameTextField]) && newString.length > kMaxLength) {
        return NO;
    }
    
    if ([textField isEqual:self.panTextField] || [textField isEqual:self.cvcTextField] || [textField isEqual:self.expiryDateTextField]) {
        return [string matchesRegEx:@"^[0-9]+$"];
    }
    
    if ([textField isEqual:self.embossNameTextField]) {
        [self.useLatinLettersLabel setHidden:[string matchesRegEx:@"^[a-zA-Z.' -]+$"]];
        return [string matchesRegEx:@"^[a-zA-Z.' -]+$"];
    }
    
    if ([textField isEqual:self.customNameTextField]) {
        return [string matchesRegEx:@"^[a-zA-Z0-9' ]+$"];
    }
    
    return YES;
}

- (void)textFieldDidBeginEditing:(UITextField *)textField {
    _keyboardControls.activeField = textField;
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

- (BOOL)withoutCustomName {
    return _withoutCustomName;
}

- (BOOL)isFilled {
    return self.pan.trimmed.length        > 0 &&
           self.cvc.trimmed.length        > 0 &&
           self.expiryDate.trimmed.length > 0 &&
           self.embossName.trimmed.length > 0 &&
           self.email.trimmed.length      > 0 &&
           (_withoutCustomName || self.customName.trimmed.length > 0);
}

- (BOOL)isValidEmail {
    return [self.email.trimmed matchesRegEx:@"^[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}$"];
}

- (NSString *)pan {
    return self.panTextField.text;
}

- (NSString *)cvc {
    return self.cvcTextField.text;
}

- (NSString *)expiryDate {
    return [self.expiryDateTextField.text stringByReplacingOccurrencesOfString:@"/" withString:@""];
}

- (NSString *)embossName {
    return self.embossNameTextField.text;
}

- (NSString *)customName {
    return self.customNameTextField.text;
}

- (NSString *)email {
    return self.emailTextField.text;
}

#pragma mark - Private Methods

- (void)customInit {
    NSArray<UITextField *> *fields = @[self.panTextField, self.expiryDateTextField, self.cvcTextField, self.embossNameTextField, self.emailTextField, self.customNameTextField];
    
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
    self.useLatinLettersLabel.text = ICLocalizedString(@"Please use latin letters only");
    self.emailLabel.text = ICLocalizedString(@"E-mail address");
    
    self.panTextField.placeholder        = ICLocalizedString(@"Enter card number");
    self.cvcTextField.placeholder        = ICLocalizedString(@"Enter CVC code");
    self.embossNameTextField.placeholder = ICLocalizedString(@"Enter name on card");
    self.customNameTextField.placeholder = ICLocalizedString(@"Enter custom name");
    self.emailTextField.placeholder = ICLocalizedString(@"Enter e-mail address");
}

- (void)applyTheme {
    [self customizeLabels:@[self.panLabel,
                            self.expiryDateLabel,
                            self.cvcLabel,
                            self.embossNameLabel,
                            self.customNameLabel,
                            self.emailLabel]
                 fontSize:[[ICThemeManager sharedTheme] labelFontSize]
                textColor:[[ICThemeManager sharedTheme] labelTextColor]];
}

- (void)hideCustomName {
    _withoutCustomName = YES;
    
    [self.customNameLabel     setHidden:YES];
    [self.customNameTextField setHidden:YES];
    
    NSMutableArray *fields = [_keyboardControls.fields mutableCopy];
    [fields removeObject:self.customNameTextField];
    _keyboardControls.fields = (NSArray *)fields;
    
    [self.hasCustomNameConstraint setActive:NO];
    [self.noCustomNameConstraint  setActive:YES];
    
    [self layoutIfNeeded];
}

#pragma mark - Helpers

- (void)customizeLabels:(NSArray<UILabel *> *)labels fontSize:(CGFloat)fontSize textColor:(UIColor *)textColor {
    for (UILabel *label in labels) {
        label.font      = [UIFont systemFontOfSize:fontSize];
        label.textColor = textColor;
    }
}

@end
