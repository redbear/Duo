//
//  SparkUserForgotPasswordViewController.h
//  teacup-ios-app
//
//  Created by Ido on 2/13/15.
//  Copyright (c) 2015 spark. All rights reserved.
//

#import "SparkSetupUIViewController.h"
#import "SparkUserLoginViewController.h"

@interface SparkUserForgotPasswordViewController : SparkSetupUIViewController
@property (nonatomic, strong) id<SparkUserLoginDelegate> delegate;
@end
