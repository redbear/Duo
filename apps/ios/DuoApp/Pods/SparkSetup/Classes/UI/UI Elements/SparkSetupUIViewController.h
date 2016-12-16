//
//  SparkSetupViewController.h
//  mobile-sdk-ios
//
//  Created by Ido Kleinman on 12/13/14.
//  Copyright (c) 2014-2015 Spark. All rights reserved.
//

#import <UIKit/UIKit.h>

#define SPARK_SETUP_RESOURCE_BUNDLE_IDENTIFIER  @"io.spark.SparkSetup"

#define IS_IPHONE (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)
#define isiPhone4  ([[UIScreen mainScreen] bounds].size.height == 480) ? YES : NO
#define isiPhone5 (IS_IPHONE && [[UIScreen mainScreen] bounds].size.height == 568.0)

@interface SparkSetupUIViewController : UIViewController

-(BOOL)isValidEmail:(NSString *)checkString; // should be in NSString category
-(void)disableKeyboardMovesViewUp; // might not be needed when we remove all popups

@end
