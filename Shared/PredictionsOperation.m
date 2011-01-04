//
//  StopOperation.m
//  Buster
//
//  Created by andyshep on 1/3/11.
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

#import "PredictionsOperation.h"


@implementation PredictionsOperation

@synthesize delegate;
@synthesize route, stop, direction;

#pragma mark -
#pragma mark Memory Management

- (id)initWithDelegate:(id<PredictionsOperationDelegate>)operationDelegate 
				 route:(NSString *)routeId 
				  stop:(NSString *)stopTag {
	
	if (self = [super init]) {
		delegate = operationDelegate;
		
		self.route = routeId;
		self.stop = stopTag;
	}
	
	return self;
}

- (void)dealloc {
	[super dealloc];
}

#pragma mark -
#pragma mark Predictions Processing

- (NSData *)fetchData {
	
//	NSURL *url;
//	
////	MBTAQueryStringBuilder *_builder = [[[MBTAQueryStringBuilder alloc] 
////										 initWithBaseURL:@"http://webservices.nextbus.com/service/publicXMLFeed"] autorelease];
////	
////	NSLog(@"%@", [_builder buildPredictionsQueryForRoute:self.route 
////										   withDirection:self.direction 
////												  atStop:self.stop]);
////	
////	url = [[[NSURL alloc] initWithString:[_builder buildPredictionsQueryForRoute:self.route 
////																   withDirection:self.direction 
////																		  atStop:self.stop]] autorelease];
	
	NSString *addy = @"http://127.0.0.1:8081/predictions_route57_stop918.xml";

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
	NSMutableArray *predictions = [[[NSMutableArray alloc] init] autorelease];
	
	// first get the route xml from the intertubes
	NSData *predictionsData = [self fetchData];
	
	if (predictionsData != nil) {
		
		// parse out the xml data
		CXMLDocument *doc = [[[CXMLDocument alloc] initWithData:predictionsData options:0 error:nil] autorelease];
		NSArray *nodes = NULL;
		
		// searching for prediction nodes
		nodes = [doc nodesForXPath:@"//prediction" error:nil];
		
		for (CXMLElement *node in nodes) {
			
			NSMutableDictionary *dict = [[[NSMutableDictionary alloc] init] autorelease];
			
			// FIXME: this is leaky			
			[dict setObject:[[node attributeForName:@"minutes"] stringValue] forKey:@"minutes"];
			[dict setObject:[[node attributeForName:@"seconds"] stringValue] forKey:@"seconds"];
			[dict setObject:[[node attributeForName:@"vehicle"] stringValue] forKey:@"vehicle"];
			[dict setObject:[[node attributeForName:@"dirTag"] stringValue] forKey:@"dirTag"];
			[dict setObject:[[node attributeForName:@"epochTime"] stringValue] forKey:@"time"];
			
			[predictions addObject:dict];
		}
	}
	
	return predictions;
}

- (void)main {
	
	@try {
		NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
		
		NSArray *consumedData = [self consumeData];
		
		if (!self.isCancelled) {
			[delegate performSelectorOnMainThread:@selector(updatePredictions:) 
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
