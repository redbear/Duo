//
//  SparkDevice.h
//  Particle iOS Cloud SDK
//
//  Created by Ido Kleinman
//  Copyright 2015 Particle
//
//  Licensed under the Apache License, Version 2.0 (the "License");
//  you may not use this file except in compliance with the License.
//  You may obtain a copy of the License at
//
//  http://www.apache.org/licenses/LICENSE-2.0
//
//  Unless required by applicable law or agreed to in writing, software
//  distributed under the License is distributed on an "AS IS" BASIS,
//  WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
//  See the License for the specific language governing permissions and
//  limitations under the License.

#import <Foundation/Foundation.h>
#import "SparkEvent.h"

NS_ASSUME_NONNULL_BEGIN

/**
 * Standard completion block for API calls, will be called when the task is completed
 * with a nullable error object that will be nil if the task was successful.
 */
typedef void (^SparkCompletionBlock)(NSError * _Nullable error);

typedef NS_ENUM(NSInteger, SparkDeviceType) {
    SparkDeviceTypeUnknown=-1,
    SparkDeviceTypeCore=0,
    SparkDeviceTypePhoton=6, // or P0
    SparkDeviceTypeP1=8,
    SparkDeviceTypeElectron=10,
    SparkDeviceTypeRedBearDuo=88,
    SparkDeviceTypeBluz=103,
    SparkDeviceTypeDigistumpOak=82,
};

typedef NS_ENUM(NSInteger, SparkDeviceSystemEvent) {
    SparkDeviceSystemEventCameOnline,
    SparkDeviceSystemEventWentOffline,
    SparkDeviceSystemEventFlashStarted,
    SparkDeviceSystemEventFlashSucceeded,
    SparkDeviceSystemEventFlashFailed,
    SparkDeviceSystemEventAppHashUpdated,
    SparkDeviceSystemEventEnteredSafeMode,
    SparkDeviceSystemEventSafeModeUpdater
};

@class SparkDevice;

@protocol SparkDeviceDelegate <NSObject>

@optional
-(void)sparkDevice:(SparkDevice *)device didReceiveSystemEvent:(SparkDeviceSystemEvent)event;

@end

@interface SparkDevice : NSObject

/**
 *  DeviceID string
 */
@property (strong, nonatomic, readonly) NSString* id;
/**
 *  Device name. Device can be renamed in the cloud by setting this property. If renaming fails name will stay the same.
 */
@property (strong, nullable, nonatomic) NSString* name;
/**
 *  Is device connected to the cloud? Best effort - May not accurate reflect true state.
 */
@property (nonatomic, readonly) BOOL connected;
/**
 *  List of function names exposed by device
 */
@property (strong, nonatomic, nonnull, readonly) NSArray<NSString *> *functions;
/**
 *  Dictionary of exposed variables on device with their respective types.
 */
@property (strong, nonatomic, nonnull, readonly) NSDictionary<NSString *, NSString *> *variables; // @{varName : varType, ...}

@property (strong, nonatomic, nullable, readonly) NSString *lastApp;

@property (strong, nonatomic, nullable, readonly) NSDate *lastHeard;

@property (strong, nonatomic, nullable, readonly) NSString *appHash; // app hash received from system event after flashing a new different user app

@property (nonatomic, readonly) BOOL isFlashing;

// new properties starting SDK v0.5
@property (strong, nonatomic, nullable, readonly) NSString *lastIPAdress;
@property (strong, nonatomic, nullable, readonly) NSString *lastIccid; // Electron only
@property (strong, nonatomic, nullable, readonly) NSString *imei;
@property (nonatomic, readonly) NSUInteger platformId;
@property (nonatomic, readonly) NSUInteger productId;
@property (strong, nonatomic, nullable, readonly) NSString *status;

/**
 *  Device firmware version string
 */
@property (strong, nonatomic, readonly) NSString *version; // inactive
@property (nonatomic, readonly) BOOL requiresUpdate;
@property (nonatomic, readonly) SparkDeviceType type;

-(nullable instancetype)initWithParams:(NSDictionary *)params NS_DESIGNATED_INITIALIZER;
-(instancetype)init __attribute__((unavailable("Must use initWithParams:")));

@property (nonatomic, strong) id <SparkDeviceDelegate> delegate;

/**
 *  Retrieve a variable value from the device
 *
 *  @param variableName Variable name
 *  @param completion   Completion block to be called when function completes with the variable value retrieved (as id/AnyObject) or NSError object in case on an error
 */
-(NSURLSessionDataTask *)getVariable:(NSString *)variableName completion:(nullable void(^)(id _Nullable result, NSError* _Nullable error))completion;

/**
 *  Call a function on the device
 *
 *  @param functionName Function name
 *  @param args         Array of arguments to pass to the function on the device. Arguments will be converted to string maximum length 63 chars.
 *  @param completion   Completion block will be called when function was invoked on device. First argument of block is the integer return value of the function, second is NSError object in case of an error invoking the function
 */
-(NSURLSessionDataTask *)callFunction:(NSString *)functionName
                        withArguments:(nullable NSArray *)args
                           completion:(nullable void (^)(NSNumber * _Nullable result, NSError * _Nullable error))completion;

/**
 *  Signal device
 *  Will make the onboard LED "shout rainbows" for easy physical identification of a device
 *
 *  @param enale - YES to start or NO to stop LED signal.
 *
 */
-(NSURLSessionDataTask *)signal:(BOOL)enable completion:(nullable SparkCompletionBlock)completion;


/**
 *  Request device refresh from cloud
 *  update online status/functions/variables/device name, etc
 *
 *  @param completion Completion block called when function completes with NSError object in case of an error or nil if success.
 *
 */
-(NSURLSessionDataTask *)refresh:(nullable SparkCompletionBlock)completion;

/**
 *  Remove device from current logged in user account
 *
 *  @param completion Completion block called when function completes with NSError object in case of an error or nil if success.
 */
-(NSURLSessionDataTask *)unclaim:(nullable SparkCompletionBlock)completion;

/*
-(void)compileAndFlash:(NSString *)sourceCode completion:(void(^)(NSError* error))completion;
-(void)flash:(NSData *)binary completion:(void(^)(NSError* error))completion;
*/

/**
 *  Rename device
 *
 *  @param newName      New device name
 *  @param completion   Completion block called when function completes with NSError object in case of an error or nil if success.
 */
-(NSURLSessionDataTask *)rename:(NSString *)newName completion:(nullable SparkCompletionBlock)completion;

/**
 *  Retrieve current data usage report (For Electron only)
 *
 *  @param completion   Completion block to be called when function completes with the data used in current payment period in (float)MBs. All devices other than Electron will return an error with -1 value
 */
-(NSURLSessionDataTask *)getCurrentDataUsage:(nullable void(^)(float dataUsed, NSError* _Nullable error))completion;


/**
 *  Flash files to device
 *
 *  @param filesDict    files dictionary in the following format: @{@"filename.bin" : <NSData>, ...} - that is a NSString filename as key and NSData blob as value. More than one file can be flashed. Data is alway binary.
 *  @param completion   Completion block called when function completes with NSError object in case of an error or nil if success. NSError.localized descripion will contain a detailed error report in case of a
 */
-(nullable NSURLSessionDataTask *)flashFiles:(NSDictionary *)filesDict completion:(nullable SparkCompletionBlock)completion; //@{@"<filename>" : NSData, ...}

/**
 *  Flash known firmware images to device
 *
 *  @param knownAppName    NSString of known app name. Currently @"tinker" is supported. 
 *  @param completion      Completion block called when function completes with NSError object in case of an error or nil if success. NSError.localized descripion will contain a detailed error report in case of a
 */
-(NSURLSessionDataTask *)flashKnownApp:(NSString *)knownAppName completion:(nullable SparkCompletionBlock)completion; // knownAppName = @"tinker", @"blinky", ... see http://docs.

//-(void)compileAndFlashFiles:(NSDictionary *)filesDict completion:(void(^)(NSError* error))completion; //@{@"<filename>" : @"<file contents>"}
//-(void)complileFiles:(NSDictionary *)filesDict completion:(void(^)(NSData *resultBinary, NSError* error))completion; //@{@"<filename>" : @"<file contents>"}

// --------------------------------------------------------------------------------------------------------------------------------------------------------
// Events subsystem:
// --------------------------------------------------------------------------------------------------------------------------------------------------------

/**
 *  Subscribe to events from this specific (claimed) device - both public and private.
 *
 *  @param eventNamePrefix  Filter only events that match name eventNamePrefix, for exact match pass whole string, if nil/empty string is passed any event will trigger eventHandler
 *  @param eventHandler     Event handler function that accepts the event payload dictionary and an NSError object in case of an error
 */
-(nullable id)subscribeToEventsWithPrefix:(nullable NSString *)eventNamePrefix handler:(nullable SparkEventHandler)eventHandler;

/**
 *  Unsubscribe from event/events.
 *
 *  @param eventListenerID The eventListener registration unique ID returned by the subscribe method which you want to cancel
 */
-(void)unsubscribeFromEventWithID:(id)eventListenerID;

// Internal use
-(void)__receivedSystemEvent:(SparkEvent *)event;

@end

NS_ASSUME_NONNULL_END
