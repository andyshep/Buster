//
//  BSRoute.m
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

#import "BSRoute.h"

@implementation BSRoute

@synthesize title = _title;
@synthesize tag = _tag;
@synthesize endpoints = _endpoints;
@synthesize stops = _stops;

#pragma mark -
#pragma mark Lifecycle

- (id) init {
	if ((self = [super init])) {
		// init
    }
	
    return self;
}

- (void) dealloc {
    [_title release];
    [_tag release];
    [_endpoints release];
    [_stops release];
    [super dealloc];
}

#pragma mark -
#pragma NSCoding

// http://www.cocoadev.com/index.pl?NSCoder
// 
- (id)initWithCoder:(NSCoder *)coder {
    if ((self = [super init])) {
        self.title = [coder decodeObjectForKey:@"title"];
        self.tag = [coder decodeObjectForKey:@"tag"];
        self.stops = [coder decodeObjectForKey:@"stops"];
    }
    
    return self;
}
	 
- (void)encodeWithCoder:(NSCoder *)coder {
 
	[coder encodeObject:self.title forKey:@"title"];
	[coder encodeObject:self.tag forKey:@"tag"];
	[coder encodeObject:self.stops forKey:@"stops"];
}

@end
