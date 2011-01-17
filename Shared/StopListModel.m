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

@synthesize stops, qualifiedStops, tags, titles, title;

SYNTHESIZE_SINGLETON_FOR_CLASS(StopListModel);

#pragma mark -
#pragma mark Lifecycle

- (id) init {
    self = [super init];
    
	if (self != nil) {
		
		// init an empty set of routeTitles for the model
		self.stops = nil;
		self.tags = nil;
		self.qualifiedStops = nil;
		self.titles = nil;
		self.title = nil;
		
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

- (void)loadStopsForTagIndex:(NSUInteger)index {
	self.stops = [[qualifiedStops objectForKey:[self.tags objectAtIndex:index]] objectForKey:@"stops"];
	self.title = [titles objectAtIndex:index];
}

#pragma mark -
#pragma mark StopListOperationDelegate methods

- (void)updateStopList:(NSArray *)data {
	
	// NSString *stopId = [data objectAtIndex:0];
	
	// FIXME: this isn't the list you really wanna track
	NSDictionary *_stops = [data objectAtIndex:1];
	NSDictionary *_directions = [data objectAtIndex:2];
	
//	NSLog(@"_stops: %@", _stops);
	
//	for (MBTARouteDirection *direction in _directions) {
//		
//		NSLog(@"direction.title: %@", direction.title);
//		
//		for (NSString *stop in direction.stops) {
//			NSLog(@"stop: %@", stop);
//		}
//		
//	}
	
//	// turning off caching
//	// [stopListCache setObject:list forKey:stopId];
//	self.stops = _stops;
//	
//	// NSLog(@"stops: %@", _stops);
//	
//	NSMutableDictionary *directions = [[NSMutableDictionary alloc] initWithCapacity:4];
//	
//	// these both should probably be a dictionary
//	NSMutableArray *_tags = [NSMutableArray arrayWithCapacity:4];
//	NSMutableArray *_titles = [NSMutableArray arrayWithCapacity:4];
	
	// FIXME: T isn't using dirTag anymore
	// not all stops have a stopId
	// tag seems to be the one to use
	
	
	// old stuff

//	self.qualifiedStops = [NSDictionary dictionaryWithDictionary:directions];
//	[directions release];
//	
//	self.tags = _tags;
//	self.titles = _titles;
//	self.stops = [[qualifiedStops objectForKey:[self.tags objectAtIndex:0]] objectForKey:@"stops"];
//	self.title = [titles objectAtIndex:0];
}

@end
