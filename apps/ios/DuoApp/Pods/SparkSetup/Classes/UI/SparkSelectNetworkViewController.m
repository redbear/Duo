//
//  SparkSelectNetworkViewController.m
//  mobile-sdk-ios
//
//  Created by Ido Kleinman on 11/19/14.
//  Copyright (c) 2014-2015 Spark. All rights reserved.
//

#import "SparkSelectNetworkViewController.h"
#import "SparkSetupPasswordEntryViewController.h"
#import "SparkConnectingProgressViewController.h"
#import "SparkSetupCommManager.h"
#import "SparkSetupCustomization.h"
#import "SparkSetupUIElements.h"
#import "SparkManualNetworkViewController.h"
#import "SparkSetupMainController.h"
#import "SparkSetupCustomization.h"
#import "SparkSetupWifiTableViewCell.h"

#ifdef ANALYTICS
#import <SEGAnalytics.h>
#endif

// TODO: move it somewhere else
#define kSparkWifiRSSIThresholdStrong   -56
#define kSparkWifiRSSIThresholdWeak     -71



@interface SparkSelectNetworkViewController () <UITableViewDataSource, UITableViewDelegate>
@property (weak, nonatomic) IBOutlet UITableView *wifiTableView;
@property (weak, nonatomic) IBOutlet UIImageView *brandImageView;
@property (weak, nonatomic) IBOutlet UIButton *refreshButton;
@property (weak, nonatomic) IBOutlet UILabel *selectNetworkLabel;
@property (weak, nonatomic) IBOutlet SparkSetupUISpinner *spinner;

@property (nonatomic, strong) NSIndexPath *selectedNetworkIndexPath;
@property (nonatomic, strong) NSTimer *checkConnectionTimer;
@property (nonatomic, strong) NSString *selectedNetworkSSID;
@property (nonatomic, strong) NSNumber *selectedNetworkSecurity;
@property (nonatomic, strong) NSNumber *selectedNetworkChannel;

@end

@implementation SparkSelectNetworkViewController

- (UIStatusBarStyle)preferredStatusBarStyle
{
    return ([SparkSetupCustomization sharedInstance].lightStatusAndNavBar) ? UIStatusBarStyleLightContent : UIStatusBarStyleDefault;
}



- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.wifiTableView.delegate = self;
    self.wifiTableView.dataSource = self;
    self.wifiTableView.backgroundColor = [UIColor clearColor];
    
    // move to super viewdidload?
    self.brandImageView.image = [SparkSetupCustomization sharedInstance].brandImage;
    self.brandImageView.backgroundColor = [SparkSetupCustomization sharedInstance].brandImageBackgroundColor;

    [self sortWifiList];

//    if ([SparkSetupCustomization sharedInstance].tintSetupImages)
//    {
        self.wifiTableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
//    }
//    else
//    {
//        self.wifiTableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
//        self.wifiTableView.separatorColor = [SparkSetupCustomization sharedInstance].normalTextColor;
//    }

//    self.wifiTableView.layer.borderWidth = 0.5;
//    self.wifiTableView.backgroundColor = [SparkSetupCustomization sharedInstance].brandImageBackgroundColor;

    // temporary test init
    /*
    self.wifiList = @[
                      @{@"ssid" : @"network1", @"rssi" : @-70, @"sec" : @1},
                      @{@"ssid" : @"some-wifi", @"rssi" : @-75, @"sec" : @1},
                      @{@"ssid" : @"open_wifi", @"rssi" : @-80, @"sec" : @0},
                      @{@"ssid" : @"anotherone", @"rssi" : @-90, @"sec" : @1},
                      @{@"ssid" : @"hide_yer_kids_hide_yer_wifi", @"rssi" : @-65, @"sec" : @YES}];
     
     */
    
}


-(void)sortWifiList
{
    
    // sort by strength:
    
//    NSDictionary *lastNetwork;

    // sort alphabeticly
    
    NSSortDescriptor *descriptor = [[NSSortDescriptor alloc] initWithKey:@"ssid" ascending:YES comparator:^NSComparisonResult(id obj1, id obj2) {
        NSString *s1 = obj1;
        NSString *s2 = obj2;
        return [s1 caseInsensitiveCompare:s2];
    }];
    

    self.wifiList = [self.wifiList sortedArrayUsingDescriptors:[NSArray arrayWithObjects:descriptor,nil]];
    
    NSMutableArray *noDupesWifiList = [NSMutableArray new];
    
    // remove similar named SSIDs - choose strongest
    for (NSDictionary *network in self.wifiList)
    {
        NSDictionary *strongestNetwork = network;
        for (NSDictionary *sameNameNetwork in self.wifiList)
        {
            if ([sameNameNetwork[@"ssid"] isEqualToString:network[@"ssid"]])
            {
                if ([sameNameNetwork[@"rssi"] integerValue] > [strongestNetwork[@"rssi"] integerValue])
                {
                    strongestNetwork = sameNameNetwork;
                }
            }
            
        }
        
        BOOL strongestNetworkAdded = NO;
        for (NSDictionary *addedNetwork in noDupesWifiList)
        {
            if ([addedNetwork[@"ssid"] isEqualToString:strongestNetwork[@"ssid"]])
            {
                strongestNetworkAdded = YES;
            }
        }
        
        if (!strongestNetworkAdded)
            [noDupesWifiList addObject:strongestNetwork];
    }
    
    self.wifiList = [noDupesWifiList copy];

}


-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifer = @"wifiCell";
    SparkSetupWifiTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifer forIndexPath:indexPath];
    
    // Using a cell identifier will allow your app to reuse cells as they come and go from the screen.
//    if (cell == nil)
//    {
//        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifer];
//    }
//    
    NSUInteger row = [indexPath row];
    
//    UILabel *textLabel = (UILabel *)[cell.contentView viewWithTag:10];
    cell.ssidLabel.text = self.wifiList[row][@"ssid"];
//    textLabel.text
    cell.ssidLabel.textColor = [SparkSetupCustomization sharedInstance].normalTextColor;
    
//    UIImageView *signalStrengthImageView = cell.wifiStrengthImageView; // (UIImageView *)[cell.contentView viewWithTag:30];
    
    int rssi = [self.wifiList[row][@"rssi"] intValue];
    if (rssi > kSparkWifiRSSIThresholdStrong)
    {
        [cell.wifiStrengthImageView setImage:[SparkSetupMainController loadImageFromResourceBundle:@"wifi3"]];
    }
    else if (rssi > kSparkWifiRSSIThresholdWeak)
    {
        [cell.wifiStrengthImageView setImage:[SparkSetupMainController loadImageFromResourceBundle:@"wifi2"]];
    }
    else
    {
        [cell.wifiStrengthImageView setImage:[SparkSetupMainController loadImageFromResourceBundle:@"wifi1"]];
    }
    

    cell.wifiStrengthImageView.image = [cell.wifiStrengthImageView.image imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
    cell.wifiStrengthImageView.tintColor = [SparkSetupCustomization sharedInstance].normalTextColor;;

   
//    UIImageView *secureImageView = (UIImageView *)[cell.contentView viewWithTag:20];
    SparkSetupWifiSecurityType sec = [self.wifiList[row][@"sec"] intValue];
    if (sec != SparkSetupWifiSecurityTypeOpen)
    {
//        [cell.contentView viewWithTag:20].hidden = NO;
//        UIImageView *lock = cell.securedNetworkIconImageView; //(UIImageView *)[cell.contentView viewWithTag:20];
        cell.securedNetworkIconImageView.hidden = NO;
        [cell.securedNetworkIconImageView setImage:[SparkSetupMainController loadImageFromResourceBundle:@"lock"]];
        cell.securedNetworkIconImageView.image = [cell.securedNetworkIconImageView.image imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
        cell.securedNetworkIconImageView.tintColor = [SparkSetupCustomization sharedInstance].normalTextColor;;
    }
    else
    {
        cell.securedNetworkIconImageView.hidden = YES;
//        [cell.contentView viewWithTag:20].hidden = YES;
    }
    
    /*
    if ((indexPath.row % 2) == 0)
    {
        cell.backgroundColor = [UIColor colorWithRed: 0.1 green: 0.1 blue: 0.1 alpha: 0.25];
    }
    else // clear if even
    {
     */
    cell.backgroundColor = [UIColor clearColor];
//    }
    
    
     

//    [cell setNeedsLayout];
    return cell;
}


-(void)checkPhotonConnection:(id)sender
{
//    NSLog(@"checkPhotonConnection");
    if (![SparkSetupCommManager checkSparkDeviceWifiConnection:[SparkSetupCustomization sharedInstance].networkNamePrefix])
    {
        [self.checkConnectionTimer invalidate];
        [self.delegate willPopBackToDeviceDiscovery];
        [self.navigationController popViewControllerAnimated:YES];
    }
}




-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [self.wifiTableView reloadData];
    [self restartDeviceDetectionTimer];
    [self disableKeyboardMovesViewUp];

}

-(void)restartDeviceDetectionTimer
{
    [self.checkConnectionTimer invalidate];
    self.checkConnectionTimer = [NSTimer scheduledTimerWithTimeInterval:2.0f target:self selector:@selector(checkPhotonConnection:) userInfo:nil repeats:YES];

}



-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.wifiList count];
}



-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 44.0f;
}


- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    NSLog(@"sparkSelectNetworkVC prepareForSegue : %@",segue.identifier);
    [self.checkConnectionTimer invalidate];

    if ([[segue identifier] isEqualToString:@"connect"])
    {
        // Get reference to the destination view controller
        SparkConnectingProgressViewController *vc = [segue destinationViewController];
        vc.networkName = self.selectedNetworkSSID;
        vc.channel = self.selectedNetworkChannel;
        vc.security = self.selectedNetworkSecurity;
        vc.password = @""; // non secure network
        vc.deviceID = self.deviceID; // propagate device ID
        vc.needToClaimDevice = self.needToClaimDevice;
    }
    else if ([[segue identifier] isEqualToString:@"require_password"]) // prompt user for password
    {
        // Get reference to the destination view controller
        SparkSetupPasswordEntryViewController *vc = [segue destinationViewController];
        vc.networkName = self.selectedNetworkSSID;
        vc.channel = self.selectedNetworkChannel;
        vc.security = self.selectedNetworkSecurity;
        vc.deviceID = self.deviceID; // propagate device ID
        vc.needToClaimDevice = self.needToClaimDevice;
    }
    else if ([[segue identifier] isEqualToString:@"manual_network"]) // prompt user for password
    {
        // Get reference to the destination view controller
        SparkManualNetworkViewController *vc = [segue destinationViewController];
        vc.deviceID = self.deviceID; // propagate device ID
        vc.needToClaimDevice = self.needToClaimDevice;
    }
}



-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self.wifiTableView deselectRowAtIndexPath:indexPath animated:YES];
    self.selectedNetworkIndexPath = indexPath;

    SparkSetupWifiSecurityType secInt = [self.wifiList[indexPath.row][@"sec"] intValue];
    self.selectedNetworkSecurity = [NSNumber numberWithInt:secInt];
    self.selectedNetworkChannel = self.wifiList[indexPath.row][@"ch"];
    self.selectedNetworkSSID = self.wifiList[indexPath.row][@"ssid"];
    [self.checkConnectionTimer invalidate];
    
    if (secInt == SparkSetupWifiSecurityTypeOpen)
    {
#ifdef ANALYTICS
        [[SEGAnalytics sharedAnalytics] track:@"Device Setup: Selected open network"];
#endif
        [self performSegueWithIdentifier:@"connect" sender:self];
        
    }
    else
    {
#ifdef ANALYTICS
        [[SEGAnalytics sharedAnalytics] track:@"Device Setup: Selected secured network"];
#endif
        [self performSegueWithIdentifier:@"require_password" sender:self];
    }
  
}


//-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
//{
//    if (buttonIndex == 1)
//    {
//        NSString *password = [alertView textFieldAtIndex:0].text;
//        NSLog(@"password: %@",password);
//        [self connectToSelectedNetwork:self.selectedNetworkIndexPath withPassword:password];
//    }
//    else // User Cancelled
//        [self restartDeviceDetectionTimer];
//
//}


- (IBAction)manualNetworkButtonTapped:(id)sender
{
    
}


-(void)viewWillAppear:(BOOL)animated
{
#ifdef ANALYTICS
    [[SEGAnalytics sharedAnalytics] track:@"Device Setup: Select Network Screen"];
#endif
}



-(void)photonScanAP
{
    
    self.refreshButton.enabled = NO;
    [self.spinner startAnimating];
    SparkSetupCommManager *manager = [[SparkSetupCommManager alloc] init];
    [manager scanAP:^(id scanResponse, NSError *error) {
        [self.spinner stopAnimating];
        if (error)
        {
            NSLog(@"Could not send scan-ap command: %@",error.localizedDescription);
        }
        else
        {
            if (scanResponse) // check why getting two callbacks
            {
                self.wifiList = scanResponse;
                [self sortWifiList];
                [self.wifiTableView reloadData];
            }
            
        }
        self.refreshButton.enabled = YES;
    }];
}

- (IBAction)refreshScanButton:(id)sender
{
    [self photonScanAP];
}




@end
