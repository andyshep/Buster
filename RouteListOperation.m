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

- (NSData *)fetchData {
	// create a url and request
	NSURL *url = [NSURL URLWithString:@"http://localhost:8081/full-list.xml"];
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

- (NSDictionary *)consumeData {
	// data to return
	// the diction entry for each letter
	// will be an array of names
	NSMutableDictionary *indices = [[[NSMutableDictionary alloc] init] autorelease];
	
	// first fetch the xml
	NSData *rawData = [self fetchData];
	
	
	if (rawData != nil) {
		CXMLDocument *doc = [[[CXMLDocument alloc] initWithData:rawData 
													   encoding:NSISOLatin1StringEncoding 
														options:0 
														  error:nil] autorelease];
		NSArray *nodes = NULL;
		
		// searching for name element within ListEntry
		nodes = [doc nodesForXPath:@"//ListEntry/name" error:nil];
		
		for (CXMLElement *node in nodes) {
			
			// name element might look like: <name>andyshep</name>
			// pull off the name value, such as andyshep
			NSString *nameValue = [[node childAtIndex:0] stringValue];
			
			NSString *firstLetter = [nameValue substringToIndex:1];
			
			if ([indices objectForKey:firstLetter] != nil) {
				// we have found names beginning with the current firstLetter already
				NSMutableArray *values = [indices objectForKey:firstLetter];
				[values addObject:nameValue];
				[indices setValue:values forKey:firstLetter];
			}
			else {
				// we have not found this firstLetter yet
				NSMutableArray *values = [[[NSMutableArray alloc] init] autorelease];
				[values addObject:nameValue];
				[indices setValue:values forKey:firstLetter];
			}
		}
	}
	
	return indices;
}

- (void)main {
	
	@try {
		NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
		
		NSDictionary *consumedData = [self consumeData];
		
		if (!self.isCancelled) {
			
			// return the data back to the main thread
			[delegate performSelectorOnMainThread:@selector(didConsumeXMLData:) 
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
