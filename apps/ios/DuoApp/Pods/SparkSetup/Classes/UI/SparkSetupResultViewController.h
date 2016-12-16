//
//  SparkSetupSuccessFailureViewController.h
//  teacup-ios-app
//
//  Created by Ido on 2/3/15.
//  Copyright (c) 2015 spark. All rights reserved.
//

#import "SparkSetupUIViewController.h"
#import "SparkSetupMainController.h"


@class SparkDevice;

@interface SparkSetupResultViewController : SparkSetupUIViewController
@property (nonatomic, strong) SparkDevice *device; // device instance for successful setup
@property (nonatomic, strong) NSString *deviceID; // device ID reporting for failed setup
@property (nonatomic) SparkSetupMainControllerResult setupResult;

@end
