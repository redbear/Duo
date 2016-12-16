//
//  EventSource
//  Server-Sent Events for iOS and Mac
//
//  Created by Neil on 25/07/2013.
//  Copyright (c) 2013 Neil Cowburn. MIT license.
//  Modified by Ido Kleinman, Particle inc. 2015
//
//  Original codebase:
//  https://github.com/neilco/EventSource

#import <Foundation/Foundation.h>

typedef enum {
    kEventStateConnecting = 0,
    kEventStateOpen = 1,
    kEventStateClosed = 2,
} EventState;

// ---------------------------------------------------------------------------------------------------------------------

/// Describes an Event received from an EventSource
@interface Event : NSObject <NSCopying>

/// The name of the Event
@property (nonatomic, strong) NSString *name;
/// The data received from the EventSource
@property (nonatomic, strong) NSData *data;

/// The current state of the connection to the EventSource
@property (nonatomic, assign) EventState readyState;
/// Provides details of any errors with the connection to the EventSource
@property (nonatomic, strong) NSError *error; // unused

@end

// ---------------------------------------------------------------------------------------------------------------------

typedef void (^EventSourceEventHandler)(Event *event);

// ---------------------------------------------------------------------------------------------------------------------

/// Connect to and receive Server-Sent Events (SSEs).
@interface EventSource : NSObject

/// Returns a new instance of EventSource with the specified URL.
///
/// @param URL The URL of the EventSource.
/// @param timeoutInterval The request timeout interval in seconds. See <tt>NSURLRequest</tt> for more details. Default: 5 minutes.
+ (instancetype)eventSourceWithURL:(NSURL *)URL timeoutInterval:(NSTimeInterval)timeoutInterval queue:(dispatch_queue_t)queue;


/// Creates a new instance of EventSource with the specified URL.
///
/// @param URL The URL of the EventSource.
/// @param timeoutInterval The request timeout interval in seconds. See <tt>NSURLRequest</tt> for more details. Default: 5 minutes.
- (instancetype)initWithURL:(NSURL *)URL timeoutInterval:(NSTimeInterval)timeoutInterval queue:(dispatch_queue_t)queue;



/// Registers an event handler for the Message event.
///
/// @param handler The handler for the Message event.
- (void)onMessage:(EventSourceEventHandler)handler;

/// Registers an event handler for the Error event.
///
/// @param handler The handler for the Error event.
- (void)onError:(EventSourceEventHandler)handler;

/// Registers an event handler for the Open event.
///
/// @param handler The handler for the Open event.
- (void)onOpen:(EventSourceEventHandler)handler;

/// Registers an event handler for a named event.
///
/// @param eventName The name of the event you registered.
/// @param handler The handler for the Message event.
- (void)addEventListener:(NSString *)eventName handler:(EventSourceEventHandler)handler;
- (void)removeEventListener:(NSString *)eventName handler:(EventSourceEventHandler)handler;

/// Closes the connection to the EventSource.
- (void)close;

@end

// ---------------------------------------------------------------------------------------------------------------------

extern NSString *const MessageEvent;
extern NSString *const ErrorEvent;
extern NSString *const OpenEvent;