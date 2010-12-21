//
//  StopListOperation.m
//  Buster
//
//  Created by Andrew Shepard on 12/20/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "StopListOperation.h"


@implementation StopListOperation

@synthesize delegate, routeTitle;

#pragma mark -
#pragma mark Memory Management

- (id)initWithDelegate:(id<StopListOperationDelegate>)operationDelegate andTitle:(NSString *)title {
	if (self = [super init]) {
		delegate = operationDelegate;
		self.routeTitle = title;
	}
	
	return self;
}

- (void)dealloc {
	[super dealloc];
}

#pragma mark -
#pragma mark Route Stop Processing

- (NSData *)fetchData {
	
//	MBTAQueryStringBuilder *_builder = [[[MBTAQueryStringBuilder alloc] 
//										 initWithBaseURL:@"http://webservices.nextbus.com/service/publicXMLFeed"] autorelease];
//	
//	NSLog(@"%@", [_builder buildRouteConfigQuery:self.routeTitle]);
	
	// create a url and request
	
	NSString *addy = @"http://localhost:8081/routeConfig_r";
	
	addy = [addy stringByAppendingString:self.routeTitle];
	addy = [addy stringByAppendingString:@".xml"];
	
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
		
		CXMLDocument *doc = [[[CXMLDocument alloc] initWithData:stopListData options:0 error:nil] autorelease];
		NSArray *nodes;
		
		// searching for stop nodes
		nodes = [doc nodesForXPath:@"//route/stop" error:nil];
		
		for (CXMLElement *node in nodes) {
			// for each stop xml node create a dict
			// with the attributes we care about
			// and store it away
			NSMutableDictionary *dict = [[[NSMutableDictionary alloc] init] autorelease];
			
			// FIXME: this is leaky
			[dict setObject:[[node attributeForName:@"title"] stringValue] forKey:@"title"];
			[dict setObject:[[node attributeForName:@"tag"] stringValue] forKey:@"tag"];
			[dict setObject:[[node attributeForName:@"lon"] stringValue] forKey:@"longitude"];
			[dict setObject:[[node attributeForName:@"lat"] stringValue] forKey:@"latitude"];
			[dict setObject:(NSString *)self.routeTitle forKey:@"routeNumber"];
			
			// FIXME: not tracking this yet
			[dict setObject:@"1_010003v0_1" forKey:@"dirTag"];
			
			[stopList addObject:dict];
		}
		
		nodes = nil;
		
		// TODO: pull off direction metadata
	}
	
	return stopList;
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
