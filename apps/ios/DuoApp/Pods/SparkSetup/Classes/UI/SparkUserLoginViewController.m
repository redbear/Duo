//
//  SparkUserLoginViewController.m
//  mobile-sdk-ios
//
//  Created by Ido Kleinman on 11/26/14.
//  Copyright (c) 2014-2015 Spark. All rights reserved.
//

#import "SparkUserLoginViewController.h"
#import "SparkSetupWebViewController.h"
#import "SparkSetupCustomization.h"
#import "SparkSetupUIElements.h"


#ifdef FRAMEWORK
#import <ParticleSDK/ParticleSDK.h>
#import <OnePasswordExtension/OnePasswordExtension.h>
#else
#import "Spark-SDK.h"
#import "OnePasswordExtension.h"
#endif
#ifdef ANALYTICS
#import "SEGAnalytics.h"
#endif


@interface SparkUserLoginViewController () <UITextFieldDelegate, UIAlertViewDelegate>
@property (weak, nonatomic) IBOutlet UITextField *emailTextField;
@property (weak, nonatomic) IBOutlet UITextField *passwordTextField;
@property (weak, nonatomic) IBOutlet UIButton *forgotButton;
@property (weak, nonatomic) IBOutlet UIButton *loginButton;
@property (weak, nonatomic) IBOutlet UIImageView *brandImage;
@property (weak, nonatomic) IBOutlet UIButton *noAccountButton;
@property (weak, nonatomic) IBOutlet UILabel *loginLabel;
@property (strong, nonatomic) UIAlertView *skipAuthAlertView;
@property (weak, nonatomic) IBOutlet SparkSetupUISpinner *spinner;
@property (weak, nonatomic) IBOutlet SparkSetupUIButton *skipAuthButton;
@property (weak, nonatomic) IBOutlet UIButton *onePasswordButton;


@end

@implementation SparkUserLoginViewController


- (UIStatusBarStyle)preferredStatusBarStyle
{
    return ([SparkSetupCustomization sharedInstance].lightStatusAndNavBar) ? UIStatusBarStyleLightContent : UIStatusBarStyleDefault;
}



- (void)viewDidLoad {
    [super viewDidLoad];
    
//    [self makeLinkButton:self.forgotButton withText:@"Forgot password"];
//    [self makeBoldButton:self.noAccountButton withText:nil];
    
    // move to super viewdidload?
    self.brandImage.image = [SparkSetupCustomization sharedInstance].brandImage;
    self.brandImage.backgroundColor = [SparkSetupCustomization sharedInstance].brandImageBackgroundColor;
    
    // Trick to add an inset from the left of the text fields
    CGRect  viewRect = CGRectMake(0, 0, 10, 32);
    UIView* emptyView1 = [[UIView alloc] initWithFrame:viewRect];
    UIView* emptyView2 = [[UIView alloc] initWithFrame:viewRect];
    
    // TODO: make a custom control from all the text fields
    self.emailTextField.leftView = emptyView1;
    self.emailTextField.leftViewMode = UITextFieldViewModeAlways;
    self.emailTextField.delegate = self;
    self.emailTextField.returnKeyType = UIReturnKeyNext;
    self.emailTextField.font = [UIFont fontWithName:[SparkSetupCustomization sharedInstance].normalTextFontName size:16.0];

    self.passwordTextField.leftView = emptyView2;
    self.passwordTextField.leftViewMode = UITextFieldViewModeAlways;
    self.passwordTextField.delegate = self;
    self.passwordTextField.font = [UIFont fontWithName:[SparkSetupCustomization sharedInstance].normalTextFontName size:16.0];

    self.skipAuthButton.hidden = !([SparkSetupCustomization sharedInstance].allowSkipAuthentication);
    [self.onePasswordButton setHidden:![[OnePasswordExtension sharedExtension] isAppExtensionAvailable]];
    if (!self.onePasswordButton.hidden) {
        self.onePasswordButton.hidden = ![SparkSetupCustomization sharedInstance].allowPasswordManager;
    }
    

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)onePasswordButtonTapped:(id)sender {
    [[OnePasswordExtension sharedExtension] findLoginForURLString:@"https://login.particle.io" forViewController:self sender:sender completion:^(NSDictionary *loginDictionary, NSError *error) {
        if (loginDictionary.count == 0) {
            if (error.code != AppExtensionErrorCodeCancelledByUser) {
                NSLog(@"Error invoking 1Password App Extension for find login: %@", error);
            }
            return;
        }
        
        self.emailTextField.text = loginDictionary[AppExtensionUsernameKey];
        self.passwordTextField.text = loginDictionary[AppExtensionPasswordKey];
    }];
    
}


-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if (textField == self.emailTextField)
    {
        [self.passwordTextField becomeFirstResponder];
    }
    if (textField == self.passwordTextField)
    {
        [self loginButton:self];
    }
    
    return YES;
    
}


- (IBAction)forgotPasswordButton:(id)sender
{
    [self.delegate didRequestPasswordReset:self];
}

-(void)viewWillAppear:(BOOL)animated
{
#ifdef ANALYTICS
    [[SEGAnalytics sharedAnalytics] track:@"Auth: Login Screen"];
#endif
}



- (IBAction)loginButton:(id)sender
{
    [self.view endEditing:YES];
    if (self.passwordTextField.text.length == 0)
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Cannot sign in" message:@"Password cannot be blank" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert show];
        return;
    }
    
    NSString *email = self.emailTextField.text.lowercaseString;
    
    if ([self isValidEmail:email])
    {
        [self.spinner startAnimating];
         [[SparkCloud sharedInstance] loginWithUser:email password:self.passwordTextField.text completion:^(NSError *error) {
             [self.spinner stopAnimating];
             if (!error)
             {
#ifdef ANALYTICS
                 [[SEGAnalytics sharedAnalytics] track:@"Auth: Login success"];
#endif

                 // dismiss modal view and call main controller delegate to go on to setup process since login is complete
//                 [self dismissViewControllerAnimated:YES completion:^{
                 [self.delegate didFinishUserAuthentication:self loggedIn:YES];
//                 }];
             }
             else
             {
                 NSString *errorText;
#ifdef ANALYTICS
                 [[SEGAnalytics sharedAnalytics] track:@"Auth: Login failure"];
#endif

//                 if ([error.localizedDescription containsString:@"(400)"]) // TODO: fix this hack to something nicer
                 if ([error.localizedDescription rangeOfString:@"(400)"].length > 0) //iOS7 way to do it (still need to do something nicer here)
                     errorText = @"Incorrect username and/or password";
                 else
                     errorText = error.localizedDescription;
                     
                 UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Cannot sign in" message:errorText delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
                 [alert show];
             }
         }];
    }
    else
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Cannot sign in" message:@"Invalid email address" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert show];
    }

}


- (IBAction)noAccountButton:(id)sender
{
    [self.view endEditing:YES];
    [self.delegate didRequestUserSignup:self];
    
    /*
    // go back to signup
    [self dismissViewControllerAnimated:YES completion:nil];
     */

}


-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (alertView == self.skipAuthAlertView)
    {
        if (buttonIndex == 0) //YES
        {
#ifdef ANALYTICS
            [[SEGAnalytics sharedAnalytics] track:@"Auth: Auth skipped"];
#endif
            [self.delegate didFinishUserAuthentication:self loggedIn:NO];
        }
    }
}

- (IBAction)skipAuthButtonTapped:(id)sender {
    
    // that means device is claimed by somebody else - we want to check that with user (and set claimcode if user wants to change ownership)
    NSString *messageStr = [SparkSetupCustomization sharedInstance].skipAuthenticationMessage;
    self.skipAuthAlertView = [[UIAlertView alloc] initWithTitle:@"Skip authentication" message:messageStr delegate:self cancelButtonTitle:nil otherButtonTitles:@"Yes",@"No",nil];
    [self.skipAuthAlertView show];
    
}

@end
