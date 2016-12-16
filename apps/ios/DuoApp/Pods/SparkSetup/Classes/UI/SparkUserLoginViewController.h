//
//  SparkUserLoginViewController.h
//  mobile-sdk-ios
//
//  Created by Ido Kleinman on 11/26/14.
//  Copyright (c) 2014-2015 Spark. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SparkSetupUIViewController.h"
#import "SparkUserSignupViewController.h"

@interface SparkUserLoginViewController : SparkSetupUIViewController
@property (nonatomic, strong) id<SparkUserLoginDelegate> delegate;
@end
