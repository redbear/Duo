//
//  WiFStatus.h
//  DuoApp
//
//  Created by Sunny Cheung on 14/9/2016.
//  Copyright © 2016 RedBear. All rights reserved.
//

#import <Foundation/Foundation.h>

#import <ifaddrs.h>
#import <net/if.h>
#import <SystemConfiguration/CaptiveNetwork.h>


@interface WiFiStatus : NSObject
- (BOOL)       isWiFiEnabled;

@end
