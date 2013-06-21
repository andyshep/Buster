//
//  BSStop.m
//  Buster
//
//  Created by andyshep on 1/16/11.
//
//  Copyright (c) 2010-2011 Andrew Shepard
// 
//  Permission is hereby granted, free of charge, to any person obtaining a copy
//  of this software and associated documentation files (the "Software"), to deal
//  in the Software without restriction, including without limitation the rights
//  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//  copies of the Software, and to permit persons to whom the Software is
//  furnished to do so, subject to the following conditions:
// 
//  The above copyright notice and this permission notice shall be included in
//  all copies or substantial portions of the Software.
// 
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
//  THE SOFTWARE.
//

#import "BSStop.h"


@implementation BSStop

@synthesize title = _title, tag = _tag, directionTag = _directionTag;
@synthesize routeNumber = _routeNumber, stopId = _stopId;
@synthesize latitude = _latitude, longitude = _longitude;

#pragma mark -
#pragma mark Lifecycle

- (id) init {
	if ((self = [super init])) {
		// init
    }
	
    return self;
}


#pragma mark -
#pragma NSCoding

// http://www.cocoadev.com/index.pl?NSCoder
// 
- (id)initWithCoder:(NSCoder *)coder {
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
