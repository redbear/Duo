//
//  WiFStatus.m
//  DuoApp
//
//  Created by Sunny Cheung on 14/9/2016.
//  Copyright © 2016 RedBear. All rights reserved.
//

#import "WiFiStatus.h"

@implementation WiFiStatus


- (BOOL) isWiFiEnabled {
    
    NSCountedSet * cset = [NSCountedSet new];
    
    struct ifaddrs *interfaces;
    
    if( ! getifaddrs(&interfaces) ) {
        for( struct ifaddrs *interface = interfaces; interface; interface = interface->ifa_next) {
            if ( (interface->ifa_flags & IFF_UP) == IFF_UP ) {
                [cset addObject:[NSString stringWithUTF8String:interface->ifa_name]];
            }
        }
    }
    
    return [cset countForObject:@"awdl0"] > 1 ? YES : NO;
}

@end
