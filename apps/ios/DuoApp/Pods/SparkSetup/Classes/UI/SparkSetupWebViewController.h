//
//  SparkSetupWebViewController.h
//  mobile-sdk-ios
//
//  Created by Ido Kleinman on 12/12/14.
//  Copyright (c) 2014-2015 Spark. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SparkSetupUIViewController.h"

@interface SparkSetupWebViewController : SparkSetupUIViewController
@property (nonatomic, strong) NSURL *link;
@property (nonatomic, strong) NSString *htmlFilename;
@property (nonatomic, strong) NSString *htmlFileDirectory;
@end


