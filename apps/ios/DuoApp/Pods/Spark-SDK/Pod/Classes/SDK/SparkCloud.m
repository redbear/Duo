//
//  SparkCloud.m
//  mobile-sdk-ios
//
//  Created by Ido Kleinman on 11/7/14.
//  Copyright (c) 2014-2015 Spark. All rights reserved.
//

#import "SparkCloud.h"
#import "KeychainItemWrapper.h"
#import "SparkSession.h"
//#import "SparkUser.h"
#import <AFNetworking/AFNetworking.h>
#import <EventSource.h>
#import "SparkEvent.h"

NS_ASSUME_NONNULL_BEGIN

#define GLOBAL_API_TIMEOUT_INTERVAL     31.0f

NSString *const kSparkAPIBaseURL = @"https://api.particle.io";
NSString *const kEventListenersDictEventSourceKey = @"eventSource";
NSString *const kEventListenersDictHandlerKey = @"eventHandler";
NSString *const kEventListenersDictIDKey = @"id";

static NSString *const kDefaultOAuthClientId = @"particle";
static NSString *const kDefaultOAuthClientSecret = @"particle";

@interface SparkCloud () <SparkSessionDelegate>

@property (nonatomic, strong, nonnull) NSURL* baseURL;
@property (nonatomic, strong, nullable) SparkSession* session;
//@property (nonatomic, strong, nullable) SparkUser* user;
@property (nonatomic, strong, nonnull) AFHTTPSessionManager *manager;

@property (nonatomic, strong, nonnull) NSMutableDictionary *eventListenersDict;

@property (nonatomic, strong) NSMapTable *devicesMapTable;
@property (nonatomic, strong) id systemEventsListenerId;
@end


@implementation SparkCloud

#pragma mark Class initialization and singleton instancing

+ (instancetype)sharedInstance;
{
    // TODO: no singleton, initializer gets: CloudConnection, CloudEndpoint (URL) to allow private cloud, dependency injection
    static SparkCloud *sharedInstance = nil;
    @synchronized(self) {
        if (sharedInstance == nil)
        {
            sharedInstance = [[self alloc] init];
        }
    }
    return sharedInstance;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.baseURL = [NSURL URLWithString:kSparkAPIBaseURL];
        if (!self.baseURL)
        {
            return nil;
        }

//        self.loggedIn = NO;

        self.OAuthClientId = kDefaultOAuthClientId;
        self.OAuthClientSecret = kDefaultOAuthClientSecret;

        // try to restore session (user and access token)
//        self.user = [[SparkUser alloc] initWithSavedSession];
        self.session = [[SparkSession alloc] initWithSavedSession];
        if (self.session)
        {
            self.session.delegate = self;
        }
        
        // Init HTTP manager
        self.manager = [[AFHTTPSessionManager alloc] initWithBaseURL:self.baseURL];
        self.manager.responseSerializer = [AFJSONResponseSerializer serializer];
        [self.manager.requestSerializer setTimeoutInterval:GLOBAL_API_TIMEOUT_INTERVAL];
        if (!self.manager)
        {
            return nil;
        }

        // init event listeners internal dictionary
        self.eventListenersDict = [NSMutableDictionary new];
        [self subscribeToDevicesSystemEvents];
    }
    return self;
}


#pragma mark Getter functions

-(nullable NSString *)accessToken
{
    return [self.session accessToken];
}

-(BOOL)injectSessionAccessToken:(NSString * _Nonnull)accessToken
{
    [self logout];
    self.session = [[SparkSession alloc] initWithToken:accessToken];
    if (self.session) {
        self.session.delegate = self;
        return YES;
    } else return NO;
}

-(BOOL)injectSessionAccessToken:(NSString *)accessToken withExpiryDate:(NSDate *)expiryDate
{
    [self logout];
    self.session = [[SparkSession alloc] initWithToken:accessToken andExpiryDate:expiryDate];
    if (self.session) {
        self.session.delegate = self;
        return YES;
    } else return NO;
}

-(BOOL)injectSessionAccessToken:(NSString *)accessToken withExpiryDate:(NSDate *)expiryDate andRefreshToken:(nonnull NSString *)refreshToken
{
    [self logout];
    self.session = [[SparkSession alloc] initWithToken:accessToken withExpiryDate:expiryDate withRefreshToken:refreshToken];
    if (self.session) {
        self.session.delegate = self;
        return YES;
    } else return NO;

}

-(nullable NSString *)loggedInUsername
{
    if ((self.session.username) && (self.session.accessToken))
    {
        return self.session.username;
    }
    else
    {
        return nil;
    }
}

-(BOOL)isLoggedIn
{
    return (self.session.username != nil);
}

-(BOOL)isAuthenticated
{
    return (self.session.accessToken != nil);
}

#pragma mark Setter functions

-(void)setOAuthClientId:(nullable NSString *)OAuthClientId {
    _OAuthClientId = OAuthClientId ?: kDefaultOAuthClientId;
}

-(void)setOAuthClientSecret:(nullable NSString *)OAuthClientSecret {
    _OAuthClientSecret = OAuthClientSecret ?: kDefaultOAuthClientSecret;
}

#pragma mark Delegate functions

-(void)SparkSession:(SparkSession *)session didExpireAt:(NSDate *)date
{
    // handle auto-renewal of expired access tokens by internal timer event
    // TODO: fix that to do it using a refresh token and not save the user password!
    if (self.session.refreshToken) {
        [self refreshToken:self.session.refreshToken];
    }
    else {
        [self logout];
    }
}

-(void)refreshToken:(NSString *)refreshToken
{
//    NSLog(@"Refreshing session...");
    // non default params
    NSDictionary *params = @{
                             @"grant_type": @"refresh_token",
                             @"refresh_token": refreshToken
                             };
    
    [self.manager.requestSerializer setAuthorizationHeaderFieldWithUsername:self.OAuthClientId password:self.OAuthClientSecret];
    // OAuth login
    [self.manager POST:@"oauth/token" parameters:params progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        NSMutableDictionary *responseDict = [responseObject mutableCopy];
        
        if (self.session.username)
            responseDict[@"username"] = self.session.username;
        
        self.session = [[SparkSession alloc] initWithNewSession:responseDict];
        if (self.session) // login was successful
        {
//            NSLog(@"New session created using refresh token");
            self.session.delegate = self;
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSHTTPURLResponse *serverResponse = (NSHTTPURLResponse *)task.response;
        
        NSData *errorData = error.userInfo[AFNetworkingOperationFailingURLResponseDataErrorKey];
        if (errorData)
        {
            NSDictionary *serializedFailedBody = [NSJSONSerialization JSONObjectWithData:errorData options:kNilOptions error:nil];
            NSLog(@"! refreshToken %@ Failed (status code %d): %@", task.originalRequest.URL,(int)serverResponse.statusCode,serializedFailedBody);
        }
    }];
    
    [self.manager.requestSerializer clearAuthorizationHeader];

}


#pragma mark SDK public functions

-(NSURLSessionDataTask *)loginWithUser:(NSString *)user password:(NSString *)password completion:(nullable SparkCompletionBlock)completion
{
    // non default params
    NSDictionary *params = @{
                             @"grant_type": @"password",
                             @"username": user,
                             @"password": password,
                             };
    
    [self.manager.requestSerializer setAuthorizationHeaderFieldWithUsername:self.OAuthClientId password:self.OAuthClientSecret];
    // OAuth login
    NSURLSessionDataTask *task = [self.manager POST:@"oauth/token" parameters:params progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        NSMutableDictionary *responseDict = [responseObject mutableCopy];

        responseDict[@"username"] = user;
        self.session = [[SparkSession alloc] initWithNewSession:responseDict];
        if (self.session) // login was successful
        {
            self.session.delegate = self;
        }
        
        if (completion)
        {
            completion(nil);
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSHTTPURLResponse *serverResponse = (NSHTTPURLResponse *)task.response;
        
        // check type of error?
        if (completion)
        {
            completion([NSError errorWithDomain:error.domain code:serverResponse.statusCode userInfo:error.userInfo]);
        }

        NSData *errorData = error.userInfo[AFNetworkingOperationFailingURLResponseDataErrorKey];
        if (errorData)
        {
            NSDictionary *serializedFailedBody = [NSJSONSerialization JSONObjectWithData:errorData options:kNilOptions error:nil];
            NSLog(@"! loginWithUser %@ Failed (status code %d): %@", task.originalRequest.URL,(int)serverResponse.statusCode,serializedFailedBody);
        }
    }];
    
    [self.manager.requestSerializer clearAuthorizationHeader];
    
    return task;
}

-(NSURLSessionDataTask *)signupWithUser:(NSString *)user password:(NSString *)password completion:(nullable SparkCompletionBlock)completion
{
    
    // non default params
    NSDictionary *params = @{
                             @"username": user,
                             @"password": password,
                             };
    
    NSURLSessionDataTask *task = [self.manager POST:@"/v1/users/" parameters:params progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject)
    {
         NSDictionary *responseDict = responseObject;
         if (completion) {
             if ([responseDict[@"ok"] boolValue])
             {
                 completion(nil);
             }
             else
             {
                 NSString *errorString;
                 if (responseDict[@"errors"][0])
                     errorString = [NSString stringWithFormat:@"Could not sign up: %@",responseDict[@"errors"][0]];
                 else
                     errorString = @"Error signing up";
                 completion([self makeErrorWithDescription:errorString code:1004]);
             }
         }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error)
    {
        NSHTTPURLResponse *serverResponse = (NSHTTPURLResponse *)task.response;
         // check type of error?
         if (completion)
         {
             completion([NSError errorWithDomain:error.domain code:serverResponse.statusCode userInfo:error.userInfo]);
         }

         NSData *errorData = error.userInfo[AFNetworkingOperationFailingURLResponseDataErrorKey];
         if (errorData)
         {
             NSDictionary *serializedFailedBody = [NSJSONSerialization JSONObjectWithData:errorData options:kNilOptions error:nil];
             NSLog(@"! signupWithUser %@ Failed (status code %d): %@",task.originalRequest.URL,(int)serverResponse.statusCode,serializedFailedBody);
         }
    }];
    
    [self.manager.requestSerializer clearAuthorizationHeader];
    
    return task;
}


-(nullable NSURLSessionDataTask *)signupWithCustomer:(NSString *)email password:(NSString *)password orgSlug:(NSString *)orgSlug completion:(nullable SparkCompletionBlock)completion
{
    // Make sure we got an orgSlug that was neither nil nor the empty string
    if (orgSlug.length == 0)
    {
        if (completion)
        {
            completion([self makeErrorWithDescription:@"Organization slug must be specified" code:1006]);
        }
        return nil;
    }

    if ((!self.OAuthClientId) || (!self.OAuthClientSecret))
    {
        if (completion)
        {
            completion([self makeErrorWithDescription:@"Client OAuth credentials must be set to create a new customer" code:1010]);
        }
        return nil;
    }
    
    [self.manager.requestSerializer setAuthorizationHeaderFieldWithUsername:self.OAuthClientId password:self.OAuthClientSecret];

    // non default params
    NSMutableDictionary *params = [@{
                             @"email": email,
                             @"password": password,
                             @"grant_type" : @"client_credentials",
                             } mutableCopy];
    
//    if (inviteCode)
//        params[@"activation_code"] = inviteCode;
    
    NSString *url = [NSString stringWithFormat:@"/v1/orgs/%@/customers", orgSlug];
//    NSLog(@"Signing up customer...");
    
    NSURLSessionDataTask *task = [self.manager POST:url parameters:params progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject)
    {
        NSHTTPURLResponse *serverResponse = (NSHTTPURLResponse *)task.response;
        NSMutableDictionary *responseDict = [responseObject mutableCopy];
//        NSLog(@"Got status code %d, and response: %@",(int)serverResponse.statusCode,responseDict);

        responseDict[@"username"] = email;
        
         self.session = [[SparkSession alloc] initWithNewSession:responseDict];
        
         if (self.session) // customer login was successful
         {
             self.session.delegate = self;
         }
         
         if (completion)
         {
             if (serverResponse.statusCode == 201)
             {
                 completion(nil);
             }
             else
             {
                 NSString *errorDesc = ([responseDict[@"error"] stringValue]); // check name of field
                 completion([self makeErrorWithDescription:errorDesc code:1004]);
             }
         }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error)
    {
         NSHTTPURLResponse *serverResponse = (NSHTTPURLResponse *)task.response;
         // check type of error?
         if (completion)
         {
             completion([NSError errorWithDomain:error.domain code:serverResponse.statusCode userInfo:error.userInfo]);
         }
        
         NSData *errorData = error.userInfo[AFNetworkingOperationFailingURLResponseDataErrorKey];
         if (errorData)
         {
             NSDictionary *serializedFailedBody = [NSJSONSerialization JSONObjectWithData:errorData options:kNilOptions error:nil];
             NSLog(@"! signupWithCustomer %@ Failed (status code %d): %@", url, (int)serverResponse.statusCode,serializedFailedBody);
         }
    }];
    
    [self.manager.requestSerializer clearAuthorizationHeader];
    
    return task;
}

-(void)logout
{
    [self.session removeSession];
}

-(NSURLSessionDataTask *)claimDevice:(NSString *)deviceID completion:(nullable SparkCompletionBlock)completion
{
    if (self.session.accessToken) {
        NSString *authorization = [NSString stringWithFormat:@"Bearer %@",self.session.accessToken];
        [self.manager.requestSerializer setValue:authorization forHTTPHeaderField:@"Authorization"];
    }

    NSMutableDictionary *params = [NSMutableDictionary new]; //[self defaultParams];
    params[@"id"] = deviceID;
    
    NSURLSessionDataTask *task = [self.manager POST:@"/v1/devices" parameters:params progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject)
    {
        if (completion)
        {
            NSMutableDictionary *responseDict = responseObject;
            
            if ([responseDict[@"ok"] boolValue])
            {
                completion(nil);
            } else
            {
                completion([self makeErrorWithDescription:@"Could not claim device" code:1002]);
            }
            
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSHTTPURLResponse *serverResponse = (NSHTTPURLResponse *)task.response;
        // check type of error?
        if (completion)
        {
            completion([NSError errorWithDomain:error.domain code:serverResponse.statusCode userInfo:error.userInfo]);
        }
        
        NSData *errorData = error.userInfo[AFNetworkingOperationFailingURLResponseDataErrorKey];
        if (errorData)
        {
            NSDictionary *serializedFailedBody = [NSJSONSerialization JSONObjectWithData:errorData options:kNilOptions error:nil];
            NSLog(@"! claimDevice %@ Failed (status code %d): %@",task.originalRequest.URL,(int)serverResponse.statusCode,serializedFailedBody);
        }
    }];
    
    return task;
}

-(NSURLSessionDataTask *)getDevice:(NSString *)deviceID
                        completion:(nullable void (^)(SparkDevice * _Nullable device, NSError * _Nullable error))completion
{
    if (self.session.accessToken) {
        NSString *authorization = [NSString stringWithFormat:@"Bearer %@",self.session.accessToken];
        [self.manager.requestSerializer setValue:authorization forHTTPHeaderField:@"Authorization"];
    }

    NSString *urlPath = [NSString stringWithFormat:@"/v1/devices/%@",deviceID];
    
    NSURLSessionDataTask *task = [self.manager GET:urlPath parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject)
    {
         if (completion)
         {
             NSMutableDictionary *responseDict = responseObject;
             SparkDevice *device = [[SparkDevice alloc] initWithParams:responseDict];
             
             if (device) { // new 0.5.0 local storage of devices for reporting system events
                 if (!self.devicesMapTable) {
                     self.devicesMapTable = [NSMapTable mapTableWithKeyOptions:NSMapTableStrongMemory valueOptions:NSMapTableWeakMemory]; // let the user decide when to release SparkDevice objects 
                 }
                 [self.devicesMapTable setObject:device forKey:device.id];
             }
             
             if (completion)
             {
                completion(device, nil);
             }
             
         }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error)
    {
         // check type of error?
        
        NSHTTPURLResponse *serverResponse = (NSHTTPURLResponse *)task.response;
        if (completion)
        {
            completion(nil, [NSError errorWithDomain:error.domain code:serverResponse.statusCode userInfo:error.userInfo]);
        }
        
        NSData *errorData = error.userInfo[AFNetworkingOperationFailingURLResponseDataErrorKey];
        if (errorData)
        {
            NSDictionary *serializedFailedBody = [NSJSONSerialization JSONObjectWithData:errorData options:kNilOptions error:nil];
            NSLog(@"! getDevice %@ Failed (status code %d): %@",task.originalRequest.URL,(int)serverResponse.statusCode,serializedFailedBody);
        }
    }];
    
    return task;
}


-(NSURLSessionDataTask *)getDevices:(nullable void (^)(NSArray * _Nullable sparkDevices, NSError * _Nullable error))completion
{
    if (self.session.accessToken) {
        NSString *authorization = [NSString stringWithFormat:@"Bearer %@", self.session.accessToken];
        [self.manager.requestSerializer setValue:authorization forHTTPHeaderField:@"Authorization"];
    }
    
    NSURLSessionDataTask *task = [self.manager GET:@"/v1/devices" parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject)
    {
        
         if (completion)
         {
             
             NSArray *responseList = responseObject;
             NSMutableArray *queryDeviceIDList = [[NSMutableArray alloc] init];
             __block NSMutableArray *deviceList = [[NSMutableArray alloc] init];
             __block NSError *deviceError = nil;
             // analyze
             for (NSDictionary *deviceDict in responseList)
             {
                 if (deviceDict[@"id"])   // ignore <null> device listings that sometimes return from /v1/devices API call
                 {
                     if (![deviceDict[@"id"] isKindOfClass:[NSNull class]])
                     {
                         if ([deviceDict[@"connected"] boolValue]==YES) // do inquiry only for online devices (otherwise we waste time on request timeouts and get no new info)
                         {
                             // if it's online then add it to the query list so we can get additional information about it
                             [queryDeviceIDList addObject:deviceDict[@"id"]];
                         }
                         else
                         {
                             // if it's offline just make an instance for it with the limited data with have
                             SparkDevice *device = [[SparkDevice alloc] initWithParams:deviceDict];
                             [deviceList addObject:device];
                             
                             if (device) { // new 0.5.0 local storage of devices for reporting system events
                                 if (!self.devicesMapTable) {
                                     self.devicesMapTable = [NSMapTable mapTableWithKeyOptions:NSMapTableStrongMemory valueOptions:NSMapTableWeakMemory]; // let the user decide when to release SparkDevice objects
                                 }
                                 [self.devicesMapTable setObject:device forKey:device.id];
                             }

                         }
                     }
                     
                 }
             }
             
             // iterate thru deviceList and create SparkDevice instances through query
             __block dispatch_group_t group = dispatch_group_create();
             
             for (NSString *deviceID in queryDeviceIDList)
             {
                 dispatch_group_enter(group);
                 [self getDevice:deviceID completion:^(SparkDevice *device, NSError *error) {
                     if ((!error) && (device))
                         [deviceList addObject:device];
                     
                     if ((error) && (!deviceError)) // if there wasn't an error before cache it
                         deviceError = error;
                     
                     dispatch_group_leave(group);
                 }];
             }
             
             // call user's completion block on main thread after all concurrent GET requests finished and SparkDevice instances created
             dispatch_group_notify(group, dispatch_get_main_queue(), ^{
                 if (completion)
                 {
                     if (deviceError && (deviceList.count==0)) // empty list? error? report it
                     {
                         completion(nil, deviceError);
                     }
                     else if (deviceList.count > 0)  // if some devices reported error but some not, then return at least the ones that didn't report error, ditch error
                     {
                         completion(deviceList, nil);
                     }
                     else
                     {
                         completion(nil, nil);
                     }
                 }
             });
             
             
             
         }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error)
    {
        // check type of error?
        NSHTTPURLResponse *serverResponse = (NSHTTPURLResponse *)task.response;
        if (completion)
        {
            completion(nil, [NSError errorWithDomain:error.domain code:serverResponse.statusCode userInfo:error.userInfo]);
        }
        
        NSData *errorData = error.userInfo[AFNetworkingOperationFailingURLResponseDataErrorKey];
        if (errorData)
        {
            NSDictionary *serializedFailedBody = [NSJSONSerialization JSONObjectWithData:errorData options:kNilOptions error:nil];
            NSLog(@"! getDevices %@ Failed (status code %d): %@",task.originalRequest.URL,(int)serverResponse.statusCode,serializedFailedBody);
        }
    }];
    
    return task;
}



-(NSURLSessionDataTask *)generateClaimCode:(nullable void(^)(NSString * _Nullable claimCode, NSArray * _Nullable userClaimedDeviceIDs, NSError * _Nullable error))completion
{
    if (self.session.accessToken) {
        NSString *authorization = [NSString stringWithFormat:@"Bearer %@",self.session.accessToken];
        [self.manager.requestSerializer setValue:authorization forHTTPHeaderField:@"Authorization"];
    }

    NSString *urlPath = [NSString stringWithFormat:@"/v1/device_claims"];
    NSURLSessionDataTask *task = [self.manager POST:urlPath parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject)
    {
        if (completion)
        {
            NSDictionary *responseDict = responseObject;
            if (responseDict[@"claim_code"])
            {
                NSArray *claimedDeviceIDs = responseDict[@"device_ids"];
                if ((claimedDeviceIDs) && (claimedDeviceIDs.count > 0))
                {
                    completion(responseDict[@"claim_code"], responseDict[@"device_ids"], nil);
                }
                else
                {
                    completion(responseDict[@"claim_code"], nil, nil);
                }
            }
            else
            {
                completion(nil, nil, [self makeErrorWithDescription:@"Could not generate a claim code" code:1005]); //TODO: collect all codes to a table
            }
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error)
    {
        NSHTTPURLResponse *serverResponse = (NSHTTPURLResponse *)task.response;
        if (completion)
        {
            completion(nil, nil, [NSError errorWithDomain:error.domain code:serverResponse.statusCode userInfo:error.userInfo]);
        }
        
        NSData *errorData = error.userInfo[AFNetworkingOperationFailingURLResponseDataErrorKey];
        if (errorData)
        {
            NSDictionary *serializedFailedBody = [NSJSONSerialization JSONObjectWithData:errorData options:kNilOptions error:nil];
            NSLog(@"! generateClaimCode %@ Failed (status code %d): %@",task.originalRequest.URL,(int)serverResponse.statusCode,serializedFailedBody);
        }
    }];
    
    return task;
}



-(NSURLSessionDataTask *)generateClaimCodeForOrganization:(NSString *)orgSlug
                                               andProduct:(NSString *)productSlug
                                       withActivationCode:(nullable NSString *)activationCode
                                               completion:(nullable void(^)(NSString * _Nullable claimCode, NSArray * _Nullable userClaimedDeviceIDs, NSError * _Nullable error))completion
{
    if (self.session.accessToken) {
        NSString *authorization = [NSString stringWithFormat:@"Bearer %@",self.session.accessToken];
        [self.manager.requestSerializer setValue:authorization forHTTPHeaderField:@"Authorization"];
    }
    
    NSDictionary *params;
    if (activationCode) params = @{@"activation_code" : activationCode};


    NSCharacterSet *set = [NSCharacterSet URLHostAllowedCharacterSet]; // encode it in case there are special chars in org/product name (there shouldn't be)
    NSString *encodedOrgSlug = [orgSlug stringByAddingPercentEncodingWithAllowedCharacters:set];
    NSString *encodedProductSlug = [productSlug stringByAddingPercentEncodingWithAllowedCharacters:set];

    NSString *urlPath = [NSString stringWithFormat:@"/v1/orgs/%@/products/%@/device_claims", encodedOrgSlug, encodedProductSlug];

    NSURLSessionDataTask *task = [self.manager POST:urlPath parameters:params progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject)
    {
        if (completion)
        {
            NSDictionary *responseDict = responseObject;
            if (responseDict[@"claim_code"])
            {
                NSArray *claimedDeviceIDs = responseDict[@"device_ids"];
                if ((claimedDeviceIDs) && (claimedDeviceIDs.count > 0))
                {
                    completion(responseDict[@"claim_code"], responseDict[@"device_ids"], nil);
                }
                else
                {
                    completion(responseDict[@"claim_code"], nil, nil);
                }
            }
            else
            {
                completion(nil, nil, [self makeErrorWithDescription:@"Could not generate a claim code" code:1007]);
            }
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error)
    {
        NSHTTPURLResponse *serverResponse = (NSHTTPURLResponse *)task.response;
        NSData *errorData = error.userInfo[AFNetworkingOperationFailingURLResponseDataErrorKey];
        if (errorData)
        {
            NSDictionary *serializedFailedBody = [NSJSONSerialization JSONObjectWithData:errorData options:kNilOptions error:nil];
            NSLog(@"! generateClaimCodeForOrganization %@ Failed (status code %d): %@",task.originalRequest.URL,(int)serverResponse.statusCode,serializedFailedBody);
        }
        
        if (completion) {
            completion(nil, nil, [NSError errorWithDomain:error.domain code:serverResponse.statusCode userInfo:error.userInfo]);
        }
    }];
    
    return task;
}

-(NSURLSessionDataTask *)requestPasswordResetForCustomer:(NSString *)orgSlug
                                                   email:(NSString *)email
                                              completion:(nullable SparkCompletionBlock)completion
{
    NSDictionary *params = @{@"email": email};
    NSString *urlPath = [NSString stringWithFormat:@"/v1/orgs/%@/customers/reset_password", orgSlug];
    
    
    NSURLSessionDataTask *task = [self.manager POST:urlPath parameters:params progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject)
    {
        if (completion) // TODO: check responses
        {
            completion(nil);
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error)
    {
        NSHTTPURLResponse *serverResponse = (NSHTTPURLResponse *)task.response;
        if (completion)
        {
            // make error have the HTTP response status code
            // TODO: for all
            completion([NSError errorWithDomain:error.domain code:serverResponse.statusCode userInfo:error.userInfo]);
        }
        
        NSData *errorData = error.userInfo[AFNetworkingOperationFailingURLResponseDataErrorKey];
        if (errorData)
        {
            NSDictionary *serializedFailedBody = [NSJSONSerialization JSONObjectWithData:errorData options:kNilOptions error:nil];
            NSLog(@"! requestPasswordReset %@ Failed (status code %d): %@",task.originalRequest.URL,(int)serverResponse.statusCode,serializedFailedBody);
        }
    }];
    
    return task;
}


-(NSURLSessionDataTask *)requestPasswordResetForUser:(NSString *)email
                                          completion:(nullable SparkCompletionBlock)completion
{
    NSDictionary *params = @{@"username": email};
    NSString *urlPath = [NSString stringWithFormat:@"/v1/user/password-reset"];
    
    NSURLSessionDataTask *task = [self.manager POST:urlPath parameters:params progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject)
    {
        if (completion) // TODO: check responses
        {
            completion(nil);
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSHTTPURLResponse *serverResponse = (NSHTTPURLResponse *)task.response;
        if (completion)
        {
            // make error have the HTTP response status code
            // TODO: for all
            completion([NSError errorWithDomain:error.domain code:serverResponse.statusCode userInfo:error.userInfo]);
        }
        
        NSData *errorData = error.userInfo[AFNetworkingOperationFailingURLResponseDataErrorKey];
        if (errorData)
        {
            
            NSDictionary *serializedFailedBody = [NSJSONSerialization JSONObjectWithData:errorData options:kNilOptions error:nil];
            NSLog(@"! requestPasswordResetForUser %@ Failed (status code %d): %@",task.originalRequest.URL,(int)serverResponse.statusCode,serializedFailedBody);
        }
    }];
    
    return task;
}

#pragma mark Internal use methods

-(NSURLSessionDataTask *)listTokens:(NSString *)user password:(NSString *)password
{
    [self.manager.requestSerializer setAuthorizationHeaderFieldWithUsername:user password:password];
    
    NSURLSessionDataTask *task = [self.manager GET:@"/v1/access_tokens" parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject)
    {
//        NSArray *responseArr = responseObject;
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error)
    {
        NSLog(@"listTokens %@",[error localizedDescription]);
    }];
    
    [self.manager.requestSerializer clearAuthorizationHeader];
    
    return task;
}

-(NSError *)makeErrorWithDescription:(NSString *)desc code:(NSInteger)errorCode
{
    NSMutableDictionary *errorDetail = [NSMutableDictionary dictionary];
    [errorDetail setValue:desc forKey:NSLocalizedDescriptionKey];
    return [NSError errorWithDomain:@"SparkAPIError" code:errorCode userInfo:errorDetail];
}


#pragma mark Events subsystem implementation

-(nullable id)subscribeToEventWithURL:(NSURL *)url handler:(nullable SparkEventHandler)eventHandler
{
    if (!self.accessToken)
    {
        eventHandler(nil, [self makeErrorWithDescription:@"No active access token" code:1008]);
        return nil;
    }

    // TODO: add eventHandler + source to an internal dictionary so it will be removeable later by calling removeEventListener on saved Source
    EventSource *source = [EventSource eventSourceWithURL:url timeoutInterval:300.0f queue:dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0)];
    
    //    if (eventName == nil)
    //        eventName = @"no_name";
    
    // - event example -
    // event: Temp
    // data: {"data":"Temp1 is 41.900002 F, Temp2 is $f F","ttl":"60","published_at":"2015-01-13T01:23:12.269Z","coreid":"53ff6e066667574824151267"}
    
    //    [source addEventListener:@"" handler:^(Event *event) { //event name
//    [source onMessage:
    
     EventSourceEventHandler handler = ^void(Event *event) {
        if (eventHandler)
        {
            if (event.error)
                eventHandler(nil, event.error);
            else
            {
                // deserialize event payload into dictionary
                NSError *error;
                NSDictionary *jsonDict;
                NSMutableDictionary *eventDict;
                if (event.data)
                {
                    jsonDict = [NSJSONSerialization JSONObjectWithData:event.data options:0 error:&error];
                    eventDict = [jsonDict mutableCopy];
                }
                
                if ((eventDict) && (!error))
                {
                    if (event.name)
                    {
                        eventDict[@"event"] = event.name; // add event name to dict
                    }
                    SparkEvent *sparkEvent = [[SparkEvent alloc] initWithEventDict:eventDict];
                    eventHandler(sparkEvent ,nil); // callback with parsed data
                }
                else if (error)
                {
                    eventHandler(nil, error);
                }
            }
        }
        
    };
    
    [source onMessage:handler]; // bind the handler
    
    id eventListenerID = [NSUUID UUID]; // create the eventListenerID
    self.eventListenersDict[eventListenerID] = @{kEventListenersDictHandlerKey : handler,
                                                 kEventListenersDictEventSourceKey : source}; // save it in the internal dictionary for future unsubscribing
    
    return eventListenerID;
    
}


-(void)unsubscribeFromEventWithID:(id)eventListenerID
{
    NSDictionary *eventListenerDict = [self.eventListenersDict objectForKey:eventListenerID];
    if (eventListenerDict)
    {
        EventSource *source = [eventListenerDict objectForKey:kEventListenersDictEventSourceKey];
        EventSourceEventHandler handler = [eventListenerDict objectForKey:kEventListenersDictHandlerKey];
        [source removeEventListener:MessageEvent handler:handler];
        [source close];
        [self.eventListenersDict removeObjectForKey:eventListenerID];
    }
}


-(nullable id)subscribeToAllEventsWithPrefix:(nullable NSString *)eventNamePrefix handler:(nullable SparkEventHandler)eventHandler
{
    // GET /v1/events[/:event_name]
    NSString *endpoint;
    if ((!eventNamePrefix) || [eventNamePrefix isEqualToString:@""])
    {
        endpoint = [NSString stringWithFormat:@"%@/v1/events", self.baseURL];
    }
    else
    {
        // URL encode name prefix
        NSCharacterSet *set = [NSCharacterSet URLHostAllowedCharacterSet];
        NSString *encodedEventPrefix = [eventNamePrefix stringByAddingPercentEncodingWithAllowedCharacters:set];

        endpoint = [NSString stringWithFormat:@"%@/v1/events/%@?access_token=%@", self.baseURL, encodedEventPrefix, self.accessToken];
    }
    
    return [self subscribeToEventWithURL:[NSURL URLWithString:endpoint] handler:eventHandler];
}


-(nullable id)subscribeToMyDevicesEventsWithPrefix:(nullable NSString *)eventNamePrefix handler:(nullable SparkEventHandler)eventHandler
{
    // GET /v1/devices/events[/:event_name]
    NSString *endpoint;
    if ((!eventNamePrefix) || [eventNamePrefix isEqualToString:@""])
    {
        // TODO: check
        endpoint = [NSString stringWithFormat:@"%@/v1/devices/events?access_token=%@", self.baseURL, self.accessToken];
    }
    else
    {
        // URL encode name prefix
        NSCharacterSet *set = [NSCharacterSet URLHostAllowedCharacterSet];
        NSString *encodedEventPrefix = [eventNamePrefix stringByAddingPercentEncodingWithAllowedCharacters:set];
       
        endpoint = [NSString stringWithFormat:@"%@/v1/devices/events/%@?access_token=%@", self.baseURL, encodedEventPrefix, self.accessToken];
    }
    
    return [self subscribeToEventWithURL:[NSURL URLWithString:endpoint] handler:eventHandler];
    
}

-(nullable id)subscribeToDeviceEventsWithPrefix:(nullable NSString *)eventNamePrefix deviceID:(NSString *)deviceID handler:(nullable SparkEventHandler)eventHandler
{
    // GET /v1/devices/:device_id/events[/:event_name]
    NSString *endpoint;
    if ((!eventNamePrefix) || [eventNamePrefix isEqualToString:@""])
    {
        endpoint = [NSString stringWithFormat:@"%@/v1/devices/%@/events?access_token=%@", self.baseURL, deviceID, self.accessToken];
    }
    else
    {
        // URL encode name prefix
        NSCharacterSet *set = [NSCharacterSet URLHostAllowedCharacterSet];
        NSString *encodedEventPrefix = [eventNamePrefix stringByAddingPercentEncodingWithAllowedCharacters:set];

        endpoint = [NSString stringWithFormat:@"%@/v1/devices/%@/events/%@?access_token=%@", self.baseURL, deviceID, encodedEventPrefix, self.accessToken];
    }
    
    return [self subscribeToEventWithURL:[NSURL URLWithString:endpoint] handler:eventHandler];
}



-(NSURLSessionDataTask *)publishEventWithName:(NSString *)eventName
                                         data:(NSString *)data
                                    isPrivate:(BOOL)isPrivate
                                          ttl:(NSUInteger)ttl
                                   completion:(nullable SparkCompletionBlock)completion
{
    NSMutableDictionary *params = [NSMutableDictionary new];
    if (self.session.accessToken) {
        NSString *authorization = [NSString stringWithFormat:@"Bearer %@",self.session.accessToken];
        [self.manager.requestSerializer setValue:authorization forHTTPHeaderField:@"Authorization"];
    }
    
    params[@"name"] = eventName;
    params[@"data"] = data;
    params[@"private"] = isPrivate ? @"true" : @"false";
    params[@"ttl"] = [NSString stringWithFormat:@"%lu", (unsigned long)ttl];
    
    NSURLSessionDataTask *task = [self.manager POST:@"/v1/devices/events" parameters:params progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject)
    {
        if (completion)
        {
            // TODO: check server response for that
            NSDictionary *responseDict = responseObject;
            if (![responseDict[@"ok"] boolValue])
            {
                NSError *err = [self makeErrorWithDescription:@"Server reported error publishing event" code:1009];
                completion(err);
            }
            else
            {
                completion(nil);
            }
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



-(void)subscribeToDevicesSystemEvents {
    
    __weak SparkCloud *weakSelf = self;
    self.systemEventsListenerId = [self subscribeToMyDevicesEventsWithPrefix:@"spark" handler:^(SparkEvent * _Nullable event, NSError * _Nullable error) {

        if (!error) {
//            NSLog(@"--> devicesMapTable got %d entries",weakSelf.devicesMapTable.count); // debug
            SparkDevice *device = [weakSelf.devicesMapTable objectForKey:event.deviceID];
            if (device) {
//                NSLog(@"* Device %@ (%@) got system event %@:%@",device.name,device.id,event.event,event.data); // debug
                [device __receivedSystemEvent:event];
            }
        } else {
            NSLog(@"! SparkCloud could not subscribe to devices system events %@",error.localizedDescription);
        }
    }];

}


-(void)dealloc {
    if (self.systemEventsListenerId) {
        [self unsubscribeFromEventWithID:self.systemEventsListenerId];
    }
}

@end

NS_ASSUME_NONNULL_END
