//
//  MBTAQueryStringBuilder.m
//  Buster
//
//  Created by andyshep on 9/19/10.
//
//  Copyright (c) 2010 Andrew Shepard
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

#import "MBTAQueryStringBuilder.h"

static NSString *MBTABaseQueryURL = @"http://webservices.nextbus.com/service/publicXMLFeed";

@implementation MBTAQueryStringBuilder

+ (MBTAQueryStringBuilder *)sharedInstance {
    static MBTAQueryStringBuilder *_shared = nil;
    static dispatch_once_t pred;
    dispatch_once(&pred, ^{
        _shared = [[MBTAQueryStringBuilder alloc] init];
    });
    
    return _shared;
}

- (id)init {
	if ((self = [super init])) {
		self.baseURL = MBTABaseQueryURL;
	}
	
	return self;
}

#pragma mark - Query Builders
- (NSString *)buildRouteListQuery {
	return [_baseURL stringByAppendingString:@"?command=routeList&a=mbta"];
}

- (NSString *)buildRouteConfigQuery:(NSString *)route {
	return [[_baseURL stringByAppendingString:@"?command=routeConfig&a=mbta&r="] 
			stringByAppendingString:route];
}

- (NSString *)buildPredictionsQueryForRoute:(NSString *)route withDirection:(NSString *)direction atStop:(NSString *)stop {
	NSString *predictionsURL = [[_baseURL stringByAppendingString:@"?command=predictions&a=mbta&r="] 
								stringByAppendingString:route];
	//	
	//	predictionsURL = [[predictionsURL stringByAppendingString:@"&d="] 
	//					  stringByAppendingString:(NSString *)direction];
	
	predictionsURL = [[predictionsURL stringByAppendingString:@"&s="]
					  stringByAppendingString:stop];
	
	return predictionsURL;
}

- (NSString *)buildLocationsQueryForRoute:(NSString *)route withEpochTime:(NSString *)time {
	// http://webservices.nextbus.com/service/publicXMLFeed?command=vehicleLocations&a=mbta&r=57&t=1289479052149
	
	NSString *locationsURL = [[_baseURL stringByAppendingString:@"?command=vehicleLocations&a=mbta&r="] 
							  stringByAppendingString:route];
	locationsURL = [[locationsURL stringByAppendingString:@"&t="]
					stringByAppendingString:time];
	
	return locationsURL;
	
}

@end
