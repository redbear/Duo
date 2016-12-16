//
//  SparkSetupCustomization.m
//  mobile-sdk-ios
//
//  Created by Ido Kleinman on 12/12/14.
//  Copyright (c) 2014-2015 Spark. All rights reserved.
//

#import "SparkSetupCustomization.h"
#import "SparkSetupMainController.h"



@interface UIColor(withDecimalRGB) // TODO: move to category in helpers
+(UIColor *)colorWithRed:(NSInteger)r green:(NSInteger)g blue:(NSInteger)b;
@end

@implementation UIColor(withDecimalRGB) // TODO: move to category in helpers
+(UIColor *)colorWithRed:(NSInteger)r green:(NSInteger)g blue:(NSInteger)b
{
    return [UIColor colorWithRed:((float)r/255.0f) green:((float)g/255.0f) blue:((float)b/255.0f) alpha:1.0f];
}
@end

@implementation SparkSetupCustomization


+(instancetype)sharedInstance
{
    static SparkSetupCustomization *sharedInstance = nil;
    @synchronized(self) {
        if (sharedInstance == nil)
        {
            sharedInstance = [[self alloc] init];
        }
    }
    return sharedInstance;
  
}



-(instancetype)init
{
    if (self = [super init])
    {
        // Defaults
        self.deviceName = @"Particle device";
//        self.deviceImage = [UIImage imageNamed:@"photon" inBundle:[SparkSetupMainController getResourcesBundle] compatibleWithTraitCollection:nil]; // TODO: make iOS7 compatible
        self.brandName = @"Particle";
//        self.brandImage = [UIImage imageNamed:@"spark-logo-head" inBundle:[SparkSetupMainController getResourcesBundle] compatibleWithTraitCollection:nil]; // TODO: make iOS7 compatible
        self.brandImage = [SparkSetupMainController loadImageFromResourceBundle:@"spark-logo-head"];
//        self.brandImageBackgroundColor = [UIColor colorWithRed:0.79f green:0.79f blue:0.79f alpha:1.0f];
        self.brandImageBackgroundColor = [UIColor colorWithRed:229 green:229 blue:237];
      
        self.modeButtonName = @"Setup button";
        self.networkNamePrefix = @"Photon";
        self.listenModeLEDColorName = @"blue";
//        self.appName = self.brandName;// @"SparkSetup";
        self.fontSizeOffset = 0;
        
        self.privacyPolicyLinkURL = [NSURL URLWithString:@"https://www.particle.io/legal/privacy"];
        self.termsOfServiceLinkURL = [NSURL URLWithString:@"https://www.particle.io/legal/terms-of-service"];
        self.forgotPasswordLinkURL = [NSURL URLWithString:@"https://login.particle.io/forgot"];
        self.troubleshootingLinkURL = [NSURL URLWithString:@"https://community.spark.io/t/spark-core-troubleshooting-guide-spark-team/696"];
        // TODO: add default HTMLs
        
//        self.normalTextColor = [UIColor blackColor];
        self.normalTextColor = [UIColor colorWithRed:28 green:26 blue:25];
        self.pageBackgroundColor = [UIColor colorWithWhite:0.94 alpha:1.0f];
//        self.pageBackgroundColor = [UIColor colorWithRed:250 green:250 blue:250];
        self.linkTextColor = [UIColor blueColor];
//        self.linkTextColor = [UIColor colorWithRed:6 green:165 blue:226];
//        self.errorTextColor = [UIColor redColor];
//        self.errorTextColor = [UIColor colorWithRed:254 green:71 blue:71];
//        self.elementBackgroundColor = [UIColor colorWithRed:0.84f green:0.32f blue:0.07f alpha:1.0f];
        self.elementBackgroundColor = [UIColor colorWithRed:0 green:165 blue:231];
        self.elementTextColor = [UIColor whiteColor];
        
        self.normalTextFontName = @"HelveticaNeue";
        self.boldTextFontName = @"HelveticaNeue-Bold";
        self.headerTextFontName = @"HelveticaNeue-Light";
        
        self.tintSetupImages = NO;
        self.lightStatusAndNavBar = YES;
        
        self.organization = NO;
        self.organizationSlug = @"particle";
        self.organizationName = @"Particle";
        self.productSlug = @"photon";
        self.productName = @"Photon";
        self.allowPasswordManager = YES;

        self.allowSkipAuthentication = NO;
        self.skipAuthenticationMessage = @"Skipping authentication will allow you to configure Wi-Fi credentials to your device but it will not be claimed to your account. Are you sure you want to skip authentication?";
        self.disableLogOutOption = NO;
        return self;
    }
    
    return nil;
}

@end
