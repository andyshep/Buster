//
//  BSRoute.m
//  Buster
//
//  Created by Andrew Shepard on 1/16/11.
//  Copyright © 2011-2017 Andrew Shepard. All rights reserved.
//

#import "BSRoute.h"

@implementation BSRoute

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
        self.stops = [coder decodeObjectForKey:@"stops"];
        self.endpoints = [coder decodeObjectForKey:@"endpoints"];
    }
    
    return self;
}
     
- (void)encodeWithCoder:(NSCoder *)coder {
    [coder encodeObject:self.title forKey:@"title"];
    [coder encodeObject:self.tag forKey:@"tag"];
    [coder encodeObject:self.stops forKey:@"stops"];
    [coder encodeObject:self.endpoints forKey:@"endpoints"];
}

@end
