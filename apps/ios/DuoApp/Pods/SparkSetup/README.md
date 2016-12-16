<p align="center" >
<img src="http://oi60.tinypic.com/116jd51.jpg" alt="Particle" title="Particle">
</p>

# Particle Device Setup library (beta)

[![Platform](https://img.shields.io/badge/platform-iOS-10a4fa.svg)]() [![license](https://img.shields.io/hexpm/l/plug.svg)]() [![version](https://img.shields.io/badge/pod-0.6.0-green.svg)]() [![Carthage compatible](https://img.shields.io/badge/Carthage-compatible-4BC51D.svg?style=flat)](https://github.com/Carthage/Carthage)


The Particle Device Setup library is meant for integrating the initial setup process of Particle devices in your app.
This library will enable you to easily invoke a standalone setup wizard UI for setting up internet-connected products
powered by a Particle device (Photon, P0, P1). The setup UI can be easily customized by a customization proxy class,
that includes: look & feel, colors, texts and fonts as well as custom brand logos and custom instructional video for your product. There are good defaults in place if you don’t set these properties, but you can override the look and feel as needed to suit the rest of your app.

The wireless setup process for the Photon uses very different underlying technology from the Core. Where the Core used TI SmartConfig, the Photon uses what we call “soft AP” — i.e.: the Photon advertises a Wi-Fi network, you join that network from your mobile app to exchange credentials, and then the Photon connects using the Wi-Fi credentials you supplied.

With the Device Setup library, you make one simple call from your app, for example when the user hits a “Setup my device” button, and a whole series of screens then guide the user through the setup process. When the process finishes, the app user is back on the screen where she hit the “setup my device” button, and your code has been passed an instance of the device she just setup and claimed.
iOS Device setup library is implemented as an open-source Cocoapod static library and also as Carthage dynamic framework dependancy. See [Installation](#installation) section for more details. It works well for both Objective-C and [Swift](#support-for-swift-projects) projects containing any type of dependencies.

**Rebranding notice**

Spark has been recently rebranded as Particle. 
Code currently contains `SparkSetup` keyword as classes prefixes. this will soon be replaced with `ParticleDeviceSetup`. 

## Usage

Official documentation can be found in [Particle docs website](https://docs.particle.io/reference/ios/#ios-device-setup-library).
Treat this `README` as the most updated resource.

### Basic

**Cocoapods**

Import `SparkSetup.h` in your view controller implementation file, use bridging header for Swift projects (See [Installation](#installation) section for more details).

**Carthage**

Use `#import <ParticleDeviceSetupLibrary/ParticleDeviceSetupLibrary.h>` in Obj-C files or `import ParticleDeviceSetupLibrary` for Swift files.

and then invoke the device setup wizard by:

**Objective-C**

```objc
SparkSetupMainController *setupController = [[SparkSetupMainController alloc] init];
setupController.delegate = self; // why? see "Advanced" section below 
[self presentViewController:setupController animated:YES completion:nil];
```

**Swift**

```swift
if let setupController = SparkSetupMainController()
{
    setupController.delegate = self
    self.presentViewController(setupController, animated: true, completion: nil)
}
```

Alternatively if your app requires separation between the Particle cloud authentication process and the device setup process you can call:

**Objective-C**

```objc
SparkSetupMainController *setupController = [[SparkSetupMainController alloc] initWithAuthenticationOnly:YES];
[self presentViewController:setupController animated:YES completion:nil];
```

**Swift**
```swift
if let setupController = SparkSetupMainController(authenticationOnly: true)
{
    self.presentViewController(setupController, animated: true, completion: nil)
}
```

This will invoke Particle Cloud authentication (login/signup/password recovery screens) only 
after user has successfully logged in or signed up, control will be returned to the calling app. 
If an active user session already exists control will be returned immediately.

####Configure device Wi-Fi credentials without claiming it

If your app requires the ability to let users configure device Wi-Fi credentials without changing its ownership you can also do that via `initWithSetupOnly`, 
and by allowing your users to skip authentication (see `allowSkipAuthentication` flag in customization section) if you present the authentication stage.
If an active user session exists - it'll be used and device will be claimed, otherwise it won't. 
So invoking setup without an active user session will go thru the setup steps required for configuring device Wi-Fi credentials but not for claiming it. 
However, calling `-initWithSetupOnly:` method with an active user session is essentially the same as calling `-init:`.
Usage:

```objc
SparkSetupMainController *setupController = [[SparkSetupMainController alloc] initWithSetupOnly:YES];
[self presentViewController:setupController animated:YES completion:nil];
```

**Swift**
```swift
if let setupController = SparkSetupMainController(setupOnly: true)
{
    self.presentViewController(setupController, animated: true, completion: nil)
}
```

####1Password support

Starting library version 0.6.0 1Password manager support has been added to the signup and login screens - no action is required from the user - 
if 1Password is installed on the iOS device the lock icon will appear in the password fields on those screen and will allow user to fill in his 
saved password (login) or create a new one (signup). Only recommendation is adding `LSApplicationQueriesSchemes = org-appextension-feature-password-management` key-value to your `info.plist` file in your app project.

For additional information read [here](https://github.com/AgileBits/onepassword-app-extension#use-case-1-native-app-login).


### Customization

Customize setup look and feel by accessing the `SparkSetupCustomization` singleton appearance proxy `[SparkSetupCustomization sharedInstance]`
and modify its default properties. Setting the properties in this class is optional. *(Replace NSString with String for Swift projects)*

#### Product/brand info:

```objc
 NSString *deviceName;                  // Device/product name 
 UIImage *productImage;                 // Custom product image to display in "Get ready" screen *new*
 NSString *brandName;                   // Your brand name
 UIImage *brandImage;                   // Your brand logo to fit in header of setup wizard screens
 UIColor *brandImageBackgroundColor;    // brand logo background color
 NSString *instructionalVideoFilename;  // Instructional video shown landscape full screen mode when "Show me how" button pressed on second setup screen
```

#### Technical data:

```objc
 NSString *modeButtonName;              // The mode button name on your product
 NSString *listenModeLEDColorName;      // The color of the LED when product is in listen mode
 NSString *networkNamePrefix;           // The SSID prefix of the Soft AP Wi-Fi network of your product while in listen mode
```

#### Links for legal/technical info:

```objc
 NSURL *termsOfServiceLinkURL;      // URL for terms of service of the app/device usage
 NSURL *privacyPolicyLinkURL;       // URL for privacy policy of the app/device usage
```

#### Look & feel:

```objc
 UIColor *pageBackgroundColor;     // setup screens background color
 UIImage *pageBackgroundImage;     // optional background image for setup screens
 UIColor *normalTextColor;         // normal text color
 UIColor *linkTextColor;           // link text color (will be underlined)
 UIColor *elementBackgroundColor;  // Buttons/spinners background color
 UIColor *elementTextColor;        // Buttons text color
 NSString *normalTextFontName;     // Customize setup font - include OTF/TTF file in project
 NSString *boldTextFontName;       // Customize setup font - include OTF/TTF file in project
 CGFloat fontSizeOffset;           // Set offset of font size so small/big fonts can be fine-adjusted
 BOOL tintSetupImages;             // This will tint the checkmark/warning/wifi symbols in the setup process to match text color (useful for dark backgrounds)
 BOOL lightStatusAndNavBar;        // Make navigation and status bar appear in white or black color characters to contrast the selected brandImage color // *New since v0.6.1*
```

#### Organization:

Setting `organization=YES` will enable organization mode which uses different API endpoints and requires special permissions (See Particle Dashboard).
*New since v0.2.2*

If you set `organization` to `YES` be sure to also provide the `organizationSlug` and `productSlug` your created in [Particle Dashboard](https://docs.particle.io/guide/tools-and-features/dashboard/).
Make sure you inject the `SparkCloud` class with scoped OAuth credentials for creating customers (so app users could create an account), [read here](https://docs.particle.io/reference/ios/#oauth-client-configuration) on how to do it correctly.
To learn how to create those credentials for your organization [read here](https://docs.particle.io/guide/how-to-build-a-product/authentication/#creating-an-oauth-client).

```objc
 BOOL organization;             // enable organizational mode
 NSString *organizationName;    // organization display name
 NSString *organizationSlug;    // organizational name for API endpoint URL - must specify for orgMode *new*
 NSString *productName;         // product display name *new*
 NSString *productSlug;         // product string for API endpoint URL - must specify for orgMode *new*
```

#### Skipping authentication:

*New since v0.3.0*

```objc
 BOOL allowSkipAuthentication;          // Allow user to skip authentication (skip button will appear on signup and login screens)
 NSString *skipAuthenticationMessage;   // Message to display to user when she's requesting to skip authentication (Yes/No question)
```

### Advanced

You can get an active instance of `SparkDevice` by making your viewcontroller conform to protocol `<SparkSetupMainControllerDelegate>` when setup wizard completes successfully:

```objc
-(void)sparkSetupViewController:(SparkSetupMainController *)controller didFinishWithResult:(SparkSetupMainControllerResult)result device:(SparkDevice *)device;
```

```swift
func sparkSetupViewController(controller: SparkSetupMainController!, didFinishWithResult result: SparkSetupMainControllerResult, device: SparkDevice!)
```

method will be called, if `(result == SparkSetupMainControllerResultSuccess)` or (or simply `(result == .Success)` in Swift) the device parameter will contain an active `SparkDevice` instance you can interact with
using the [iOS Cloud SDK](https://cocoapods.org/pods/Spark-SDK).
In case setup failed, aborted or was cancalled  you can determine the exact reason by consulting the documentation of the enum value `SparkSetupMainControllerResult`. See [here](https://github.com/spark/spark-setup-ios/blob/master/Classes/User/SparkSetupMainController.h#L18-31) for additional details.

If setup failed and you can still determine the device ID of the last device that was tried to be setup and failed by conforming to the @optional delegate function: (new since 0.5.0)

```objc
- (void)sparkSetupViewController:(SparkSetupMainController *)controller didNotSucceeedWithDeviceID:(NSString *)deviceID;
```

```swift
func sparkSetupViewController(controller: SparkSetupMainController!, didNotSucceeedWithDeviceID deviceID: String)
```


### Example
Cocoapods usage example app (in Swift) can be found [here](https://www.github.com/spark/spark-setup-ios-example/). Example app demonstates - invoking the setup wizard, customizing its UI and using the returned SparkDevice instance once 
setup wizard completes (delegate). Feel free to contribute to the example by submitting pull requests.

### Reference

Check out the [Reference in Cocoadocs website](http://cocoadocs.org/docsets/SparkSetup/) or consult the javadoc style comments in `SparkSetupCustomization.h` and `SparkSetupMainController.h` for each public method or property.
If the Device Setup library installation completed successfully - you should be able to press `Esc` to get an auto-complete hints from XCode for each public method or property in the library.

## Requirements / limitations

- iOS 8.0 and up supported
- Currently setup wizard displays on portait mode only.
- XCode 6.0 and up is required

## Installation

### Cocoapods

Particle Device Setup library is available through [CocoaPods](http://cocoapods.org). Cocoapods is an easy to use dependency manager for iOS.
You must have Cocoapods installed, if you don't then be sure to [Install Cocoapods](https://guides.cocoapods.org/using/getting-started.html) before you start:
To install the iOS Device Setup library, simply add the following line to your Podfile on main project folder:

```ruby
pod "SparkSetup"
```

and then run `pod update`. A new `.xcworkspace` file will be created for you to open by Cocoapods, open that workspace file in Xcode and you can start invoking a new instance of the setup process viewcontroller - refer to the examples above. Don't forget to add `#import "SparkSetup.h"` to the source file in which you want to invoke setup in (that is not required for swift projects).


#### Support for Swift projects
To use Particle Device Setup library from within Swift based projects - you'll need to configure a bridging header - please [read here](http://swiftalicio.us/2014/11/using-cocoapods-from-swift/), 
as an additional resource you can consult official [Apple documentation](https://developer.apple.com/library/ios/documentation/Swift/Conceptual/BuildingCocoaApps/InteractingWithObjective-CAPIs.html) on the matter.

### Carthage

*New since v0.4.0*
Starting version 0.4.0 Particle iOS device setup library is available through [Carthage](https://github.com/Carthage/Carthage). Carthage is intended to be the simplest way to add frameworks to your Cocoa application.
You must have Carthage installed, if you don't then be sure to [install Carthage](https://github.com/Carthage/Carthage#installing-carthage) before you start.
Then to build the Particle iOS device setup library, simply create a `Cartfile` on your project root folder (that's important), containing the following line:

```
github "spark/spark-setup-ios" ~> 0.6.0
```

and then run the following command:
`carthage update --platform iOS --use-submodules --no-use-binaries`.

*you can also re-use/copy the `bin/setup` shell script in your project, find it [here](https://github.com/spark/spark-setup-ios/blob/master/bin/setup)*

A new folder will be created in your project root folder - when Carthage checkout and builds are done, navigate to the `./Carthage/Build/iOS` folder and drag all the created `.framework`s files into your project in XCode. 
Go to your XCode target settings->General->Embedded binaries and press `+` and add all the `.framework` files there too - make sure the `ParticleDeviceSetupLibrary.framework`, `ParticleSDK.framework` and the `AFNetworking.framework` are listed there.
Build your project - you now have the Particle SDK embedded in your project.
Use `#import <ParticleDeviceSetupLibrary/ParticleDeviceSetupLibrary.h>` in Obj-C files or `import ParticleDeviceSetupLibrary` for Swift files to gain access to `SparkSetupMainController` (see usage example).

No need for any special process or operation integrating the Device Setup Library with Swift-based or Swift-dependant projects. This is the recommended way if you have a mixed set of dependencies.


## Communication

- If you **need help**, use [Our community website](http://community.particle.io)
- If you **found a bug**, _and can provide steps to reliably reproduce it_, open an issue.
- If you **have a feature request**, open an issue.
- If you **want to contribute**, submit a pull request.


## Maintainers

- [Ido Kleinman](https://www.github.com/idokleinman)

## License

Particle Device Setup library is available under the Apache license 2.0. See the LICENSE file for more info.
