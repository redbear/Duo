//
//  EventSource.m
//  EventSource
//
//  Created by Neil on 25/07/2013.
//  Copyright (c) 2013 Neil Cowburn. All rights reserved,
//  Heavily modified to match Particle event structure by Ido Kleinman, 2015
//  Original codebase:
//  https://github.com/neilco/EventSource


#import "EventSource.h"

static float const ES_RETRY_INTERVAL = 1.0;

static NSString *const ESKeyValueDelimiter = @": ";
static NSString *const ESEventSeparatorLFLF = @"\n\n";
static NSString *const ESEventSeparatorCRCR = @"\r\r";
static NSString *const ESEventSeparatorCRLFCRLF = @"\r\n\r\n";
static NSString *const ESEventKeyValuePairSeparator = @"\n";
static NSString *const ESEventDataKey = @"data";
static NSString *const ESEventEventKey = @"event";

@interface EventSource () <NSURLConnectionDelegate, NSURLConnectionDataDelegate> { //<NSURLSessionDelegate, NSURLSessionDataDelegate> {
    BOOL wasClosed;
}

@property (nonatomic, strong) NSURL *eventURL;
@property (nonatomic, strong) NSURLConnection *eventSource;
@property (nonatomic, strong) NSURLSessionDataTask *eventSourceTask;
@property (nonatomic, strong) NSMutableDictionary *listeners;
@property (nonatomic, assign) NSTimeInterval timeoutInterval;
@property (nonatomic, assign) NSTimeInterval retryInterval;
@property (nonatomic, strong) id lastEventID;
@property (nonatomic, strong) dispatch_queue_t queue;
@property (nonatomic) NSInteger retries;
@property (atomic, strong) Event *event;


- (void)open;

@end

@implementation EventSource


+ (instancetype)eventSourceWithURL:(NSURL *)URL timeoutInterval:(NSTimeInterval)timeoutInterval queue:(dispatch_queue_t)queue
{
    return [[EventSource alloc] initWithURL:URL timeoutInterval:timeoutInterval queue:queue];
}


- (instancetype)initWithURL:(NSURL *)URL timeoutInterval:(NSTimeInterval)timeoutInterval queue:(dispatch_queue_t)queue
{
    self = [super init];
    if (self) {
        _listeners = [NSMutableDictionary dictionary];
        _eventURL = URL;
        _timeoutInterval = timeoutInterval;
        _retryInterval = ES_RETRY_INTERVAL;
        _queue = queue;
        _retries = 0;
        
        dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(_retryInterval * NSEC_PER_SEC));
        dispatch_after(popTime, queue, ^(void){
            [self open];
        });
        
        self.event = [Event new];
    }
    return self;
}

- (void)addEventListener:(NSString *)eventName handler:(EventSourceEventHandler)handler
{
    if (self.listeners[eventName] == nil) {
        [self.listeners setObject:[NSMutableArray array] forKey:eventName];
    }
    
    [self.listeners[eventName] addObject:handler];
}

- (void)removeEventListener:(NSString *)eventName handler:(EventSourceEventHandler)handler
{
    if (self.listeners[eventName])
        [self.listeners[eventName] removeObject:handler];
}



- (void)onMessage:(EventSourceEventHandler)handler
{
    [self addEventListener:MessageEvent handler:handler];
}

- (void)onError:(EventSourceEventHandler)handler
{
    [self addEventListener:ErrorEvent handler:handler];
}

- (void)onOpen:(EventSourceEventHandler)handler
{
    [self addEventListener:OpenEvent handler:handler];
}

- (void)open
{
    wasClosed = NO;
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:self.eventURL cachePolicy:NSURLRequestReloadIgnoringCacheData timeoutInterval:self.timeoutInterval];

    [request setHTTPMethod:@"GET"];
    
    self.eventSource = [[NSURLConnection alloc] initWithRequest:request delegate:self startImmediately:YES];
//    self.eventSourceTask = [[NSURLSession sharedSession] dataTaskWithRequest:request];
//    [self.eventSourceTask resume];
    
    
    if (![NSThread isMainThread]) {
        CFRunLoopRun();
    }
}

- (void)close
{
//    NSLog(@"eventSource %@ closed",self.description);
    
    wasClosed = YES;
    [self.eventSource cancel];
//    [self.eventSourceTask cancel];
    self.queue = nil;
}

// ---------------------------------------------------------------------------------------------------------------------


- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response
{
//    NSLog(@"eventSource %@ didReceiveResponse %@",self.description,response.description);
    
    NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *)response;
    if (httpResponse.statusCode == 200) {
        // Opened
        Event *e = [Event new];
        e.readyState = kEventStateOpen;
        
        // TODO: remove this? (open/close/etc)
        NSArray *openHandlers = self.listeners[OpenEvent];
        for (EventSourceEventHandler handler in openHandlers) {
            dispatch_async(self.queue, ^{
                handler(e);
            });
        }
    }
    else
    {
        NSLog(@"Error opening event stream, code %ld",(long)httpResponse.statusCode);
    }
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
{
//    NSLog(@"eventSource %@ didFailWithError %@",self.description,error.description);
    
    Event *e = [Event new];
    e.readyState = kEventStateClosed;
    e.error = error;
    
    NSArray *errorHandlers = self.listeners[ErrorEvent];
    for (EventSourceEventHandler handler in errorHandlers) {
        dispatch_async(self.queue, ^{
            handler(e);
        });
    }
    
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(self.retryInterval * NSEC_PER_SEC));
    dispatch_after(popTime, self.queue, ^(void) {
        if (self.retries < 5) {
//            NSLog(@"connection retries %d",self.retries);
            self.retries++;
            [self open];
        }
        
    });
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
//    NSLog(@"eventSource %@ didReceiveData %@",self.description,data.description);
    
    NSString *eventString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    eventString = [eventString stringByTrimmingCharactersInSet:[NSCharacterSet newlineCharacterSet]];
    NSArray *components = [eventString componentsSeparatedByString:ESEventKeyValuePairSeparator];

    self.event.readyState = kEventStateOpen;
    
    for (NSString *component in components) {
        if (component.length == 0) {
            continue;
        }
        
        NSInteger index = [component rangeOfString:ESKeyValueDelimiter].location;
        if (index == NSNotFound || index == (component.length - 2)) {
            continue;
        }
        
        NSString *key = [component substringToIndex:index];
        NSString *value = [component substringFromIndex:index + ESKeyValueDelimiter.length];
        
        
        if ([key isEqualToString:ESEventEventKey])
        {
            self.event.name = value;
        } else if ([key isEqualToString:ESEventDataKey])
        {
            self.event.data = [value dataUsingEncoding:NSUTF8StringEncoding];
        }
        
        if ((self.event.name) && (self.event.data))
        {
            NSArray *messageHandlers = self.listeners[MessageEvent];
            __block Event *sendEvent = [self.event copy]; // to prevent race conditions where loop continues iterating sending duplicate events to handler callback
            for (EventSourceEventHandler handler in messageHandlers) {
                dispatch_async(self.queue, ^{
                    handler(sendEvent);
                });
            }
            self.event = [Event new];
        }
     }
}


- (void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    if (wasClosed) {
        return;
    }
    
//    NSLog(@"eventSource %@ connectionDidFinishLoading",self.description);
    
    Event *e = [Event new];
    e.readyState = kEventStateClosed;
    e.error = [NSError errorWithDomain:@""
                                  code:e.readyState
                              userInfo:@{ NSLocalizedDescriptionKey: @"Connection with the event source was closed." }];
    
    NSArray *errorHandlers = self.listeners[ErrorEvent];
    for (EventSourceEventHandler handler in errorHandlers) {
        dispatch_async(self.queue, ^{
            handler(e);
        });
    }
    
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(self.retryInterval * NSEC_PER_SEC));
    dispatch_after(popTime, self.queue, ^(void) {
        if (self.retries < 5) {
//            NSLog(@"connectionDidFinishLoading retries %d",self.retries);
            self.retries++;
            [self open];
        }
        
    });

}

-(void)dealloc {
    [self close];
}

@end

// ---------------------------------------------------------------------------------------------------------------------

@implementation Event

- (NSString *)description
{
    NSString *state = nil;
    switch (self.readyState) {
        case kEventStateConnecting:
            state = @"CONNECTING";
            break;
        case kEventStateOpen:
            state = @"OPEN";
            break;
        case kEventStateClosed:
            state = @"CLOSED";
            break;
    }
    
    return [NSString stringWithFormat:@"<%@: readyState: %@; event: %@; data: %@>",
            [self class],
            state,
//            self.id,
            self.name,
            self.data];

}

-(id)copyWithZone:(NSZone *)zone
{
    Event *copy = [[Event allocWithZone:zone] init];
    
    copy.name = self.name;
    copy.data = self.data;
    copy.readyState = self.readyState;
    copy.error = self.error;

    return copy;
}

@end

NSString *const MessageEvent = @"message";
NSString *const ErrorEvent = @"error";
NSString *const OpenEvent = @"open";