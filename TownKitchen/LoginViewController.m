//
//  LoginViewController.m
//  TownKitchen
//
//  Created by Neal Wu on 3/15/15.
//  Copyright (c) 2015 The Town Kitchen. All rights reserved.
//

#import "LoginViewController.h"
#import <Parse/Parse.h>
#import "DaySelectViewController.h"

@interface LoginViewController ()

@property (weak, nonatomic) IBOutlet UITextField *emailTextField;
@property (weak, nonatomic) IBOutlet UITextField *passwordTextField;

@end

@implementation LoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"Log In";
    NSLog(@"viewDidLoad");
}

- (IBAction)onLogin:(id)sender {
    NSLog(@"onLogin");
    NSString *email = self.emailTextField.text;
    NSString *password = self.passwordTextField.text;

    NSLog(@"Attempting to log in...");

    [PFUser logInWithUsernameInBackground:email password:password block:^(PFUser *user, NSError *error) {
        if (user && !error) {
            NSLog(@"Login succeeded!");
            DaySelectViewController *dsvc = [[DaySelectViewController alloc] init];
            [self.navigationController pushViewController:dsvc animated:YES];
        } else {
            NSLog(@"Login failed: %@", error);
        }
    }];
}

- (IBAction)onSignup:(id)sender {
    NSLog(@"onSignup");
    NSString *email = self.emailTextField.text;
    NSString *password = self.passwordTextField.text;

    PFUser *user = [PFUser user];
    user.username = email;
    user.email = email;
    user.password = password;

    NSLog(@"Attempting to sign up...");

    [user signUpInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        if (!error) {
            NSLog(@"Signup succeeded!");
            DaySelectViewController *dsvc = [[DaySelectViewController alloc] init];
            [self.navigationController pushViewController:dsvc animated:YES];
        } else {
            NSString *errorString = [error userInfo][@"error"];
            NSLog(@"Signup failed: %@", errorString);
        }
    }];
}

@end
