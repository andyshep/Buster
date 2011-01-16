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

@synthesize delegate, vehicleId, routeNumber, epochTime;

#pragma mark -
#pragma mark Memory Management

- (id)initWithDelegate:(id<VehicleLocationOperationDelegate>)operationDelegate 
		  andVehicleId:(NSString *)vehicle
		andRouteNumber:(NSString *)route
		   atEpochTime:(NSString *)time {
	
	if (self = [super init]) {
		delegate = operationDelegate;
		vehicleId = vehicle;
		epochTime = time;
		routeNumber = route;
	}
	
	return self;
}

- (void)dealloc {
	[super dealloc];
}

#pragma mark -
#pragma mark Vehicle Locations Processing

- (NSString *)buildURL {
	
//	MBTAQueryStringBuilder *_builder = [[[MBTAQueryStringBuilder alloc] 
//										 initWithBaseURL:@"http://webservices.nextbus.com/service/publicXMLFeed"] autorelease];
//	
//	// TODO: epochTime other than zero does not work
//	NSString *url = [_builder buildLocationsQueryForRoute:self.routeNumber 
//											withEpochTime:@"0"];
	
	NSString *url = @"http://127.0.0.1:8081/vehicles.xml";
	
	return url;
}

- (NSData *)fetchData {
	
	NSString *addy = [self buildURL];
	
	NSURL *url = [NSURL URLWithString:addy];
	ASIHTTPRequest *request = [ASIHTTPRequest requestWithURL:url];
	
	// make a sync request
	[request startSynchronous];
	NSError *error = [request error];
	
	if (!error) {
		return [request responseData];
	}
	
	// TODO: handle error
	return nil;
}

- (NSDictionary *)consumeData {
	
	NSMutableDictionary *vehicleLocation = [NSMutableDictionary dictionaryWithCapacity:3];
	
	// first get the route xml from the intertubes
	NSData *locationsData = [self fetchData];
	
	if (locationsData != nil) {
		
		// parse out the xml data
		CXMLDocument *doc = [[CXMLDocument alloc] initWithData:locationsData options:0 error:nil];
		NSArray *nodes;
		
		// searching for vehicle nodes matching our id
		
		// build an XPath including the vehicle Id
		NSString *vehicleXPath = [NSString stringWithString:@"//vehicle[@id='"];
		
//		vehicleXPath = [vehicleXPath stringByAppendingString:self.vehicleId];
		vehicleXPath = [vehicleXPath stringByAppendingString:@"2056"];
		
		vehicleXPath = [vehicleXPath stringByAppendingString:@"']"];
		
//		NSLog(@"vehicleXPath: %@", vehicleXPath);
		
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

- (void)main {
	
	@try {
		NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
		
		NSDictionary *vehicleLocation = [self consumeData];
		
		if (!self.isCancelled) {
			
//			NSLog(@"starting VehicleLocationOperation for vehicle %@", self.vehicleId);
			
			[delegate performSelectorOnMainThread:@selector(updateLocation:) 
									   withObject:vehicleLocation
									waitUntilDone:YES];
		}
		
		[pool drain];
	}
	@catch (NSException *e) {
		// do not throw an exception just bag it and tag it
		NSLog(@"exception: %@", e);
	}
}

@end
