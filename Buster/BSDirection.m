//
//  BSDirection.m
//  Buster
//
//  Created by Andrew Shepard on 1/16/11.
//  Copyright © 2011-2017 Andrew Shepard. All rights reserved.
//

#import "BSDirection.h"

@implementation BSDirection

- (instancetype)init {
    if ((self = [super init])) {
        //
    }
    
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)coder {
    if (self = [super init]) {
        self.tag = [coder decodeObjectForKey:@"tag"];
        self.name = [coder decodeObjectForKey:@"name"];
        self.title = [coder decodeObjectForKey:@"title"];
        self.stops = [coder decodeObjectForKey:@"stops"];
    }
    
    return self;
}

- (void)encodeWithCoder:(NSCoder *)coder {
    [coder encodeObject:self.tag forKey:@"tag"];
    [coder encodeObject:self.name forKey:@"name"];
    [coder encodeObject:self.title forKey:@"title"];
    [coder encodeObject:self.stops forKey:@"stops"];
}

@end
