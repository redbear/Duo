//
//  SparkSetupConnection.m
//  mobile-sdk-ios
//
//  Created by Ido Kleinman on 11/20/14.
//  Copyright (c) 2014-2015 Spark. All rights reserved.
//

#import "SparkSetupConnection.h"

float const kSparkSetupConnectionOpenTimeout = 3.0f;



@interface SparkSetupConnection() <NSStreamDelegate>
@property (strong, nonatomic) NSInputStream *inputStream;
@property (strong, nonatomic) NSOutputStream *outputStream;
@property (nonatomic) SparkSetupConnectionState state;
@property (nonatomic, strong) NSString *IPaddr;
@property (nonatomic) NSInteger port;
@property (nonatomic, strong) NSMutableString *rcvdDataBuffer;

@property (nonatomic) BOOL outStreamOpened;
@property (nonatomic) BOOL inStreamOpened;
@property (nonatomic, strong) NSTimer *socketOpenTimeoutTimer;


@end

@implementation SparkSetupConnection


-(void)initSocket
{
    // This is the iOS 8+ way to go:
//    NSInputStream *inputStream;
//    NSOutputStream *outputStream;
//    [NSStream getStreamsToHostWithName:self.IPaddr port:self.port inputStream:&inputStream outputStream:&outputStream];
    
    // instead of all this crap:
    CFReadStreamRef readStream;
    CFWriteStreamRef writeStream;
    CFStreamCreatePairWithSocketToHost(NULL, (__bridge CFStringRef)self.IPaddr, (UInt32)self.port, &readStream, &writeStream);
    NSInputStream *inputStream = (__bridge_transfer NSInputStream *)readStream;
    NSOutputStream *outputStream = (__bridge_transfer NSOutputStream *)writeStream;
    // ----

    self.inputStream = inputStream;
    self.outputStream = outputStream;
    
    [self.inputStream setDelegate:self];
    [self.outputStream setDelegate:self];
    
    self.outStreamOpened = NO;
    self.inStreamOpened = NO;
    
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.inputStream scheduleInRunLoop:[NSRunLoop currentRunLoop] forMode:NSDefaultRunLoopMode];
        [self.outputStream scheduleInRunLoop:[NSRunLoop currentRunLoop] forMode:NSDefaultRunLoopMode];
        [self.inputStream open];
        [self.outputStream open];
        
        self.socketOpenTimeoutTimer = [NSTimer scheduledTimerWithTimeInterval:kSparkSetupConnectionOpenTimeout target:self selector:@selector(socketOpenTimeoutHandler:) userInfo:nil repeats:NO];

    });
}


-(instancetype)initWithIPAddress:(NSString *)IPaddr port:(int)port
{
    self = [super init];
    if (self)
    {
        self.IPaddr = IPaddr;
        self.port = port;
        [self initSocket];
        
        return self;
    }
    
    return nil;
}




-(void)socketOpenTimeoutHandler:(id)sender
{
    [self.socketOpenTimeoutTimer invalidate];
    self.state = SparkSetupConnectionOpenTimeout;
    [self.delegate SparkSetupConnection:self didUpdateState:self.state error:nil];
}



-(void)stream:(NSStream *)aStream handleEvent:(NSStreamEvent)eventCode
{
    // handling a bit-wise event code (few events can happen at once)
    while (eventCode != NSStreamEventNone) {
            
        if (eventCode & NSStreamEventOpenCompleted)
        {
            eventCode = eventCode &~ NSStreamEventOpenCompleted;
            
//            NSLog(@"NSStreamEventOpenCompleted: %@",aStream.description);
            if (aStream == self.outputStream)
                self.outStreamOpened = YES;
            
            if (aStream == self.inputStream)
                self.inStreamOpened = YES;
            
            if ((self.outStreamOpened) && (self.inStreamOpened))
            {
                [self.socketOpenTimeoutTimer invalidate];
                self.state = SparkSetupConnectionStateOpened;
                [self.delegate SparkSetupConnection:self didUpdateState:self.state error:nil];
            }
        }
    
        if ((eventCode & NSStreamEventHasSpaceAvailable) || (eventCode & NSStreamEventHasBytesAvailable))
        {
            if (eventCode & NSStreamEventHasSpaceAvailable)
                eventCode = eventCode &~NSStreamEventHasSpaceAvailable;
            
            if (eventCode & NSStreamEventHasBytesAvailable)
                eventCode = eventCode &~NSStreamEventHasBytesAvailable;
            
            if (aStream == self.inputStream) {
                
                uint8_t buffer[1024];
                NSInteger len;
                
                while ([self.inputStream hasBytesAvailable]) {
                    len = [self.inputStream read:buffer maxLength:sizeof(buffer)];
                    if (len > 0) {
                        
                        NSString *rcvdData = [[NSString alloc] initWithBytes:buffer length:len encoding:NSASCIIStringEncoding];
                        [self.rcvdDataBuffer appendString:rcvdData];
//                        NSLog(@"appended server data: %@",rcvdData);
                    }
                }
            }
        }
            
        if (eventCode & NSStreamEventErrorOccurred)
        {
            if (eventCode & NSStreamEventErrorOccurred)
                eventCode = eventCode &~NSStreamEventErrorOccurred;

//            NSLog(@"NSStreamEventErrorOccurred: %@",[aStream.streamError localizedDescription]);
            self.state = SparkSetupConnectionStateError;
            [self.delegate SparkSetupConnection:self didUpdateState:self.state error:aStream.streamError];
        }
            
        if (eventCode & NSStreamEventEndEncountered)
        {
            if (eventCode & NSStreamEventEndEncountered)
                eventCode = eventCode &~NSStreamEventEndEncountered;
            
            if (aStream == self.outputStream)
            {
                self.outStreamOpened = NO;
//                NSLog(@"%@ outputStream closed",self.description);
            }
            
            if (aStream == self.inputStream)
            {
                self.inStreamOpened = NO;
//                NSLog(@"%@ inputStream closed",self.description);
                
                if (self.outStreamOpened) // if input stream has closed - output stream should close too
                    [_outputStream close];

                self.state = SparkSetupConnectionStateClosed;
                [self.delegate SparkSetupConnection:self didUpdateState:self.state error:[aStream streamError]];

                if (self.rcvdDataBuffer)
                {
                    if (self.rcvdDataBuffer.length > 0)
                    {
                        [self.delegate SparkSetupConnection:self didReceiveData:self.rcvdDataBuffer];
                    }
                }


            }

        }
            
        if (eventCode & SparkSetupConnectionStateUnknown)
        {
            if (eventCode & SparkSetupConnectionStateUnknown)
                eventCode = eventCode &~SparkSetupConnectionStateUnknown;

            self.state = SparkSetupConnectionStateUnknown;
            [self.delegate SparkSetupConnection:self didUpdateState:self.state error:aStream.streamError];
        }
    }
    
}



-(void)writeString:(NSString *)string completion:(void(^)(NSError *error))completion;
{
    if (self.state != SparkSetupConnectionStateOpened)
    {
        completion([NSError errorWithDomain:@"SparkSetupConnectionError" code:3000 userInfo:@{NSLocalizedDescriptionKey:@"Socket connection is not open"}]);
        return;
    }
    
    
    NSData *buffer = [string dataUsingEncoding:NSStringEncodingConversionAllowLossy];
    self.rcvdDataBuffer = [@"" mutableCopy]; // getting ready to send command - zeroing response data buffer
    
    
    dispatch_async(dispatch_get_main_queue(), ^{
        if ([self.outputStream hasSpaceAvailable])
        {
            if (!([self.outputStream write:[buffer bytes] maxLength:[buffer length]] == string.length))
            {
                completion([NSError errorWithDomain:@"SparkSetupConnectionError" code:3002 userInfo:@{NSLocalizedDescriptionKey:@"Could not write all data to socket"}]);                return;
            }
        }
        else
        {
            completion([NSError errorWithDomain:@"SparkSetupConnectionError" code:3001 userInfo:@{NSLocalizedDescriptionKey:@"Output socket not ready"}]);
        }
    });
    
    
}



-(void)dealloc
{
    [self close];
}

-(void)close
{
    [self.socketOpenTimeoutTimer invalidate];
    
    if (self.outputStream)
    {
        [self.outputStream removeFromRunLoop:[NSRunLoop currentRunLoop] forMode:NSDefaultRunLoopMode];
        [self.outputStream close];
    }
    
    if (self.inputStream)
    {
        [self.inputStream removeFromRunLoop:[NSRunLoop currentRunLoop] forMode:NSDefaultRunLoopMode];
        [self.inputStream close];
    }
    
    
}


@end
