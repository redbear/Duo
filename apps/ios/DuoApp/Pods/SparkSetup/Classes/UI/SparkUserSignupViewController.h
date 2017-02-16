//
//  SparkUserSignupViewController.h
//  mobile-sdk-ios
//
//  Created by Ido Kleinman on 11/15/14.
//  Copyright (c) 2014-2015 Spark. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SparkSetupUIViewController.h"

@protocol SparkUserLoginDelegate <NSObject>
@required
-(void)didFinishUserAuthentication:(id)sender loggedIn:(BOOL)loggedIn;
-(void)didRequestUserSignup:(id)sender;
-(void)didRequestUserLogin:(id)sender;
-(void)didRequestPasswordReset:(id)sender;
@end


@interface SparkUserSignupViewController : SparkSetupUIViewController
@property (nonatomic, strong) id<SparkUserLoginDelegate> delegate;
@property (nonatomic, strong) NSString *predefinedActivationCode;

@end
