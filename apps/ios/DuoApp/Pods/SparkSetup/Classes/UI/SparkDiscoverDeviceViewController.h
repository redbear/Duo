//
//  SparkDiscoverDeviceViewController.h
//  mobile-sdk-ios
//
//  Created by Ido Kleinman on 11/16/14.
//  Copyright (c) 2014-2015 Spark. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SparkSetupUIViewController.h"
#import "SparkSetupMainController.h"

@interface SparkDiscoverDeviceViewController : SparkSetupUIViewController
@property (nonatomic, strong) NSString *claimCode;
@property (nonatomic, strong) NSArray *claimedDevices;

@end
