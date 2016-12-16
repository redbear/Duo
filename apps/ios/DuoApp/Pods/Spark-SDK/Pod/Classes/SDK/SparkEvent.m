//
//  SparkEvent.m
//  Pods
//
//  Created by Ido on 7/14/15.
//
//

#import "SparkEvent.h"

NS_ASSUME_NONNULL_BEGIN

@implementation SparkEvent

-(instancetype)initWithEventDict:(NSDictionary *)eventDict
{
    if (self = [super init])
    {        
        self.deviceID = eventDict[@"coreid"];
        self.data = eventDict[@"data"];
        self.event = eventDict[@"event"];
        NSString *ttl = eventDict[@"ttl"];
        self.ttl = [ttl integerValue];
        
        NSString *dateString = eventDict[@"published_at"];// "2015-04-18T08:42:22.127Z"
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        [formatter setDateFormat:@"yyyy-MM-dd'T'HH:mm:ss.SSSZ"];
        NSLocale *posix = [[NSLocale alloc] initWithLocaleIdentifier:@"en_US_POSIX"];
        [formatter setLocale:posix];
        self.time = [formatter dateFromString:dateString];
    }
    
    return self;
}

-(NSString *)description
{
    return [NSString stringWithFormat:@"<Event: %@, DeviceID: %@, Data: %@, Time: %@, TTL: %ld>",
            self.event, self.deviceID, self.data, self.time, (long)self.ttl];
}

@end

NS_ASSUME_NONNULL_END
