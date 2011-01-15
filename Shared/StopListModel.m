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

@synthesize stops, qualifiedStops, tags;

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
}

#pragma mark -
#pragma mark StopListOperationDelegate methods

- (void)updateStopList:(NSArray *)data {
	
	// NSString *stopId = [data objectAtIndex:0];
	
	// FIXME: this isn't the list you really wanna track
	NSArray *_stops = [data objectAtIndex:1];
	
	// turning off caching
	// [stopListCache setObject:list forKey:stopId];
	// self.stops = list;
	
	NSMutableDictionary *directions = [[NSMutableDictionary alloc] initWithCapacity:4];
	
	// this should probably be a dictionary
	NSMutableArray *_tags = [NSMutableArray arrayWithCapacity:4];
	
	for (NSDictionary *stop in _stops) {
		
		if ([directions objectForKey:[stop valueForKey:@"dirTag"]] == nil) {
			
			NSArray *currentStops = [NSArray arrayWithObject:stop];
			
			[directions setObject:[NSDictionary dictionaryWithObjectsAndKeys:currentStops, @"stops", nil]
						   forKey:[stop valueForKey:@"dirTag"]];
			
			currentStops = nil;
		} else {
			NSArray *existingStops = [[directions objectForKey:[stop valueForKey:@"dirTag"]] objectForKey:@"stops"];
			NSMutableArray *newStops = [NSMutableArray arrayWithArray:existingStops];
			
			[newStops addObject:stop];
			
			NSArray *currentStops = [NSArray arrayWithArray:newStops];
			[directions setObject:[NSDictionary dictionaryWithObjectsAndKeys:currentStops, @"stops", nil]
						   forKey:[stop valueForKey:@"dirTag"]];
			
			newStops = nil;
			existingStops = nil;
			currentStops = nil;
		}
	}
	
	// now have the an inbound/outbound direction pair
	// attached to a list of stops
	
	// go thru the metadata and determine the title of the route.
	NSArray *metadata = [data objectAtIndex:2];
	for (NSDictionary *data in metadata) {
		
		NSString *_tag = [data valueForKey:@"tag"];
		NSString *_name = [data valueForKey:@"name"];
		NSString *_title = [data valueForKey:@"title"];
		
		// TODO: implement this?
		// NSString *_useForUI = [data valueForKey:@"useForUI"];
		
		if ([directions objectForKey:_tag] != nil) {
			NSArray *existingStops = [[directions objectForKey:_tag] objectForKey:@"stops"];
			
			[directions setObject:[NSDictionary dictionaryWithObjectsAndKeys:existingStops, @"stops", _tag, @"tag", _name, @"name", _title, @"title", nil]
						   forKey:_tag];
			
			[_tags addObject:_tag];
		}
	}
	
	NSLog(@"found %d directions", [directions count]);
	// NSLog(@"directions: %@", directions);
	NSLog(@"tags: %@", _tags);
	
//	for (NSDictionary *data in metadata) {
//
//		NSString *_useForUI = [data valueForKey:@"useForUI"];
//		NSString *_tag = [data valueForKey:@"tag"];
//		
//		if ([_useForUI compare:@"true"]) {
//			NSLog(@"should be using tag %@ for UI display", _tag);
//		}
//	}

	self.qualifiedStops = [NSDictionary dictionaryWithDictionary:directions];
	[directions release];
	
	self.tags = _tags;
	self.stops = [[qualifiedStops objectForKey:[self.tags objectAtIndex:0]] objectForKey:@"stops"];
}

@end
