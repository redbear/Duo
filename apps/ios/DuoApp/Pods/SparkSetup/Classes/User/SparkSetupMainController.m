//
//  SparkSetupManager.m
//  mobile-sdk-ios
//
//  Created by Ido Kleinman on 11/15/14.
//  Copyright (c) 2014-2015 Spark. All rights reserved.
//

#import "SparkSetupMainController.h"
#import "SparkUserSignupViewController.h"
#import "SparkSetupCommManager.h"
#import "SparkSetupConnection.h"
#ifdef FRAMEWORK
#import <ParticleSDK/ParticleSDK.h>
#else
#import "Spark-SDK.h"
#endif

#import "SparkSetupCustomization.h"
#import "SparkUserLoginViewController.h"
#import "SparkSetupUIElements.h"

//#define SPARK_SETUP_RESOURCE_BUNDLE_IDENTIFIER  @"io.spark.SparkSetup"

NSString *const kSparkSetupDidFinishNotification = @"kSparkSetupDidFinishNotification";
NSString *const kSparkSetupDidFinishStateKey = @"kSparkSetupDidFinishStateKey";
NSString *const kSparkSetupDidFinishDeviceKey = @"kSparkSetupDidFinishDeviceKey";
NSString *const kSparkSetupDidLogoutNotification = @"kSparkSetupDidLogoutNotification";
NSString *const kSparkSetupDidFailDeviceIDKey = @"kSparkSetupDidFailDeviceIDKey";

@interface SparkSetupMainController() <SparkUserLoginDelegate>

//@property (nonatomic, strong) UINavigationController *setupNavController;
@property (weak, nonatomic) IBOutlet UIView *containerView;
@property (nonatomic, strong) UIViewController *currentVC;
@property (nonatomic) BOOL authenticationOnly;
@property (nonatomic) BOOL setupOnly;
@end

@implementation SparkSetupMainController

- (UIStatusBarStyle)preferredStatusBarStyle
{
    return ([SparkSetupCustomization sharedInstance].lightStatusAndNavBar) ? UIStatusBarStyleLightContent : UIStatusBarStyleDefault;
}


+(NSBundle *)getResourcesBundle
{
#ifdef FRAMEWORK
    // frameework has assets as
    NSBundle *bundle = [NSBundle bundleForClass:self];
#else
    NSBundle *bundle = [NSBundle bundleWithURL:[[NSBundle bundleForClass:[self class]] URLForResource:@"SparkSetup" withExtension:@"bundle"]];
#endif
    return bundle;
}


+(UIStoryboard *)getSetupStoryboard
{
    UIStoryboard *setupStoryboard = [UIStoryboard storyboardWithName:@"setup" bundle:[SparkSetupMainController getResourcesBundle]];
    return setupStoryboard;
}

+(UIImage *)loadImageFromResourceBundle:(NSString *)imageName
{
    NSBundle *bundle = [SparkSetupMainController getResourcesBundle];
    NSString *imageFileName = [NSString stringWithFormat:@"%@.png",imageName];
    UIImage *image = [UIImage imageNamed:imageFileName inBundle:bundle compatibleWithTraitCollection:nil];
    return image;
}

-(instancetype)init
{
    SparkSetupMainController* mainVC = [super initWithNibName:nil bundle:nil]; // super init is not actually required, but supress the warning
    self.authenticationOnly = NO;
    
    @try {
        mainVC = [[SparkSetupMainController getSetupStoryboard] instantiateViewControllerWithIdentifier:@"root"];
    }
    @catch (NSException *exception) {
        return nil;
    }
    
    return mainVC;
}


-(instancetype)initWithSetupOnly:(BOOL)yesOrNo
{
    SparkSetupMainController* mainVC = [self init];
    self.setupOnly = yesOrNo;
    return mainVC;
}


-(instancetype)initWithAuthenticationOnly:(BOOL)yesOrNo
{
    SparkSetupMainController* mainVC = [self init];
    self.authenticationOnly = yesOrNo;
    return mainVC;
}

-(void)viewDidLoad
{
    [super viewDidLoad];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(setupDidFinishObserver:) name:kSparkSetupDidFinishNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(setupDidLogoutObserver:) name:kSparkSetupDidLogoutNotification object:nil];
    
    if ([SparkCloud sharedInstance].isAuthenticated)
    {
        // start from discover screen if user is already logged in
        if (self.authenticationOnly == NO)
        {
            [self runSetup];
        }
        else
        {
            // add a small delay and perform in another thread to let viewDidload finish, otherwise we might get a deadlock black screen
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [[NSNotificationCenter defaultCenter] postNotificationName:kSparkSetupDidFinishNotification object:nil userInfo:@{kSparkSetupDidFinishStateKey:@(SparkSetupMainControllerResultLoggedIn)}];
            });
        }
    }
    else
    {
        if (self.setupOnly)
            [self runSetup];
        else
            [self showSignup];
    }


}

-(void)runSetup
{
    UINavigationController* setupVC = [[SparkSetupMainController getSetupStoryboard] instantiateViewControllerWithIdentifier:@"setup"];
    [self showViewController:setupVC];
}

-(void)showSignup
{
    SparkUserSignupViewController *signupVC = [[SparkSetupMainController getSetupStoryboard] instantiateViewControllerWithIdentifier:@"signup"];
    signupVC.delegate = self;
    [self showViewController:signupVC];
}


-(void)showSignupWithPredefinedActivationCode:(NSString *)activationCode;
{
    // __deprecated
    SparkUserSignupViewController *signupVC = [[SparkSetupMainController getSetupStoryboard] instantiateViewControllerWithIdentifier:@"signup"];
//    signupVC.predefinedActivationCode = activationCode;
    signupVC.delegate = self;
    [self showViewController:signupVC];
}


-(void)showLogin
{
    SparkUserLoginViewController *loginVC = [[SparkSetupMainController getSetupStoryboard] instantiateViewControllerWithIdentifier:@"login"];
    loginVC.delegate = self;
    [self showViewController:loginVC];
}

-(void)showPasswordReset
{
    SparkUserLoginViewController *pwdrstVC = [[SparkSetupMainController getSetupStoryboard] instantiateViewControllerWithIdentifier:@"password_reset"];
    pwdrstVC.delegate = self;
    [self showViewController:pwdrstVC];
}


-(void)setupDidLogoutObserver:(NSNotification *)note
{
    // User intentionally logged out so display the login/signup screens
    [self showLogin];
}

#pragma mark SparkUserLoginDelegate methods
//-(void)didFinishUserLogin:(id)sender
-(void)didFinishUserAuthentication:(id)sender loggedIn:(BOOL)loggedIn;
{
    if (self.authenticationOnly)
    {
        // if authentication only requested than just post a notification to remove modal screen and return to calling app
        // add a small delay and perform in another thread to let viewDidload finish (if we're still in it), otherwise we might get a deadlock black screen
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            if (loggedIn)
                [[NSNotificationCenter defaultCenter] postNotificationName:kSparkSetupDidFinishNotification object:nil userInfo:@{kSparkSetupDidFinishStateKey:@(SparkSetupMainControllerResultLoggedIn)}];
            else
                [[NSNotificationCenter defaultCenter] postNotificationName:kSparkSetupDidFinishNotification object:nil userInfo:@{kSparkSetupDidFinishStateKey:@(SparkSetupMainControllerResultSkippedAuth)}];
            
        });
    }
    else
    {
        
        [self runSetup];
    }
}


-(void)didRequestPasswordReset:(id)sender
{
    [self showPasswordReset];
}

-(void)didRequestUserSignup:(id)sender
{
    [self showSignup];
}

-(void)didRequestUserLogin:(id)sender
{
    [self showLogin];
}

#pragma mark Observer for setup end notifications
-(void)setupDidFinishObserver:(NSNotification *)note
{
    // Setup finished so dismiss modal main controller and call delegate with state
    
    NSDictionary *finishStateDict = note.userInfo;
    NSNumber* state = finishStateDict[kSparkSetupDidFinishStateKey];
    SparkDevice *device = finishStateDict[kSparkSetupDidFinishDeviceKey];
    NSString *deviceID = finishStateDict[kSparkSetupDidFailDeviceIDKey];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:kSparkSetupDidFinishNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:kSparkSetupDidLogoutNotification object:nil];
    
    
    [self dismissViewControllerAnimated:YES completion:^{
        [self.delegate sparkSetupViewController:self didFinishWithResult:[state integerValue] device:device]; // TODO: add NSError reporting?
        if ((!device) && (deviceID)) {
            if ([self.delegate respondsToSelector:@selector(sparkSetupViewController:didNotSucceeedWithDeviceID:)]) {
                [self.delegate sparkSetupViewController:self didNotSucceeedWithDeviceID:deviceID];
            }
        }
    }];
}

// viewcontroller container behaviour code
- (void)showViewController:(UIViewController *)viewController
{
    if (self.currentVC)
    {
        [self addChildViewController:viewController];
        [self transitionFromViewController:self.currentVC toViewController:viewController duration:0.5f options:UIViewAnimationOptionTransitionFlipFromTop animations:nil completion:nil];
        [self hideViewController:self.currentVC];
    }
    self.currentVC = viewController;
    [self.containerView endEditing:YES];
    [self addChildViewController:viewController];
    viewController.view.frame = self.containerView.bounds;
    [self.containerView addSubview:viewController.view];
    [viewController didMoveToParentViewController:self];
}

- (void)hideViewController:(UIViewController *)viewController;
{
    [self.containerView endEditing:YES];
    [viewController willMoveToParentViewController:nil];
    [viewController.view removeFromSuperview];
    [viewController removeFromParentViewController];
}


-(void)dealloc
{
    // check
    [[NSNotificationCenter defaultCenter] removeObserver:self name:kSparkSetupDidFinishNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:kSparkSetupDidLogoutNotification object:nil];

}


@end
