//
//  SparkSetupConnection.h
//  mobile-sdk-ios
//
//  Created by Ido Kleinman on 11/20/14.
//  Copyright (c) 2014-2015 Spark. All rights reserved.
//

#import <Foundation/Foundation.h>

@class SparkSetupConnection;

typedef NS_ENUM(NSInteger, SparkSetupConnectionState) {
    SparkSetupConnectionStateOpened,
//    SparkSetupConnectionStateSentCommand,
//    SparkSetupConnectionStateReceivedResponse,
    SparkSetupConnectionStateClosed,
    SparkSetupConnectionOpenTimeout,
    SparkSetupConnectionStateError,
    SparkSetupConnectionStateUnknown
};


@protocol SparkSetupConnectionDelegate <NSObject>

@required
-(void)SparkSetupConnection:(SparkSetupConnection *)connection didReceiveData:(NSString *)data;

@optional
-(void)SparkSetupConnection:(SparkSetupConnection *)connection didUpdateState:(SparkSetupConnectionState)state error:(NSError *)error;

@end

@interface SparkSetupConnection : NSObject
-(instancetype)initWithIPAddress:(NSString *)IPAddr port:(int)port NS_DESIGNATED_INITIALIZER;
-(id)init __attribute__((unavailable("Must use -initWithIPAddress:port:")));
-(void)close;

@property (nonatomic, strong) id<SparkSetupConnectionDelegate>delegate;
@property (nonatomic, readonly) SparkSetupConnectionState state;

-(void)writeString:(NSString *)string completion:(void(^)(NSError *error))completion;

@end
