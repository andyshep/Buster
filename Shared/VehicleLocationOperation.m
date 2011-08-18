//
//  VehicleLocationOperation.m
//  Buster
//
//  Created by andyshep on 11/14/10.
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

#import "VehicleLocationOperation.h"


@implementation VehicleLocationOperation

@synthesize vehicleId, routeNumber, epochTime;

#pragma mark -
#pragma mark Vehicle Locations Processing

- (NSString *)buildURL {
	
	MBTAQueryStringBuilder *_builder = [[[MBTAQueryStringBuilder alloc] 
										 initWithBaseURL:@"http://webservices.nextbus.com/service/publicXMLFeed"] autorelease];
	
	// TODO: epochTime other than zero does not work
	NSString *url = [_builder buildLocationsQueryForRoute:self.routeNumber 
											withEpochTime:@"0"];
	
	return url;
}

- (NSDictionary *)consumeData {
	
	NSMutableDictionary *vehicleLocation = [NSMutableDictionary dictionaryWithCapacity:3];
	
	// first get the route xml from the intertubes
	NSData *locationsData = nil;
	
	if (locationsData != nil) {
		
		// parse out the xml data
		CXMLDocument *doc = [[CXMLDocument alloc] initWithData:locationsData options:0 error:nil];
		NSArray *nodes;
		
		// searching for vehicle nodes matching our id
		
		// build an XPath including the vehicle Id
		NSString *vehicleXPath = [NSString stringWithString:@"//vehicle[@id='"];
		
		vehicleXPath = [vehicleXPath stringByAppendingString:self.vehicleId];
		
		vehicleXPath = [vehicleXPath stringByAppendingString:@"']"];
		
		nodes = [doc nodesForXPath:vehicleXPath error:nil];
		
		for (CXMLElement *node in nodes) {
			
			NSString *_vehicleId = [NSString stringWithString:[[node attributeForName:@"id"] stringValue]];
			NSString *_latitude = [NSString stringWithString:[[node attributeForName:@"lat"] stringValue]];
			NSString *_longitude = [NSString stringWithString:[[node attributeForName:@"lon"] stringValue]];
			
			NSLog(@"found vehicle %@ at %@, %@", _vehicleId, _latitude, _longitude);
			
			[vehicleLocation setObject:_longitude forKey:@"longitude"];
			[vehicleLocation setObject:_latitude forKey:@"latitude"];
			
//			NSMutableDictionary *dict = [[[NSMutableDictionary alloc] init] autorelease];
//			
//			NSString *_vehicleId = [NSString stringWithString:[[node attributeForName:@"id"] stringValue]];
//			
//			// FIXME: this is leaky			
//			[dict setObject:[[node attributeForName:@"minutes"] stringValue] forKey:@"minutes"];
//			[dict setObject:[[node attributeForName:@"seconds"] stringValue] forKey:@"seconds"];
//			[dict setObject:[[node attributeForName:@"vehicle"] stringValue] forKey:@"vehicle"];
//			[dict setObject:[[node attributeForName:@"dirTag"] stringValue] forKey:@"dirTag"];
//			
//			[predictions addObject:dict];
		}
		
		[doc release];
		nodes = nil;
	}
	
	return vehicleLocation;
}

- (void)performOperationTasks {
    [dataRequest fetchData];
    NSData *data = [dataRequest data];
    SMXMLDocument *xml = [SMXMLDocument documentWithData:data error:NULL];
    NSMutableArray *routeList = [NSMutableArray arrayWithCapacity:20];
    
    for (SMXMLElement *routeElement in [xml.root childrenNamed:@"route"]) {
        
        //        MBTARoute *route = [[MBTARoute alloc] init];
        //        
        //        route.title = [routeElement attributeNamed:@"title"];
        //        route.tag = [routeElement attributeNamed:@"tag"];
        //        
        //        [routeList addObject:route];
        //        [route release];
    }
    
    if (!self.isCancelled) {
        
        // return the data back to the main thread
        [delegate performSelectorOnMainThread:@selector(didConsumeRouteList:) 
                                   withObject:routeList
                                waitUntilDone:YES];
    }
}

@end
