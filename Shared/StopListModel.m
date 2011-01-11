//
//  StopListModel.m
//  Buster
//
//  Created by andyshep on 12/30/10.
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

#import "StopListModel.h"


@implementation StopListModel

@synthesize stops;

SYNTHESIZE_SINGLETON_FOR_CLASS(StopListModel);

#pragma mark -
#pragma mark Lifecycle

- (id) init {
    self = [super init];
    
	if (self != nil) {
		
		// init an empty set of routeTitles for the model
		self.stops = nil;
		
		// create our operation queue
		opQueue = [[NSOperationQueue alloc] init];
		
		stopListCache = [[NSMutableDictionary alloc] init];
    }
	
    return self;
}

- (void) dealloc
{
    [opQueue release];
	[stopListCache release];
    [super dealloc];
}

#pragma mark -
#pragma mark Model KVC

- (NSUInteger)countOfStops {
	return [stops count];
}

- (id)objectInStopsAtIndex:(NSUInteger)index {
	return [stops objectAtIndex:index];
}

- (void)getStops:(id *)objects range:(NSRange)range {
	[stops getObjects:objects range:range];
}

- (id)stops {
	return stops;
}

#pragma mark -
#pragma mark Route List building

- (void)requestStopList:(NSString *)stop {
	// a controller has requested a route stop list
	
	if ([stopListCache objectForKey:stop] != nil) {
		NSArray *cachedList = [stopListCache objectForKey:stop];
		self.stops = cachedList;
	}
	else {
		StopListOperation *loadingOp = [[StopListOperation alloc] initWithDelegate:self andStopId:stop];
		[opQueue addOperation:loadingOp];
		[loadingOp release];
	}
}

- (void)unloadStopList {
	self.stops = nil;
}

#pragma mark -
#pragma mark StopListOperationDelegate methods

- (void)updateStopList:(NSArray *)data {
	
	NSString *stop = [data objectAtIndex:0];
	NSArray *list = [data objectAtIndex:1];
	
	[stopListCache setObject:list forKey:stop];
	
	self.stops = list;
	
	NSMutableDictionary *directions = [[NSMutableDictionary alloc] initWithCapacity:5];
	
	for (NSDictionary *stop in stops) {
		
		if ([directions objectForKey:[stop valueForKey:@"dirTag"]] != nil) {
			
		}
		else {
			[directions setObject:[stop valueForKey:@"dirTag"] forKey:[stop valueForKey:@"dirTag"]];
		}

		
		//NSLog(@"stop dirTag: %@", [stop valueForKey:@"dirTag"]);
	}
	
	NSLog(@"directions: %@", directions);
	NSLog(@"%@", [data objectAtIndex:2]);
}

@end
