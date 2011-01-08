//
//  StopListOperation.m
//  Buster
//
//  Created by andyshep on 12/20/10.
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

#import "StopListOperation.h"


@implementation StopListOperation

@synthesize delegate, stopId;

#pragma mark -
#pragma mark Memory Management

- (id)initWithDelegate:(id<StopListOperationDelegate>)operationDelegate andStopId:(NSString *)stop {
	if (self = [super init]) {
		delegate = operationDelegate;
		self.stopId = stop;
	}
	
	return self;
}

- (void)dealloc {
	[super dealloc];
}

#pragma mark -
#pragma mark Route Stop Processing

- (NSString *)buildURL {
	
//	MBTAQueryStringBuilder *_builder = [[[MBTAQueryStringBuilder alloc] 
//										 initWithBaseURL:@"http://webservices.nextbus.com/service/publicXMLFeed"] autorelease];
//
//	NSString *url = [_builder buildRouteConfigQuery:self.stopId];
	
	NSString *url = @"http://169.254.95.60:8081/routeConfig_r";
	
	url = [url stringByAppendingString:self.stopId];
	url = [url stringByAppendingString:@".xml"];
	
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

- (NSArray *)consumeData {
	
	// a list of route stops will be passed back and stored into the model
	NSMutableArray *stopList = [[[NSMutableArray alloc] init] autorelease];
	
	// first get the route xml from the intertubes
	NSData *stopListData = [self fetchData];
	
	if (stopListData != nil) {
		
		CXMLDocument *doc = [[CXMLDocument alloc] initWithData:stopListData options:0 error:nil];
		NSArray *nodes;
		
		// searching for stop nodes
		nodes = [doc nodesForXPath:@"//route/stop" error:nil];
		
		for (CXMLElement *node in nodes) {
			// for each stop xml node create a dict
			// with the attributes we care about
			// and store it away
			NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
			
			// FIXME: this is leaky
			[dict setObject:[[node attributeForName:@"title"] stringValue] forKey:@"title"];
			[dict setObject:[[node attributeForName:@"tag"] stringValue] forKey:@"tag"];
			[dict setObject:[[node attributeForName:@"lon"] stringValue] forKey:@"longitude"];
			[dict setObject:[[node attributeForName:@"lat"] stringValue] forKey:@"latitude"];
			[dict setObject:(NSString *)self.stopId forKey:@"routeNumber"];
			
			// FIXME: not tracking this yet
			[dict setObject:@"1_010003v0_1" forKey:@"dirTag"];
			
			[stopList addObject:dict];
			
			[dict release];
		}
		
		nodes = nil;
		[doc release];
		
		// TODO: pull off direction metadata
	}
	
	NSArray *consumedData = [NSArray arrayWithObjects:self.stopId, [NSArray arrayWithArray:stopList], nil];
	
	return consumedData;
}

- (void)main {
	
	@try {
		NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
		
		NSArray *consumedData = [self consumeData];
		
		if (!self.isCancelled) {
			[delegate performSelectorOnMainThread:@selector(updateStopList:) 
									   withObject:consumedData
									waitUntilDone:YES];
		}
		
		[pool drain];
	}
	@catch (NSException *e) {
		// do not throw exception just bag it and tag it
		NSLog(@"exception: %@", e);
	}
}

@end
