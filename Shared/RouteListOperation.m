//
//  RouteListOperation.m
//  Buster
//
//  Created by andyshep on 10/30/10.
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

#import "RouteListOperation.h"

@implementation RouteListOperation

@synthesize delegate;

#pragma mark -
#pragma mark Memory Management

- (id)initWithDelegate:(id<RouteListOperationDelegate>)operationDelegate {
	if (self = [super init]) {
		delegate = operationDelegate;
	}
	
	return self;
}

- (void)dealloc {
	[super dealloc];
}

#pragma mark -
#pragma mark fetch data

- (NSString *)buildURL {
	
//	MBTAQueryStringBuilder *_builder = [[[MBTAQueryStringBuilder alloc] 
//										 initWithBaseURL:@"http://webservices.nextbus.com/service/publicXMLFeed"] autorelease];

//	NSString *url = [_builder buildRouteListQuery];
	
	NSString *url = @"http://169.254.95.60:8081/routeList.xml";
	
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

#pragma mark -
#pragma mark consume data

- (NSArray *)consumeData {
	
	// a list of routes will be passed back and stored into the model
	NSMutableArray *routeList = [[[NSMutableArray alloc] init] autorelease];
	
	// first get the route xml from the intertubes
	NSData *routeListData = [self fetchData];
	
	if (routeListData != nil) {
		// then begin parsing the route xml
		CXMLDocument *doc = [[[CXMLDocument alloc] initWithData:routeListData options:0 error:nil] autorelease];
		NSArray *nodes = NULL;
		
		// searching for route nodes
		nodes = [doc nodesForXPath:@"//route" error:nil];
		
		// grab the title of each route and add into the model
		for (CXMLElement *node in nodes) {
			NSMutableDictionary *dict = [[[NSMutableDictionary alloc] init] autorelease];
			// TODO: determine the inbound and outbound titles
			
			[dict setObject:[[node attributeForName:@"title"] stringValue] forKey:@"title"];
			[dict setObject:[[node attributeForName:@"tag"] stringValue] forKey:@"tag"];
			
			[routeList addObject:dict];
			dict = nil;
		}
		
		// write the list to cache for future use
		// [routeList writeToFile:[self dataFilePath] atomically:YES];
	}
	
	// return to the model
	// should represent initial empty model?
	// an array of dictionaries, where each dict is a route entity.
	
	return routeList;
}

- (void)main {
	
	@try {
		NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
		
		NSArray *consumedData = [self consumeData];
		
		if (!self.isCancelled) {
			
			// return the data back to the main thread
			[delegate performSelectorOnMainThread:@selector(updateRouteList:) 
									   withObject:consumedData
									waitUntilDone:YES];
		}
		
		[pool drain];
	}
	@catch (NSException *e) {
		// an NSOperation cannot throw an exception
		NSLog(@"exception: %@", e);
	}
}

@end
