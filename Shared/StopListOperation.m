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

@synthesize stopId;

#pragma mark -
#pragma mark Route Stop Processing

- (void)consumeData {
	
    [super consumeData];
    
	// a list of route stops will be passed back and stored into the model
	NSMutableDictionary *stopsList = [NSMutableDictionary dictionaryWithCapacity:20];
	NSMutableArray *directionsList = [NSMutableArray arrayWithCapacity:20];
	
	if (consumedData != nil) {
		
		CXMLDocument *doc = [[CXMLDocument alloc] initWithData:consumedData options:0 error:nil];
		NSArray *nodes;
		
		// first grab the stops
		nodes = [doc nodesForXPath:@"//route/stop" error:nil];
		
		for (CXMLElement *node in nodes) {
			// for each stop xml node create a dict
			// with the attributes we care about
			// and store it away
			
			MBTAStop *stop = [[MBTAStop alloc] init];
			stop.title = [[node attributeForName:@"title"] stringValue];
			stop.tag = [[node attributeForName:@"tag"] stringValue];
			stop.latitude = [[node attributeForName:@"lat"] stringValue];
			stop.longitude = [[node attributeForName:@"lon"] stringValue];
			
			[stopsList setObject:stop forKey:stop.tag];
			[stop release];
		}
		
		// next grab the route and direction data
		nodes = [doc nodesForXPath:@"//route/direction" error:nil];
		
		// NSLog(@"found %d directions", [nodes count]);
		
		int index = 1;
		
		for (CXMLElement *node in nodes) {
			
			MBTARouteDirection *direction = [[MBTARouteDirection alloc] init];
			direction.title = [[node attributeForName:@"title"] stringValue];
			direction.tag = [[node attributeForName:@"tag"] stringValue];
			direction.name = [[node attributeForName:@"name"] stringValue];
			
			NSString *xpath = [NSString stringWithFormat:@"//direction[%d]/stop", index];
			
			NSArray *stopNodes = [node nodesForXPath:xpath error:nil];
			NSMutableArray *stops = [NSMutableArray arrayWithCapacity:10];
			
			for (CXMLElement *stop in stopNodes) {
				[stops addObject:[stopsList objectForKey:[[stop attributeForName:@"tag"] stringValue]]];
			}
			
			index += 1;
			direction.stops = stops;
			[directionsList addObject:direction];
			
			[direction release];
			stops = nil;
		}
		
		nodes = nil;
		stopsList = nil;
		[doc release];
	}
	
	NSArray *stopListMeta = [NSArray arrayWithObjects:self.stopId, 
							[NSArray arrayWithArray:directionsList], 
							nil];
	
	consumedData = stopListMeta;
}

@end
