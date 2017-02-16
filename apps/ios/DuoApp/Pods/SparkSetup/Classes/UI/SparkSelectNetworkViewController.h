//
//  SparkSelectNetworkViewController.h
//  mobile-sdk-ios
//
//  Created by Ido Kleinman on 11/19/14.
//  Copyright (c) 2014-2015 Spark. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SparkSetupUIViewController.h"

@protocol SparkSelectNetworkViewControllerDelegate <NSObject>

-(void)willPopBackToDeviceDiscovery;

@end

@interface SparkSelectNetworkViewController : SparkSetupUIViewController
@property (nonatomic, strong) NSArray *wifiList;
@property (nonatomic, strong) NSString *deviceID;
@property (nonatomic) BOOL needToClaimDevice;
@property (nonatomic, weak) id <SparkSelectNetworkViewControllerDelegate> delegate;
@end


