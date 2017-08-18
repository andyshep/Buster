//
//  BSStop.m
//  Buster
//
//  Created by Andrew Shepard on 1/16/11.
//  Copyright © 2011-2017 Andrew Shepard. All rights reserved.
//

#import "BSStop.h"

@implementation BSStop

- (instancetype)init {
    if ((self = [super init])) {
        //
    }
    
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)coder {
    if ((self = [super init])) {
        self.title = [coder decodeObjectForKey:@"title"];
        self.tag = [coder decodeObjectForKey:@"tag"];
        self.directionTag = [coder decodeObjectForKey:@"directionTag"];
        self.routeNumber = [coder decodeObjectForKey:@"routeNumber"];
        self.stopId = [coder decodeObjectForKey:@"stopId"];
    }
    
    return self;
}

- (void)encodeWithCoder:(NSCoder *)coder {
    [coder encodeObject:self.title forKey:@"title"];
    [coder encodeObject:self.tag forKey:@"tag"];
    [coder encodeObject:self.directionTag forKey:@"directionTag"];
    [coder encodeObject:self.routeNumber forKey:@"routeNumber"];
    [coder encodeObject:self.stopId forKey:@"stopId"];
}

@end
