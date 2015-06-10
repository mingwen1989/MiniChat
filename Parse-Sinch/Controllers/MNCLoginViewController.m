//
//  MNCLoginViewController.m
//  MiniChat
//
//  Created by xxx on 11/1/14.
//  Copyright (c) 2014 Sinch. All rights reserved.
//

#import "MNCLoginViewController.h"



@interface MNCLoginViewController ()

@property (strong, nonatomic) IBOutlet UILabel *promptLabel;

@property (strong, nonatomic) IBOutlet UITextField *usernameField;

@property (strong, nonatomic) IBOutlet UITextField *passwordField;

@end



@implementation MNCLoginViewController

#pragma mark Boilerplate methods

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    self.navigationItem.title = @"ios-sinch-messaging-tutorial";
    self.promptLabel.hidden = YES;
        
        // Tab the view to dismiss keyboard
        UITapGestureRecognizer *tapViewGR = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(didTapOnView)];
        [self.view addGestureRecognizer:tapViewGR];
}

#pragma mark User interface behavioral methods

// Tab the view to dismiss keyboard
- (void)didTapOnView {
    [self.usernameField resignFirstResponder];
    [self.passwordField resignFirstResponder];
}

#pragma mark Functional methods

- (IBAction)signup:(id)sender {
    PFUser *pfUser = [PFUser user];
    pfUser.username = self.usernameField.text;
    pfUser.password = self.passwordField.text;
    
    __weak typeof(self) weakSelf = self;
    [pfUser signUpInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        if (!error) {
            weakSelf.promptLabel.textColor = [UIColor greenColor];
            weakSelf.promptLabel.text = @"Signup successful!";
            weakSelf.promptLabel.hidden = NO;
        } else {
            weakSelf.promptLabel.textColor = [UIColor redColor];
            weakSelf.promptLabel.text = [error userInfo][@"error"];
            weakSelf.promptLabel.hidden = NO;
        }
    }];
}

#pragma mark Functional methods

- (IBAction)login:(id)sender {
    __weak typeof(self) weakSelf = self;
    [PFUser logInWithUsernameInBackground:self.usernameField.text
                                 password:self.passwordField.text
                                    block:^(PFUser *pfUser, NSError *error)
     {
         if (pfUser && !error) {
             // Proceed to next screen after successful login.
             weakSelf.promptLabel.hidden = YES;
             [weakSelf performSegueWithIdentifier:@"LoginSegue" sender:self];
         } else {
             // The login failed. Show error.
             weakSelf.promptLabel.textColor = [UIColor redColor];
             weakSelf.promptLabel.text = [error userInfo][@"error"];
             weakSelf.promptLabel.hidden = NO;
         }
     }];
}

@end
