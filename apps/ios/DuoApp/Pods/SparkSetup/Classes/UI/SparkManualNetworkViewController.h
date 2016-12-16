//
//  SparkManualNetworkViewController.h
//  teacup-ios-app
//
//  Created by Ido on 2/22/15.
//  Copyright (c) 2015 spark. All rights reserved.
//

#import "SparkSetupUIViewController.h"

@interface SparkManualNetworkViewController : SparkSetupUIViewController
@property (nonatomic, strong) NSString *deviceID;
@property (nonatomic) BOOL needToClaimDevice;
@end
