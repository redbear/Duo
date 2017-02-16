//
//  SparkDevice.m
//  mobile-sdk-ios
//
//  Created by Ido Kleinman on 11/7/14.
//  Copyright (c) 2014-2015 Spark. All rights reserved.
//

#import "SparkDevice.h"
#import "SparkCloud.h"
#import "SparkEvent.h"
#import <AFNetworking/AFNetworking.h>
#import <objc/runtime.h>

#define MAX_SPARK_FUNCTION_ARG_LENGTH 63

NS_ASSUME_NONNULL_BEGIN

@interface SparkDevice()

@property (strong, nonatomic, nonnull) NSString* id;
@property (nonatomic) BOOL connected; // might be impossible
@property (strong, nonatomic, nonnull) NSArray *functions;
@property (strong, nonatomic, nonnull) NSDictionary *variables;
@property (strong, nonatomic, nullable) NSString *version;
//@property (nonatomic) SparkDeviceType type;
@property (nonatomic) BOOL requiresUpdate;
@property (nonatomic, strong) AFHTTPSessionManager *manager;
@property (nonatomic) BOOL isFlashing;
@property (nonatomic, strong) NSURL *baseURL;

@property (strong, nonatomic, nullable) NSString *lastIPAdress;
@property (strong, nonatomic, nullable) NSString *lastIccid; // Electron only
@property (strong, nonatomic, nullable) NSString *imei; // Electron only
@property (nonatomic) NSUInteger platformId;
@property (nonatomic) NSUInteger productId;
@property (strong, nonatomic, nullable) NSString *status;
@property (strong, nonatomic, nullable) NSString *appHash;
@end

@implementation SparkDevice

-(nullable instancetype)initWithParams:(NSDictionary *)params
{
    if (self = [super init])
    {
        _baseURL = [NSURL URLWithString:kSparkAPIBaseURL];
        if (!_baseURL) {
            return nil;
        }
     
        _requiresUpdate = NO;
        
        _name = nil;
        if ([params[@"name"] isKindOfClass:[NSString class]])
        {
            _name = params[@"name"];
        }
        
        _connected = [params[@"connected"] boolValue] == YES;
        
        _functions = params[@"functions"] ?: @[];
        _variables = params[@"variables"] ?: @{};
        
        if (![_functions isKindOfClass:[NSArray class]]) {
            self.functions = @[];
        }

        if (![_variables isKindOfClass:[NSDictionary class]]) {
            _variables = @{};
        }

        _id = params[@"id"];

        _type = SparkDeviceTypeUnknown;
        if ([params[@"platform_id"] isKindOfClass:[NSNumber class]])
        {
            self.platformId = [params[@"platform_id"] intValue];
            
            if ([params[@"platform_id"] intValue] == SparkDeviceTypeCore)
                _type = SparkDeviceTypeCore;

            if ([params[@"platform_id"] intValue] == SparkDeviceTypeElectron)
                _type = SparkDeviceTypeElectron;

            if ([params[@"platform_id"] intValue] == SparkDeviceTypePhoton) // or P0 - same id
                _type = SparkDeviceTypePhoton;
            
            if ([params[@"platform_id"] intValue] == SparkDeviceTypeP1)
                _type = SparkDeviceTypeP1;

            if ([params[@"platform_id"] intValue] == SparkDeviceTypeRedBearDuo)
                _type = SparkDeviceTypeRedBearDuo;

            if ([params[@"platform_id"] intValue] == SparkDeviceTypeBluz)
                _type = SparkDeviceTypeBluz;

            if ([params[@"platform_id"] intValue] == SparkDeviceTypeDigistumpOak)
                _type = SparkDeviceTypeDigistumpOak;
        }

        
        if ([params[@"product_id"] isKindOfClass:[NSNumber class]])
        {
            _productId = [params[@"product_id"] intValue];
        }
        
        if ((params[@"last_iccid"]) && ([params[@"last_iccid"] isKindOfClass:[NSString class]]))
        {
            _lastIccid = params[@"last_iccid"];
        }

        if ((params[@"imei"]) && ([params[@"imei"] isKindOfClass:[NSString class]]))
        {
            _imei = params[@"imei"];
        }

        if ((params[@"status"]) && ([params[@"status"] isKindOfClass:[NSString class]]))
        {
            _status = params[@"status"];
        }

        
        if ([params[@"last_ip_address"] isKindOfClass:[NSString class]])
        {
            _lastIPAdress = params[@"last_ip_address"];
        }
        
        if ([params[@"last_app"] isKindOfClass:[NSString class]])
        {
            _lastApp = params[@"last_app"];
        }

        if ([params[@"last_heard"] isKindOfClass:[NSString class]])
        {
            // TODO: add to utils class as POSIX time to NSDate
            NSString *dateString = params[@"last_heard"];// "2015-04-18T08:42:22.127Z"
            NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
            [formatter setDateFormat:@"yyyy-MM-dd'T'HH:mm:ss.SSSZ"];
            NSLocale *posix = [[NSLocale alloc] initWithLocaleIdentifier:@"en_US_POSIX"];
            [formatter setLocale:posix];
            _lastHeard = [formatter dateFromString:dateString];
        }

        /// WIP
        /*
        if (params[@"cc3000_patch_version"]) { // Core only
            self.systemFirmwareVersion = (params[@"cc3000_patch_version"]);
        } else if (params[@"current_build_target"]) { // Electron only
            self.systemFirmwareVersion = params[@"current_build_target"];
        }
         */
        
            
        if (params[@"device_needs_update"])
        {
            _requiresUpdate = YES;
        }
        
        self.manager = [[AFHTTPSessionManager alloc] initWithBaseURL:self.baseURL];
        self.manager.responseSerializer = [AFJSONResponseSerializer serializer];

        if (!self.manager) return nil;
        
         
        return self;
    }
    
    return nil;
}



-(NSURLSessionDataTask *)refresh:(nullable SparkCompletionBlock)completion;
{
    return [[SparkCloud sharedInstance] getDevice:self.id completion:^(SparkDevice * _Nullable updatedDevice, NSError * _Nullable error) {
        if (!error)
        {
            if (updatedDevice)
            {
                // if we got an updated device from the cloud - overwrite ALL self's properies with the new device properties
                NSMutableSet *propNames = [NSMutableSet set];
                unsigned int outCount, i;
                objc_property_t *properties = class_copyPropertyList([updatedDevice class], &outCount);
                for (i = 0; i < outCount; i++) {
                    objc_property_t property = properties[i];
                    NSString *propertyName = [[NSString alloc] initWithCString:property_getName(property) encoding:NSStringEncodingConversionAllowLossy];
                    [propNames addObject:propertyName];
                }
                free(properties);
                
                for (NSString *property in propNames)
                {
                    id value = [updatedDevice valueForKey:property];
                    [self setValue:value forKey:property];
                }
            }
            if (completion)
            {
                completion(nil);
            }
        }
        else
        {
            if (completion)
            {
                completion(error);
            }
        }
    }];
}

-(void)setName:(nullable NSString *)name
{
    if (name != nil) {
        [self rename:name completion:nil];
    }
}

-(NSURLSessionDataTask *)getVariable:(NSString *)variableName completion:(nullable void(^)(id _Nullable result, NSError* _Nullable error))completion
{
    // TODO: check variable name exists in list
    // TODO: check response of calling a non existant function
    
    NSURL *url = [self.baseURL URLByAppendingPathComponent:[NSString stringWithFormat:@"v1/devices/%@/%@", self.id, variableName]];
    
    [self setAuthHeaderWithAccessToken];
    
    NSURLSessionDataTask *task = [self.manager GET:[url description] parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject)
    {
        if (completion)
        {
            NSDictionary *responseDict = responseObject;
            if (![responseDict[@"coreInfo"][@"connected"] boolValue]) // check response
            {
                NSError *err = [self makeErrorWithDescription:@"Device is not connected" code:1001];
                completion(nil,err);
            }
            else
            {
                // check
                completion(responseDict[@"result"], nil);
            }
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error)
    {
        if (completion)
        {
            completion(nil, error);
        }
    }];
    
    return task;
}

-(NSURLSessionDataTask *)callFunction:(NSString *)functionName
                        withArguments:(nullable NSArray *)args
                           completion:(nullable void (^)(NSNumber * _Nullable result, NSError * _Nullable error))completion
{
    // TODO: check function name exists in list
    // TODO: check response of calling a non existant function
    NSURL *url = [self.baseURL URLByAppendingPathComponent:[NSString stringWithFormat:@"v1/devices/%@/%@", self.id, functionName]];
    NSMutableDictionary *params = [NSMutableDictionary new]; //[self defaultParams];

    if (args) {
        NSMutableArray *argsStr = [[NSMutableArray alloc] initWithCapacity:args.count];
        for (id arg in args)
        {
            [argsStr addObject:[arg description]];
        }
        NSString *argsValue = [argsStr componentsJoinedByString:@","];
        if (argsValue.length > MAX_SPARK_FUNCTION_ARG_LENGTH)
        {
            // TODO: arrange user error/codes in a list
            NSError *err = [self makeErrorWithDescription:[NSString stringWithFormat:@"Maximum argument length cannot exceed %d",MAX_SPARK_FUNCTION_ARG_LENGTH] code:1000];
            if (completion)
                completion(nil,err);
            return nil;
        }
            
        params[@"args"] = argsValue;
    }
    
    [self setAuthHeaderWithAccessToken];
    
    NSURLSessionDataTask *task = [self.manager POST:[url description] parameters:params progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject)
    {
        if (completion)
        {
            NSDictionary *responseDict = responseObject;
            if ([responseDict[@"connected"] boolValue]==NO)
            {
                NSError *err = [self makeErrorWithDescription:@"Device is not connected" code:1001];
                completion(nil,err);
            }
            else
            {
                // check
                NSNumber *result = responseDict[@"return_value"];
                completion(result,nil);
            }
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error)
    {
        if (completion)
        {
            completion(nil,error);
        }
    }];
    
    return task;
}


-(NSURLSessionDataTask *)signal:(BOOL)enable completion:(nullable SparkCompletionBlock)completion
{
    NSURL *url = [self.baseURL URLByAppendingPathComponent:[NSString stringWithFormat:@"v1/devices/%@", self.id]];
    
    NSMutableDictionary *params = [NSMutableDictionary new];
    params[@"signal"] = enable ? @"1" : @"0";
    
    [self setAuthHeaderWithAccessToken];
    
    NSURLSessionDataTask *task = [self.manager PUT:[url description] parameters:params success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if (completion)
        {
            completion(nil);
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        if (completion) // TODO: better erroring handling
        {
            completion(error);
        }
    }];
    
    return task;
}


-(NSURLSessionDataTask *)unclaim:(nullable SparkCompletionBlock)completion
{

    NSURL *url = [self.baseURL URLByAppendingPathComponent:[NSString stringWithFormat:@"v1/devices/%@", self.id]];

//    NSMutableDictionary *params = [self defaultParams];
//    params[@"id"] = self.id;
    [self setAuthHeaderWithAccessToken];

    NSURLSessionDataTask *task = [self.manager DELETE:[url description] parameters:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject)
    {
        if (completion)
        {
            NSDictionary *responseDict = responseObject;
            if ([responseDict[@"ok"] boolValue])
                completion(nil);
            else
                completion([self makeErrorWithDescription:@"Could not unclaim device" code:1003]);
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error)
    {
         if (completion)
         {
             completion(error);
         }
    }];
    
    return task;
}

-(NSURLSessionDataTask *)rename:(NSString *)newName completion:(nullable SparkCompletionBlock)completion
{
    NSURL *url = [self.baseURL URLByAppendingPathComponent:[NSString stringWithFormat:@"v1/devices/%@", self.id]];

    // TODO: check name validity before calling API
    NSMutableDictionary *params = [NSMutableDictionary new];
    params[@"name"] = newName;

    [self setAuthHeaderWithAccessToken];
    
    NSURLSessionDataTask *task = [self.manager PUT:[url description] parameters:params success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        _name = newName;
        if (completion)
        {
            completion(nil);
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
         if (completion) // TODO: better erroring handling
         {
             completion(error);
         }
    }];
    
    return task;
}



#pragma mark Internal use methods
- (NSMutableDictionary *)defaultParams
{
    // TODO: change access token to be passed in header not in body
    if ([SparkCloud sharedInstance].accessToken)
    {
        return [@{@"access_token" : [SparkCloud sharedInstance].accessToken} mutableCopy];
    }
    else return nil;
}

-(void)setAuthHeaderWithAccessToken
{
    if ([SparkCloud sharedInstance].accessToken) {
        NSString *authorization = [NSString stringWithFormat:@"Bearer %@",[SparkCloud sharedInstance].accessToken];
        [self.manager.requestSerializer setValue:authorization forHTTPHeaderField:@"Authorization"];
    }
}


-(NSError *)makeErrorWithDescription:(NSString *)desc code:(NSInteger)errorCode
{
    
    NSMutableDictionary *errorDetail = [NSMutableDictionary dictionary];
    [errorDetail setValue:desc forKey:NSLocalizedDescriptionKey];
    return [NSError errorWithDomain:@"SparkAPIError" code:errorCode userInfo:errorDetail];
}



-(NSString *)description
{
    NSString *desc = [NSString stringWithFormat:@"<SparkDevice 0x%lx, type: %@, id: %@, name: %@, connected: %@, variables: %@, functions: %@, version: %@, requires update: %@, last app: %@, last heard: %@>",
                      (unsigned long)self,
                      (self.type == SparkDeviceTypeCore) ? @"Core" : @"Photon",
                      self.id,
                      self.name,
                      (self.connected) ? @"true" : @"false",
                      self.variables,
                      self.functions,
                      self.version,
                      (self.requiresUpdate) ? @"true" : @"false",
                      self.lastApp,
                      self.lastHeard];
    
    return desc;
    
}


-(NSURLSessionDataTask *)flashKnownApp:(NSString *)knownAppName completion:(nullable SparkCompletionBlock)completion
{
    NSURL *url = [self.baseURL URLByAppendingPathComponent:[NSString stringWithFormat:@"v1/devices/%@", self.id]];
    
    NSMutableDictionary *params = [NSMutableDictionary new];
    params[@"app"] = knownAppName;
    [self setAuthHeaderWithAccessToken];
    
    NSURLSessionDataTask *task = [self.manager PUT:[url description] parameters:params success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject)
    {
        NSDictionary *responseDict = responseObject;
        if (responseDict[@"errors"])
        {
            if (completion) {
                completion([self makeErrorWithDescription:responseDict[@"errors"][@"error"] code:1005]);
            }
        }
        else
        {
            if (completion) {
                completion(nil);
            }
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error)
    {
         if (completion) // TODO: better erroring handling
         {
             completion(error);
         }
    }];
    
    return task;
}


-(nullable NSURLSessionDataTask *)flashFiles:(NSDictionary *)filesDict completion:(nullable SparkCompletionBlock)completion // binary
{
    NSURL *url = [self.baseURL URLByAppendingPathComponent:[NSString stringWithFormat:@"v1/devices/%@", self.id]];
    
    [self setAuthHeaderWithAccessToken];
    
    NSError *reqError;
    NSMutableURLRequest *request = [self.manager.requestSerializer multipartFormRequestWithMethod:@"PUT" URLString:url.description parameters:@{@"file_type" : @"binary"} constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
        // check this:
        for (NSString *key in filesDict.allKeys)
        {
            [formData appendPartWithFileData:filesDict[key] name:@"file" fileName:key mimeType:@"application/octet-stream"];
        }
    } error:&reqError];
    
    if (!reqError)
    {
        NSURLSessionDataTask *task = [self.manager dataTaskWithRequest:request completionHandler:^(NSURLResponse * _Nonnull response, id  _Nullable responseObject, NSError * _Nullable error)
        {
            if (error == nil)
            {
                NSDictionary *responseDict = responseObject;
    //            NSLog(@"flashFiles: %@",responseDict.description);
                if (responseDict[@"error"])
                {
                    if (completion)
                    {
                        completion([self makeErrorWithDescription:responseDict[@"error"] code:1004]);
                    }
                }
                else if (completion)
                {
                    completion(nil);
                }
            }
            else
            {
                // TODO: better erroring handlin
                if (completion)
                {
                    completion(error);
                }
            }
        }];
        
        [task resume];
        return task;
    }
    else
    {
        if (completion)
        {
            completion(reqError);
        }

        return nil;
    }
}




-(nullable id)subscribeToEventsWithPrefix:(nullable NSString *)eventNamePrefix handler:(nullable SparkEventHandler)eventHandler
{
    return [[SparkCloud sharedInstance] subscribeToDeviceEventsWithPrefix:eventNamePrefix deviceID:self.name handler:eventHandler]; // DEBUG TODO self.id
}

-(void)unsubscribeFromEventWithID:(id)eventListenerID
{
    [[SparkCloud sharedInstance] unsubscribeFromEventWithID:eventListenerID];
}

-(NSURLSessionDataTask *)getCurrentDataUsage:(nullable void(^)(float dataUsed, NSError* _Nullable error))completion
{
    if (self.type != SparkDeviceTypeElectron) {
        if (completion)
        {
            NSError *err = [self makeErrorWithDescription:@"Command supported only for Electron device" code:4000];
            completion(-1,err);
        }
        return nil;
    }
    
    //curl https://api.particle.io/v1/sims/8934076500002586576/data_usage\?access_token\=5451a5d6c6c54f6b20e3a109ee764596dc38a520
    NSURL *url = [self.baseURL URLByAppendingPathComponent:[NSString stringWithFormat:@"v1/sims/%@/data_usage", self.lastIccid]];
    
    [self setAuthHeaderWithAccessToken];
    
    NSURLSessionDataTask *task = [self.manager GET:[url description] parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject)
                                  {
                                      if (completion)
                                      {
                                          NSArray *responseArr = responseObject;
                                          float maxUsage = 0;
                                          for (NSDictionary *usageDict in responseArr) {
                                              if (usageDict[@"mbs_used_cumulative"]) {
                                                  float usage = [usageDict[@"mbs_used_cumulative"] floatValue];
                                                  if (usage > maxUsage) {
                                                      maxUsage = usage;
                                                  }
                                              }
                                          }
                                          completion(maxUsage, nil);
                                      }
                                  } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error)
                                  {
                                      if (completion)
                                      {
                                          completion(-1, error);
                                      }
                                  }];
    
    return task;
}

-(void)__receivedSystemEvent:(SparkEvent *)event {
    //{"name":"spark/status","data":"online","ttl":"60","published_at":"2016-07-13T06:20:07.300Z","coreid":"25002a001147353230333635"}
    //        {"name":"spark/flash/status","data":"started ","ttl":"60","published_at":"2016-07-13T06:30:47.130Z","coreid":"25002a001147353230333635"}
    //        {"name":"spark/flash/status","data":"success ","ttl":"60","published_at":"2016-07-13T06:30:47.702Z","coreid":"25002a001147353230333635"}
    //
    //        {"name":"spark/status/safe-mode", "data":"{\"f\":[],\"v\":{},\"p\":6,\"m\":[{\"s\":16384,\"l\":\"m\",\"vc\":30,\"vv\":30,\"f\":\"b\",\"n\":\"0\",\"v\":7,\"d\":[]},{\"s\":262144,\"l\":\"m\",\"vc\":30,\"vv\":30,\"f\":\"s\",\"n\":\"1\",\"v\":15,\"d\":[]},{\"s\":262144,\"l\":\"m\",\"vc\":30,\"vv\":30,\"f\":\"s\",\"n\":\"2\",\"v\":15,\"d\":[{\"f\":\"s\",\"n\":\"1\",\"v\":15,\"_\":\"\"}]},{\"s\":131072,\"l\":\"m\",\"vc\":30,\"vv\":26,\"u\":\"48ABD2D957D0B66069F0BCB04C8591BC8CA01FD1760F1BD47915B2C0D68070B5\",\"f\":\"u\",\"n\":\"1\",\"v\":4,\"d\":[{\"f\":\"s\",\"n\":\"2\",\"v\":17,\"_\":\"\"}]},{\"s\":131072,\"l\":\"f\",\"vc\":30,\"vv\":0,\"d\":[]}]}","ttl":"60","published_at":"2016-07-13T06:39:17.214Z","coreid":"25002a001147353230333635"}
    //        {"name":"spark/device/app-hash", "data":"48ABD2D957D0B66069F0BCB04C8591BC8CA01FD1760F1BD47915B2C0D68070B5","ttl":"60","published_at":"2016-07-13T06:39:17.215Z","coreid":"25002a001147353230333635"}
    //        {"name":"spark/status/safe-mode", "data":"{\"f\":[],\"v\":{},\"p\":6,\"m\":[{\"s\":16384,\"l\":\"m\",\"vc\":30,\"vv\":30,\"f\":\"b\",\"n\":\"0\",\"v\":7,\"d\":[]},{\"s\":262144,\"l\":\"m\",\"vc\":30,\"vv\":30,\"f\":\"s\",\"n\":\"1\",\"v\":15,\"d\":[]},{\"s\":262144,\"l\":\"m\",\"vc\":30,\"vv\":30,\"f\":\"s\",\"n\":\"2\",\"v\":15,\"d\":[{\"f\":\"s\",\"n\":\"1\",\"v\":15,\"_\":\"\"}]},{\"s\":131072,\"l\":\"m\",\"vc\":30,\"vv\":26,\"u\":\"48ABD2D957D0B66069F0BCB04C8591BC8CA01FD1760F1BD47915B2C0D68070B5\",\"f\":\"u\",\"n\":\"1\",\"v\":4,\"d\":[{\"f\":\"s\",\"n\":\"2\",\"v\":17,\"_\":\"\"}]},{\"s\":131072,\"l\":\"f\",\"vc\":30,\"vv\":0,\"d\":[]}]}","ttl":"60","published_at":"2016-07-13T06:39:17.113Z","coreid":"25002a001147353230333635"}
    //        {"name":"spark/safe-mode-updater/updating","data":"1","ttl":"60","published_at":"2016-07-13T06:39:19.467Z","coreid":"particle-internal"}
    //        {"name":"spark/safe-mode-updater/updating","data":"1","ttl":"60","published_at":"2016-07-13T06:39:19.560Z","coreid":"particle-internal"}
    //        {"name":"spark/flash/status","data":"started ","ttl":"60","published_at":"2016-07-13T06:39:21.581Z","coreid":"25002a001147353230333635"}
    
    
    if ([event.event isEqualToString:@"spark/status"]) {
        if ([event.data isEqualToString:@"online"]) {
            self.connected = YES;
            self.isFlashing = NO;
            if ([self.delegate respondsToSelector:@selector(sparkDevice:didReceiveSystemEvent:)]) {
                [self.delegate sparkDevice:self didReceiveSystemEvent:SparkDeviceSystemEventCameOnline];
                
            }
        }
        
        if ([event.data isEqualToString:@"offline"]) {
            self.connected = NO;
            self.isFlashing = NO;
            if ([self.delegate respondsToSelector:@selector(sparkDevice:didReceiveSystemEvent:)]) {
                [self.delegate sparkDevice:self didReceiveSystemEvent:SparkDeviceSystemEventWentOffline];
            }
        }
    }
    
    if ([event.event isEqualToString:@"spark/flash/status"]) {
        if ([event.data containsString:@"started"]) {
            self.isFlashing = YES;
            if ([self.delegate respondsToSelector:@selector(sparkDevice:didReceiveSystemEvent:)]) {
                [self.delegate sparkDevice:self didReceiveSystemEvent:SparkDeviceSystemEventFlashStarted];
                
            }
        }
        
        if ([event.data containsString:@"success"]) {
            self.isFlashing = NO;
            if ([self.delegate respondsToSelector:@selector(sparkDevice:didReceiveSystemEvent:)]) {
                [self.delegate sparkDevice:self didReceiveSystemEvent:SparkDeviceSystemEventFlashSucceeded];
            }
        }
    }
    
    
    if ([event.event isEqualToString:@"spark/device/app-hash"]) {
        self.appHash = event.data;
        self.isFlashing = NO;
        if ([self.delegate respondsToSelector:@selector(sparkDevice:didReceiveSystemEvent:)]) {
            [self.delegate sparkDevice:self didReceiveSystemEvent:SparkDeviceSystemEventAppHashUpdated];
        }
    }
    
    
    if ([event.event isEqualToString:@"spark/status/safe-mode"]) {
        if ([self.delegate respondsToSelector:@selector(sparkDevice:didReceiveSystemEvent:)]) {
            [self.delegate sparkDevice:self didReceiveSystemEvent:SparkDeviceSystemEventSafeModeUpdater];
        }
    }
    
    if ([event.event isEqualToString:@"spark/safe-mode-updater/updating"]) {
        if ([self.delegate respondsToSelector:@selector(sparkDevice:didReceiveSystemEvent:)]) {
            [self.delegate sparkDevice:self didReceiveSystemEvent:SparkDeviceSystemEventSafeModeUpdater];
        }
    }
    
    
    
    
    
    
}


@end

NS_ASSUME_NONNULL_END
