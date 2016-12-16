//
//  SparkSetupManager.h
//  mobile-sdk-ios
//
//  Created by Ido Kleinman on 11/15/14.
//  Copyright (c) 2014-2015 Spark. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "SparkSetupCustomization.h"
//#ifdef FRAMEWORK
//#import <ParticleSDK/ParticleSDK.h>
//#else
//#import "Spark-SDK.h"
//#endif

typedef NS_ENUM(NSInteger, SparkSetupMainControllerResult) {
    SparkSetupMainControllerResultSuccess=1,
//    SparkSetupMainControllerResultFailure,                        // DEPRECATED starting 0.5.0
    SparkSetupMainControllerResultUserCancel,                       // User cancelled setup
    SparkSetupMainControllerResultLoggedIn,                         // relevant to initWithAuthenticationOnly:YES only (user successfully logged in)
    SparkSetupMainControllerResultSkippedAuth,                      // relevant to initWithAuthenticationOnly:YES only (user skipped authentication)
    SparkSetupMainControllerResultSuccessNotClaimed,                // Setup finished successfully but device does not belong to currently logged in user so cannot be determined if it came online
    
    SparkSetupMainControllerResultSuccessDeviceOffline,             // new 0.5.0 -- Setup finished successfully but device did not come online - might indicate a problem
    SparkSetupMainControllerResultFailureClaiming,                  // new 0.5.0 -- setup was aborted because device claiming device timed out
    SparkSetupMainControllerResultFailureConfigure,                 // new 0.5.0 -- Setup process couldn't send configure command to device - device Wi-fi network connection might have been dropped, running setup again after putting device back in listen mode is advised.
    SparkSetupMainControllerResultFailureCannotDisconnectFromDevice,// new 0.5.0 -- Setup process couldn't disconnect from the device setup Wi-fi network. Usually an internal issue with the device, running setup again after putting device back in listen mode is advised.
    SparkSetupMainControllerResultFailureLostConnectionToDevice     // new 0.5.0 -- Setup lost connection to the device Wi-Fi / dropped port before finalizing configuration process.
};

extern NSString *const kSparkSetupDidLogoutNotification;
extern NSString *const kSparkSetupDidFinishNotification;
extern NSString *const kSparkSetupDidFinishStateKey;
extern NSString *const kSparkSetupDidFinishDeviceKey;
extern NSString *const kSparkSetupDidFailDeviceIDKey;

@class SparkSetupMainController;
@class SparkDevice;

@protocol SparkSetupMainControllerDelegate
@required
/**
 *  Method will be called whenever SparkSetup wizard completes
 *
 *  @param controller Instance of main SparkSetup viewController
 *  @param result     Result of setup completion - can be success, failure or user-cancelled.
 *  @param device     SparkDevice instance in case the setup completed successfully and a SparkDevice was claimed to logged in user
 */
- (void)sparkSetupViewController:(SparkSetupMainController *)controller didFinishWithResult:(SparkSetupMainControllerResult)result device:(SparkDevice *)device;

@optional
/**
 *  Optional delegate method that will be called whenever SparkSetup wizard completes unsuccessfully in the following states: (new from 0.5.0)
 *  SuccessDeviceOffline, FailureClaiming, FailutreConfigure, FailureCannotDisconnectFromDevice, LostConnectionToDevice, SuccessNotClaimed
 *
 *  @param controller Instance of main SparkSetup viewController
 *  @param deviceID   Device ID string of the device which was last tried to be setup
 */

- (void)sparkSetupViewController:(SparkSetupMainController *)controller didNotSucceeedWithDeviceID:(NSString *)deviceID;

@end


@interface SparkSetupMainController : UIViewController

// Viewcontroller displaying the modal setup UI control
@property (nonatomic, weak) UIViewController<SparkSetupMainControllerDelegate>* delegate;

/**
 *  Entry point for invoking Spark Soft AP setup wizard, use by calling this on your viewController:
 *  SparkSetupMainController *setupController = [[SparkSetupMainController alloc] init]; // or [SparkSetupMainController new]
 *  [self presentViewController:setupController animated:YES completion:nil];
 *  If no active user session exists than this call will also authenticate user to the Spark cloud (or allow her to sign up) before the soft AP wizard will be displayed
 *
 *  @return An initialized SparkSetupMainController instance ready to be presented.
 */
-(instancetype)init; // NS_DESIGNATED_INITIALIZER;

/**
 *  Entry point for invoking Spark Cloud authentication (login/signup/password recovery screens) only, use by calling this on your viewController:
 *  SparkSetupMainController *setupController = [[SparkSetupMainController alloc] initWithAuthenticationOnly];
 *  [self presentViewController:setupController animated:YES completion:nil];
 *  After user has successfully logged in or signed up, control will be return to the calling app. If an active user session already exists control will be returned immediately
 *
 *  @param yesOrNo YES will invoke Authentication wizard only, NO will invoke whole Device Setup process (will skip authentication if user session is active, same as calling -init)
 *
 *  @return An inititalized SparkSetupMainController instance ready to be presented.
 */
-(instancetype)initWithAuthenticationOnly:(BOOL)yesOrNo;


/**
 *  Entry point for invoking Spark Cloud setup process only - used for configuring device Wi-Fi credentials without changing its ownership.
 *  If active user session exists - it'll be used and device will be claimed, otherwise no. Calling -initWithSetupOnly: method with an active user session is
 *  essentially the same as calling -init:
 *  use by calling this on your viewController:
 *  SparkSetupMainController *setupController = [[SparkSetupMainController alloc] initWithSetupOnly];
 *  [self presentViewController:setupController animated:YES completion:nil];
 *  After user has successfully logged in or signed up, control will be return to the calling app. If an active user session already exists control will be returned immediately
 *
 *  @param yesOrNo YES will invoke Setup wizard only, NO will invoke whole Device Setup process (will skip authentication if user session is active, same as calling -init)
 *
 *  @return An inititalized SparkSetupMainController instance ready to be presented.
 */
-(instancetype)initWithSetupOnly:(BOOL)yesOrNo;


/**
 *  Open setup wizard in Signup screen with a pre-filled activation code from a URL scheme which was used to open the app.
 *  Deprecated since pod v0.3.0
 *
 *  @param activationCode Activation code string
 */
-(void)showSignupWithPredefinedActivationCode:(NSString *)activationCode __deprecated;

/**
 *  Get default resource bundle for Spark Soft AP setup wizard assets
 *
 *  @return Default assets resource NSBundle instance
 */
+(NSBundle *)getResourcesBundle;
+(UIStoryboard *)getSetupStoryboard;
+(UIImage *)loadImageFromResourceBundle:(NSString *)imageName;


@end


