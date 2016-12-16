//
//  SparkSetupCustomization.h
//  mobile-sdk-ios
//
//  Created by Ido Kleinman on 12/12/14.
//  Copyright (c) 2014-2015 Spark. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

//#define ANALYTICS   1     // comment out to disable Analytics 

@interface SparkSetupCustomization : NSObject

/**
 *  Spark soft AP setup wizard apperance customization proxy class
 *
 *  @return Singleton instance of the customization class
 */
+ (instancetype)sharedInstance;

@property (nonatomic, strong) NSString *deviceName;
@property (nonatomic, strong) UIImage *productImage;

@property (nonatomic, strong) NSString *brandName;
@property (nonatomic, strong) UIImage *brandImage;
@property (nonatomic, strong) UIColor *brandImageBackgroundColor;
@property (nonatomic, strong) NSString *instructionalVideoFilename;

@property (nonatomic, strong) NSString *modeButtonName;
@property (nonatomic, strong) NSString *listenModeLEDColorName;
@property (nonatomic, strong) NSString *networkNamePrefix;

// TODO: kill forgot password links
@property (nonatomic, strong) NSURL *termsOfServiceLinkURL; // URL for terms of service of the app/device usage
@property (nonatomic, strong) NSURL *privacyPolicyLinkURL;  // URL for privacy policy of the app/device usage
@property (nonatomic, strong) NSURL *forgotPasswordLinkURL; // URL for user password reset (non-organization setup app only)
@property (nonatomic, strong) NSURL *troubleshootingLinkURL; // URL for troubleshooting text of the app/device usage

@property (nonatomic, strong) NSString *termsOfServiceHTMLFile; // Static HTML for terms of service of the app/device usage
@property (nonatomic, strong) NSString *privacyPolicyHTMLFile;  // Static HTML for privacy policy of the app/device usage
@property (nonatomic, strong) NSString *forgotPasswordHTMLFile; // Static HTML for user password reset (non-organization setup app only)
@property (nonatomic, strong) NSString *troubleshootingHTMLFile; // Static HTML for troubleshooting text of the app/device usage

@property (nonatomic, strong) UIColor *pageBackgroundColor;
@property (nonatomic, strong) UIImage *pageBackgroundImage;
@property (nonatomic, strong) UIColor *normalTextColor;
@property (nonatomic, strong) UIColor *linkTextColor;

@property (nonatomic, strong) UIColor *elementBackgroundColor;  // Buttons/spinners background color
@property (nonatomic) BOOL lightStatusAndNavBar;

// TODO: change to:
//@property (nonatomic, strong) UIColor *buttonBackgroundColor; // new

@property (nonatomic, strong) UIColor *elementTextColor;        // Buttons text color
// TODO: change to:
//@property (nonatomic, strong) UIColor *buttonTextColor; // new
@property (nonatomic) BOOL tintSetupImages; // new // this will tint the checkmark/warning/ wifi symbols


@property (nonatomic, strong) NSString *normalTextFontName;     // Customize setup font - include OTF/TTF file in project

@property (nonatomic, strong) NSString *headerTextFontName; //new

@property (nonatomic, strong) NSString *boldTextFontName;       // Customize setup font - include OTF/TTF file in project


@property (nonatomic) CGFloat fontSizeOffset;                   // Set offset of font size so small/big fonts can be fine-adjusted

@property (nonatomic, assign) BOOL organization;        // enable organizational mode
@property (nonatomic, strong) NSString *organizationName;        // organization display name
@property (nonatomic, strong) NSString *organizationSlug;        // organizational name for API endpoint URL - must specify for orgMode
@property (nonatomic, strong) NSString *productName;    // product display name
@property (nonatomic, strong) NSString *productSlug;    // product string for API endpoint URL - must specify for orgMode

@property (nonatomic, assign) BOOL allowSkipAuthentication;      // allow user to skip authentication
@property (nonatomic, assign) BOOL allowPasswordManager;         // Display 1Password button next to password entry fields in login/signup
@property (nonatomic, strong) NSString *skipAuthenticationMessage;    // Prompt to display to user when he's requesting to skip authentication
@property (nonatomic) BOOL disableLogOutOption; // Do not allow the user to log out from the GetReady page.

@end
