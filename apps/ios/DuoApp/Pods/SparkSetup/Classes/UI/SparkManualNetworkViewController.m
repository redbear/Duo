//
//  SparkManualNetworkViewController.m
//  teacup-ios-app
//
//  Created by Ido on 2/22/15.
//  Copyright (c) 2015 spark. All rights reserved.
//

#import "SparkManualNetworkViewController.h"
#import "SparkSetupUIElements.h"
#import "SparkSetupCustomization.h"
#import "SparkConnectingProgressViewController.h"
#import "SparkSetupCommManager.h"
#import "SparkSetupPasswordEntryViewController.h"
#import "SparkSetupCustomization.h"
#ifdef ANALYTICS
#import <SEGAnalytics.h>
#endif

@interface SparkManualNetworkViewController () <UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UIImageView *brandImageView;
@property (weak, nonatomic) IBOutlet UITextField *networkNameTextField;
@property (weak, nonatomic) IBOutlet UISwitch *networkRequiresPasswordSwitch;
@property (weak, nonatomic) IBOutlet UIImageView *wifiSymbolImageView;
@property (weak, nonatomic) IBOutlet UIButton *backButton;

@end

@implementation SparkManualNetworkViewController

- (UIStatusBarStyle)preferredStatusBarStyle
{
    return ([SparkSetupCustomization sharedInstance].lightStatusAndNavBar) ? UIStatusBarStyleLightContent : UIStatusBarStyleDefault;
}



- (void)viewDidLoad {
    [super viewDidLoad];

    // move to super viewdidload?
    self.brandImageView.image = [SparkSetupCustomization sharedInstance].brandImage;
    self.brandImageView.backgroundColor = [SparkSetupCustomization sharedInstance].brandImageBackgroundColor;
    
    UIColor *navBarButtonsColor = ([SparkSetupCustomization sharedInstance].lightStatusAndNavBar) ? [UIColor whiteColor] : [UIColor blackColor];
    [self.backButton setTitleColor:navBarButtonsColor forState:UIControlStateNormal];

    
    // Trick to add an inset from the left of the text fields
    CGRect  viewRect = CGRectMake(0, 0, 10, 32);
    UIView* emptyView = [[UIView alloc] initWithFrame:viewRect];
    
    self.networkNameTextField.leftView = emptyView;
    self.networkNameTextField.leftViewMode = UITextFieldViewModeAlways;
    self.networkNameTextField.delegate = self;
    self.networkNameTextField.returnKeyType = UIReturnKeyJoin;
    self.networkNameTextField.font = [UIFont fontWithName:[SparkSetupCustomization sharedInstance].normalTextFontName size:16.0];

    self.networkRequiresPasswordSwitch.onTintColor = [SparkSetupCustomization sharedInstance].elementBackgroundColor;
    
    self.wifiSymbolImageView.image = [self.wifiSymbolImageView.image imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
    self.wifiSymbolImageView.tintColor = [SparkSetupCustomization sharedInstance].normalTextColor;// elementBackgroundColor;;

    self.backButton.imageView.image = [self.backButton.imageView.image imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
    self.backButton.imageView.tintColor = [SparkSetupCustomization sharedInstance].normalTextColor;// elementBackgroundColor;;
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



-(void)viewWillAppear:(BOOL)animated
{
#ifdef ANALYTICS
    [[SEGAnalytics sharedAnalytics] track:@"Device Setup: Manual network entry screen"];
#endif
}


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/



- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([[segue identifier] isEqualToString:@"connect"])
    {
        // Get reference to the destination view controller
        SparkConnectingProgressViewController *vc = [segue destinationViewController];
        vc.networkName = self.networkNameTextField.text;
        vc.channel = @0; // unknown
        vc.security = @(SparkSetupWifiSecurityTypeOpen);
        vc.password = @""; // non secure network
        vc.deviceID = self.deviceID; // propagate device ID
        vc.needToClaimDevice = self.needToClaimDevice;
    }
    if ([[segue identifier] isEqualToString:@"require_password"]) // prompt user for password
    {
        // Get reference to the destination view controller
        SparkSetupPasswordEntryViewController *vc = [segue destinationViewController];
        vc.networkName = self.networkNameTextField.text;
        vc.channel = @0; // unknown
        vc.security = @(SparkSetupWifiSecurityTypeWPA2_AES_PSK); // default
        vc.deviceID = self.deviceID; // propagate device ID
        vc.needToClaimDevice = self.needToClaimDevice;
    }
}




- (IBAction)connectButtonTapped:(id)sender
{
    if (![self.networkNameTextField.text isEqualToString:@""])
    {
        [self.view endEditing:YES];
        if (self.networkRequiresPasswordSwitch.isOn)
        {
#ifdef ANALYTICS
            [[SEGAnalytics sharedAnalytics] track:@"Device Setup: Selected secured network"];
#endif
            [self performSegueWithIdentifier:@"require_password" sender:self];
        }
        else
        {
#ifdef ANALYTICS
            [[SEGAnalytics sharedAnalytics] track:@"Device Setup: Selected open network"];
#endif
            [self performSegueWithIdentifier:@"connect" sender:self];
            
        }
    }
    
    
    
}


- (IBAction)cancelButtonTapped:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}


-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if (textField == self.networkNameTextField)
    {
        [self connectButtonTapped:self];
    }
    
    return YES;
}

@end
