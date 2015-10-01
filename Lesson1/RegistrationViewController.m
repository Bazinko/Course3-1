//
//  RegistrationViewController.m
//  Lesson1
//
//  Created by Евгений Сергеев on 01.10.15.
//  Copyright © 2015 Azat Almeev. All rights reserved.
//

#import "RegistrationViewController.h"
#import "NetManager.h"
#import "KeyboardViewController.h"

@interface RegistrationViewController ()

@property (strong, nonatomic, readwrite) NSString *code;

@end

@implementation RegistrationViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self randomNumber];
    
    @weakify(self);
    [self.keyboardSignal subscribeNext:^(NSNumber *x) {
        [UIView animateWithDuration:.3 animations:^{
            @strongify(self);
            self.vOffsetConstraint.constant = [x floatValue] / -2;
            [self.view layoutIfNeeded];
        }];
    }];
    [[self rac_signalForSelector:@selector(textFieldShouldReturn:)] subscribeNext:^(RACTuple *tuple) {
        @strongify(self);
        UITextField *tf = tuple.first;
        if (tf == self.loginTextField)
            [self.passwordTextField becomeFirstResponder];
        else {
            [tf resignFirstResponder];
            [self.registerButton sendActionsForControlEvents:UIControlEventTouchUpInside];
        }
    }];
    
    RAC(self.registerButton, enabled) = [RACSignal combineLatest:@[ self.loginTextField.rac_textSignal, self.passwordTextField.rac_textSignal, self.confirmTextField.rac_textSignal, self.codeTextField.rac_textSignal, RACObserve(self, code) ] reduce:^(NSString *login, NSString *password, NSString *confirm, NSString *code, NSString *validcode){
        return @(login.length > 4 && password.length > 2 && [password isEqual:confirm] && [code isEqualToString:validcode]);
    }];
    
    [[[self.registerButton rac_signalForControlEvents:UIControlEventTouchUpInside] filter:^BOOL(UIButton *sender) {
        return sender.enabled;
    }] subscribeNext:^(id x) {
        @strongify(self);
        [[NetManager.sharedInstance registerWithLogin:self.loginTextField.text password:self.passwordTextField.text confiramtion:self.confirmTextField.text] subscribeError:^(NSError *error) {
            [self showError:error.localizedDescription];
        } completed:^{
            [self presentViewController:[self.storyboard instantiateViewControllerWithIdentifier:@"AppVC"] animated:YES completion:nil];
        }];
    }];
    
}

- (void)randomNumber {
    NSString *code = [self generateNumber];
    self.codeLabel.text = [NSString stringWithFormat:@"Code: %@", code];
}

- (NSString *)generateNumber {
    int value = arc4random_uniform(1000);
    self.code = [@(value) stringValue];
    return self.code;
}

- (NSString *)code {
    if (!_code) {
        [self generateNumber];
    }
    return _code;
}
- (IBAction)doRefresh:(id)sender {
    [self randomNumber];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
