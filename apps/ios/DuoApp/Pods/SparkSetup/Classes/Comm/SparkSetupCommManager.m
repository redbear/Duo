//
//  SparkSetupManager.m
//  spark-setup-ios
//
//  Created by Ido Kleinman on 11/20/14.
//  Copyright (c) 2014-2015 Particle. All rights reserved.
//  This class implements the Particle Soft-AP protocol specified in
//  https://github.com/spark/photon-wiced/blob/master/soft-ap.md
//

#import "SparkSetupCommManager.h"
#import "SparkSetupConnection.h"
#import <SystemConfiguration/CaptiveNetwork.h>
#import "SparkSetupSecurityManager.h"
#import <NetworkExtension/NetworkExtension.h>
//#import "FastSocket.h"

// new iOS 9 requirements:
#import "Reachability.h"
@import UIKit;


#define ENCRYPT_PWD     1

typedef NS_ENUM(NSInteger, SparkSetupCommandType) {
    SparkSetupCommandTypeNone=0,
    SparkSetupCommandTypeVersion=1,
    SparkSetupCommandTypeDeviceID=2,
    SparkSetupCommandTypeScanAP=3,
    SparkSetupCommandTypeConfigureAP=4,
    SparkSetupCommandTypeConnectAP=5,
    SparkSetupCommandTypePublicKey,
    SparkSetupCommandTypeSet,
};


NSString *const kSparkSetupConnectionEndpointAddress = @"192.168.0.1";
NSString *const kSparkSetupConnectionEndpointPortString = @"5609";
int const kSparkSetupConnectionEndpointAddressHex = 0xC0A80001;
int const kSparkSetupConnectionEndpointPort = 5609;


@interface SparkSetupCommManager() <SparkSetupConnectionDelegate>

@property (nonatomic, strong) SparkSetupConnection *connection;
@property (atomic) SparkSetupCommandType commandType; // last command type
@property (copy)void (^commandCompletionBlock)(id, NSError *); // completion block for last sent command
//@property (copy)void (^commandDeviceIDCompletionBlock)(id, BOOL, NSError *); // completion block for commandID command

@property (copy)void (^commandSendBlock)(void); // code block for sending the command to socket
@property (nonatomic, strong) NSTimer *sendCommandTimeoutTimer;
@property (nonatomic, strong) NSString *networkNamePrefix;
@end


@implementation SparkSetupCommManager


//-(instancetype)initWithConnection:(SparkSetupConnection *)connection
-(instancetype)init
{
    self = [super init];
    if (self)
    {
        self.commandType = SparkSetupCommandTypeNone;
        self.commandCompletionBlock = nil;
        self.commandSendBlock = nil;
        //        self.ready = NO;
//        NSLog(@"SparkSetupCommManager %@ instanciated!",self);
        
        return self;
        
    }
    
    return nil;
}


-(instancetype)initWithNetworkPrefix:(NSString *)networkPrefix
{
    SparkSetupCommManager *manager = [self init];
    if (manager)
    {
        manager.networkNamePrefix = networkPrefix;
        return manager;
    }
    else
        return nil;
}

#pragma mark Spark photon device wifi connection detection methods

+(BOOL)checkSparkDeviceWifiConnection:(NSString *)networkPrefix
{
    // starting iOS 9: just try to open socket to photon - networkPrefix is ignored
    /*
    if (SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"9.0"))
    {
        static BOOL bOpeningSocket = NO;
        
        if (bOpeningSocket)
            return NO;
        
        
        bOpeningSocket = YES;
        FastSocket *socket = [[FastSocket alloc] initWithHost:kSparkSetupConnectionEndpointAddress andPort:kSparkSetupConnectionEndpointPortString];
        
        if ([socket connect])
        {
            [socket close];
            bOpeningSocket = NO;
            return YES;
        }
        else
        {
            bOpeningSocket = NO;
            return NO;
        }
    }
    else*/
//    {
    
        // for iOS 8:
        NSArray *ifs = (__bridge_transfer NSArray *)CNCopySupportedInterfaces();
        //    NSLog(@"Supported interfaces: %@", ifs);
        NSDictionary *info;
        for (NSString *ifnam in ifs) {
            info = (__bridge_transfer NSDictionary *)CNCopyCurrentNetworkInfo((__bridge CFStringRef)ifnam);
            //        NSLog(@"%@ => %@", ifnam, info);
            if (info && [info count]) { break; }
        }
        
        NSString *SSID = info[@"SSID"];
        //    NSLog(@"currently connected SSID: %@",SSID);
        //    if ([SSID hasPrefix:[SparkSetupCustomization sharedInstance].networkNamePrefix])
        if ([SSID hasPrefix:networkPrefix])
        {
            return YES;
            // TODO: add notification or delegate method
            // TODO: add reachability change detection
            
        }
//    }
    
    return NO;
    
}

#pragma mark SparkSetupConnection delegate methods

-(void)SparkSetupConnection:(SparkSetupConnection *)connection didReceiveData:(NSString *)data
{
    if (connection == self.connection)
    {
        NSNumber *responseCode;
        NSError *e = nil;
        NSDictionary *response = [NSJSONSerialization JSONObjectWithData:[data dataUsingEncoding:NSUTF8StringEncoding] options:0 error:&e];
        if ((!e) && (self.commandCompletionBlock))
        {
            switch (self.commandType) {
                case SparkSetupCommandTypeVersion:
                    self.commandCompletionBlock(response[@"v"],nil); // the version string
                    //                    self.commandType = SparkSetupCommandTypeNone;
                    break;
                    
                case SparkSetupCommandTypeDeviceID:
                    if (self.commandCompletionBlock) // special completion
                    self.commandCompletionBlock(response, nil); // the device ID string + claimed flag dictionary
                    //                    self.commandType = SparkSetupCommandTypeNone;
                    break;
                    
                case SparkSetupCommandTypeScanAP:
                    self.commandCompletionBlock(response[@"scans"],nil); // the scan response array
                    //                    self.commandType = SparkSetupCommandTypeNone;
                    break;
                    
                    
                case SparkSetupCommandTypeConfigureAP:
                case SparkSetupCommandTypeConnectAP:
                case SparkSetupCommandTypeSet:
                    self.commandCompletionBlock(response[@"r"],nil); // the response code number
                    //                    self.commandType = SparkSetupCommandTypeNone;
                    break;
                    
                case SparkSetupCommandTypePublicKey:
                    // handle key storage
//                    NSLog(@"SparkSetupCommandTypePublicKey response is:\n%@",response);
                    
                    responseCode = (NSNumber *)response[@"r"];
                    if (responseCode.intValue != 0)
                    {
                        self.commandCompletionBlock(nil,[NSError errorWithDomain:@"SparkSetupCommManagerError" code:2006 userInfo:@{NSLocalizedDescriptionKey:@"Could not retrieve public key from device"}]);
                    }
                    else
                    {
                        // decode HEX encoded key to NSData
                        NSString *pubKeyHexCoded = (NSString *)response[@"b"];
//                        NSLog(@"Encoded key is %@", pubKeyHexCoded);
                        
                        NSData *pubKey = [SparkSetupSecurityManager decodeDataFromHexString:pubKeyHexCoded];
//                        NSLog(@"Decoded key is %@", [pubKey description]);
                        
                        if ([SparkSetupSecurityManager setPublicKey:pubKey])
                        {
//                            NSLog(@"Public key stored in keychain successfully");
                            self.commandCompletionBlock(response[@"r"],nil);
                        }
                        else
                        {
                            self.commandCompletionBlock(nil,[NSError errorWithDomain:@"SparkSetupSecurityManager" code:2007 userInfo:@{NSLocalizedDescriptionKey:@"Could not store public key in device keychain"}]);
                        }

                    }
                default: // something else happened
                    //                    self.commandType = SparkSetupCommandTypeNone;
                    break;
            }
            
        }
    }
    
}





-(void)SparkSetupConnection:(SparkSetupConnection *)connection didUpdateState:(SparkSetupConnectionState)state error:(NSError *)error
{
    if (error)
    {
        [self.sendCommandTimeoutTimer invalidate];
        if (self.commandCompletionBlock)
            self.commandCompletionBlock(nil, [NSError errorWithDomain:@"SparkSetupCommManagerError" code:2002 userInfo:@{NSLocalizedDescriptionKey:error.localizedDescription}]);
//        self.commandCompletionBlock = nil;
        return;
    }
    
    switch (state) {
        case SparkSetupConnectionStateClosed:
//            NSLog(@"Connection to spark device closed");
            [self.sendCommandTimeoutTimer invalidate];
            break;
            
        case SparkSetupConnectionOpenTimeout:
//            NSLog(@"Opening connection to spark device timed out");
            [self.sendCommandTimeoutTimer invalidate];
            if (self.commandCompletionBlock)
            {
                self.commandCompletionBlock(nil, [NSError errorWithDomain:@"SparkSetupCommManagerError" code:2002 userInfo:@{NSLocalizedDescriptionKey:@"Opening connection to spark device timed out"}]);
                self.commandCompletionBlock = nil;
            }
            break;
            
        case SparkSetupConnectionStateOpened:
//            NSLog(@"Connection to spark device opened");
            if (self.commandSendBlock)
            {
                self.sendCommandTimeoutTimer = [NSTimer scheduledTimerWithTimeInterval:3.0f target:self selector:@selector(sendCommandTimeoutHandler:) userInfo:nil repeats:NO];
                self.commandSendBlock();
//                NSLog(@"Command %ld sent to spark device",(long)self.commandType);
            }
            break;
        case SparkSetupConnectionStateError:
        case SparkSetupConnectionStateUnknown:
            self.commandType = SparkSetupCommandTypeNone;
            [self.sendCommandTimeoutTimer invalidate];
//            NSLog(@"Connection to spark device failed");
            if (self.commandCompletionBlock)
            {
                self.commandCompletionBlock(nil, [NSError errorWithDomain:@"SparkSetupCommManagerError" code:2002 userInfo:@{NSLocalizedDescriptionKey:@"Connection to spark device failed"}]);
                self.commandCompletionBlock = nil;
            }
            break;
            
        default:
            break;
    }
}

/*
 -(void)writeCommandTimeoutHandler:(id)sender
 {
 self.commandType = SparkSetupCommandTypeNone;
 //    self.connection = nil;
 
 if (self.commandCompletionBlock)
 self.commandCompletionBlock(nil,[NSError errorWithDomain:@"SparkSetupCommManagerError" code:2002 userInfo:@{NSLocalizedDescriptionKey:@"Timeout occured while writing data to socket connection"}]);
 
 //    self.commandCompletionBlock = nil;
 }
 */



-(void)sendCommandTimeoutHandler:(id)sender
{
    
    [self.sendCommandTimeoutTimer invalidate];
    //    self.commandType = SparkSetupCommandTypeNone;
    
    if (self.commandCompletionBlock)
        self.commandCompletionBlock(nil,[NSError errorWithDomain:@"SparkSetupCommManagerError" code:2004 userInfo:@{NSLocalizedDescriptionKey:@"Timeout occured while waiting for response from socket"}]);
    
    self.commandCompletionBlock = nil;
}

#pragma mark TCP Socket photon soft AP protocol implementation


-(void)openConnection // and then send command (+ timeout)
{
    // TODO: add command queue
    self.connection = [[SparkSetupConnection alloc] initWithIPAddress:kSparkSetupConnectionEndpointAddress port:kSparkSetupConnectionEndpointPort];
    self.connection.delegate = self;
}


-(BOOL)canSendCommandCallCompletionForError:(void(^)(id obj, NSError *error))completion
{
    if (self.networkNamePrefix)
    {
        if (![SparkSetupCommManager checkSparkDeviceWifiConnection:self.networkNamePrefix])
        {
            completion(nil, [NSError errorWithDomain:@"SparkSetupCommManangerError" code:2003 userInfo:@{NSLocalizedDescriptionKey:@"Not connected to Spark device"}]);
            return NO;
        }
    }
    
    if (self.commandType != SparkSetupCommandTypeNone)
    {
        completion(nil, [NSError errorWithDomain:@"SparkSetupCommManangerError" code:2005 userInfo:@{NSLocalizedDescriptionKey:@"Use a new instance of SparkSetupCommManager per command"}]);
        return NO;
    }
    
    return YES;
}

-(void)version:(void(^)(id version, NSError *error))completion
{
    // TODO: new prototype:
    // open connection --> add semaphore to delegate
    // wait on semaphore with timeout (open socket timeout call completion)
    // do write command (+ handle completion)
    // add semaphore to receive data with timeout
    // if fails - receive data timeout
    // else calls completion with data
    // no need for NSTimers
    
    if ([self canSendCommandCallCompletionForError:completion])
    {
        __weak SparkSetupCommManager *weakSelf = self;
        self.commandCompletionBlock = completion;
        
        self.commandSendBlock = ^{
            
            NSString *commandStr = @"version\n0\n\n";
            weakSelf.commandType = SparkSetupCommandTypeVersion;
            [weakSelf.connection writeString:commandStr completion:^(NSError *error) {
                if ((error) && (completion))
                {
                    completion(nil, error);
                    weakSelf.commandCompletionBlock = nil;
                    //                weakSelf.commandType = SparkSetupCommandTypeNone;
                }
            }];
        };
        // start process
        [self openConnection];
    }
    
    
}



-(void)deviceID:(void (^)(id, NSError *))completion
{
    if ([self canSendCommandCallCompletionForError:completion])
    {
        __weak SparkSetupCommManager *weakSelf = self;
        self.commandCompletionBlock = completion;
        
        self.commandSendBlock = ^{
            
            if (weakSelf.connection.state == SparkSetupConnectionStateOpened)
            {
                weakSelf.commandType = SparkSetupCommandTypeDeviceID;
                NSString *commandStr = @"device-id\n0\n\n";
                
                [weakSelf.connection writeString:commandStr completion:^(NSError *error) {
                    if ((error) && (completion))
                    {
                        completion(nil, error);
                        weakSelf.commandCompletionBlock = nil;
                        //                    weakSelf.commandType = SparkSetupCommandTypeNone;
                        
                    }
                }];
            }
            
        };
        
        [self openConnection];
    }
}



-(void)scanAP:(void(^)(id scanResponse, NSError *error))completion //NSDictionary
{
    if ([self canSendCommandCallCompletionForError:completion])
    {
        __weak SparkSetupCommManager *weakSelf = self;
        self.commandCompletionBlock = completion;
        
        self.commandSendBlock = ^{
            
            weakSelf.commandType = SparkSetupCommandTypeScanAP;
            NSString *commandStr = @"scan-ap\n0\n\n";
            
            [weakSelf.connection writeString:commandStr completion:^(NSError *error) {
                if ((error) && (completion))
                {
                    completion(nil, error);
                    weakSelf.commandCompletionBlock = nil;
                    //                weakSelf.commandType = SparkSetupCommandTypeNone;
                }
            }];
            
        };
        
        [self openConnection];
        
    }
}




-(void)configureAP:(NSString *)ssid passcode:(NSString *)passcode security:(NSNumber *)securityType channel:(NSNumber *)channel completion:(void(^)(id responseCode, NSError *error))completion
{
    if ([self canSendCommandCallCompletionForError:completion])
    {
        __weak SparkSetupCommManager *weakSelf = self;
        self.commandCompletionBlock = completion;
        
        self.commandSendBlock = ^{

            NSDictionary* requestDataDict;

            // Truncate passcode to 64 chars maximum
            NSRange stringRange = {0, MIN(passcode.length, 64)};
            // adjust the range to include dependent chars
            stringRange = [passcode rangeOfComposedCharacterSequencesForRange:stringRange];
            // Now you can create the short string
            NSString *passcodeTruncated = [passcode substringWithRange:stringRange];
            NSString *hexEncodedEncryptedPasscodeStr;
            
            if (ENCRYPT_PWD)
            {
                SecKeyRef pubKey = [SparkSetupSecurityManager getPublicKey];
                if (pubKey != NULL)
                {
                    // encrypt it using the stored public key
                    NSData *plainTextData = [passcodeTruncated dataUsingEncoding:NSUTF8StringEncoding];
                    NSData *cipherTextData = [SparkSetupSecurityManager encryptWithPublicKey:pubKey plainText:plainTextData];
                    if (cipherTextData != nil)
                    {
                        // encode the encrypted data to a hex string
                        hexEncodedEncryptedPasscodeStr = [SparkSetupSecurityManager encodeDataToHexString:cipherTextData];
//                        NSLog(@"plaintext: %@\nCiphertext:\n%@",passcodeTruncated,hexEncodedEncryptedPasscodeStr);
                        requestDataDict = @{@"idx":@0, @"ssid":ssid, @"pwd":hexEncodedEncryptedPasscodeStr, @"sec":securityType, @"ch":channel};
                    }
                    else
                    {
                        completion(nil, [NSError errorWithDomain:@"SparkSetupSecurityManager" code:2007 userInfo:@{NSLocalizedDescriptionKey:@"Failed to encrypt passcode"}]);
                        return; //?
                    }
                }
                else
                {
                    completion(nil, [NSError errorWithDomain:@"SparkSetupSecurityManager" code:2008 userInfo:@{NSLocalizedDescriptionKey:@"Failed to retrieve device public key from keychain"}]);
                    return; //?
                }
            }
            else
            {
                // no passcode encryption // TODO: remove when encryption functional
                requestDataDict = @{@"idx":@0, @"ssid":ssid, @"pwd":passcodeTruncated, @"sec":securityType, @"ch":channel};
            }
            
            NSError *error;
            NSString *jsonString;
            NSData *jsonData = [NSJSONSerialization dataWithJSONObject:requestDataDict
                                                               options:0
                                                                 error:&error];
            
            if (jsonData)
                jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
            else
                completion(nil, [NSError errorWithDomain:@"SparkSetupCommManangerError" code:2002 userInfo:@{NSLocalizedDescriptionKey:@"Cannot process configureAP command data to JSON"}]);
            
            NSString *commandStr = [NSString stringWithFormat:@"configure-ap\n%ld\n\n%@",(unsigned long)jsonString.length, jsonString];
            weakSelf.commandType = SparkSetupCommandTypeConfigureAP;
            [weakSelf.connection writeString:commandStr completion:^(NSError *error) {
                if ((error) && (completion))
                {
                    completion(nil, error);
                    weakSelf.commandCompletionBlock = nil;
                    //                weakSelf.commandType = SparkSetupCommandTypeNone;
                }
            }];
            
        };
        
        [self openConnection];
    }
    
}




-(void)setClaimCode:(NSString *)claimCode completion:(void (^)(id, NSError *))completion
{
    if ([self canSendCommandCallCompletionForError:completion])
    {
        __weak SparkSetupCommManager *weakSelf = self;
        self.commandCompletionBlock = completion;
        
        self.commandSendBlock = ^{
            
            NSDictionary* requestDataDict;
            requestDataDict = @{@"k":@"cc",
                                @"v": claimCode};
            
            NSError *error;
            NSString *jsonString;
            NSData *jsonData = [NSJSONSerialization dataWithJSONObject:requestDataDict
                                                               options:0
                                                                 error:&error];
            
            if (jsonData)
                jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
            else
                completion(nil, [NSError errorWithDomain:@"SparkSetupCommManangerError" code:2002 userInfo:@{NSLocalizedDescriptionKey:@"Cannot process setClaimCode command data to JSON"}]);
            
            // remove backslahes that might occur from '/' in
            jsonString = [jsonString stringByReplacingOccurrencesOfString:@"\\" withString:@""];
                          
            NSString *commandStr = [NSString stringWithFormat:@"set\n%ld\n\n%@",(unsigned long)jsonString.length, jsonString];
            weakSelf.commandType = SparkSetupCommandTypeSet;
            [weakSelf.connection writeString:commandStr completion:^(NSError *error) {
                if ((error) && (completion))
                {
                    completion(nil, error);
                    weakSelf.commandCompletionBlock = nil;
                }
            }];
            
        };
        
        [self openConnection];
    }
}

-(void)connectAP:(void(^)(id responseCode, NSError *error))completion
{
    if ([self canSendCommandCallCompletionForError:completion])
    {
        __weak SparkSetupCommManager *weakSelf = self;
        self.commandCompletionBlock = completion;
        
        self.commandSendBlock = ^{
            
            NSDictionary* requestDataDict = @{@"idx":@0};
            NSError *error;
            NSString *jsonString;
            NSData *jsonData = [NSJSONSerialization dataWithJSONObject:requestDataDict
                                                               options:0
                                                                 error:&error];
            
            if (jsonData)
            {
                jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
                
                NSString *commandStr = [NSString stringWithFormat:@"connect-ap\n%ld\n\n%@",(unsigned long)jsonString.length, jsonString];
                weakSelf.commandType = SparkSetupCommandTypeConnectAP;
                [weakSelf.connection writeString:commandStr completion:^(NSError *error) {
                    if ((error) && (completion))
                    {
                        completion(nil, error);
                        weakSelf.commandCompletionBlock = nil;
                        //                weakSelf.commandType = SparkSetupCommandTypeNone;
                    }
                }];
            }
            else
            {
                completion(nil, [NSError errorWithDomain:@"SparkSetupCommManangerError" code:2002 userInfo:@{NSLocalizedDescriptionKey:@"Cannot process connectAP command data to JSON"}]);
            }
            
        };
        
        [self openConnection];
    }
    
}


-(void)publicKey:(void (^)(id, NSError *))completion
{
    if ([self canSendCommandCallCompletionForError:completion])
    {
        __weak SparkSetupCommManager *weakSelf = self;
        self.commandCompletionBlock = completion;
        
        self.commandSendBlock = ^{
            
            weakSelf.commandType = SparkSetupCommandTypePublicKey;
            NSString *commandStr = @"public-key\n0\n\n";
            
            [weakSelf.connection writeString:commandStr completion:^(NSError *error) {
                if ((error) && (completion))
                {
                    completion(nil, error);
                    weakSelf.commandCompletionBlock = nil;

                }
            }];
            
        };
        
        [self openConnection];
        
    }

}

-(void)dealloc
{
//    NSLog(@"SparkSetupCommManager %@ dealloced!",self);
    
    self.commandSendBlock = nil;
    self.commandCompletionBlock = nil;
    self.connection = nil;
    
}



@end
