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

@synthesize stops, directions, tags, titles, title;

#pragma mark -
#pragma mark Lifecycle

- (id) init {
	if ((self = [super init])) {
		
		// init an empty set of routeTitles for the model
		self.stops = nil;
		self.tags = nil;
		self.directions = nil;
		self.titles = nil;
		self.title = nil;
		
		// create our operation queue
		opQueue_ = [[NSOperationQueue alloc] init];
		
		stopListCache = [[NSMutableDictionary alloc] init];
    }
	
    return self;
}

- (void) dealloc {
    [opQueue_ release];
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

#pragma mark -
#pragma mark Operation Observing

// we use this method to cleanup after operations complete

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
    // only observing keyPath "isFinished".  cleanup stop list op
    // NSLog(@"StopListOperation isFinished");
    [stopListOp_ removeObserver:self forKeyPath:@"isFinished"];
    [stopListOp_ release];
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
        
    #ifdef USE_STUB_SERVICE
		stopListOp_ = [[StopListOperation alloc] initWithURLString:@"http://localhost:8081/routeConfig_r57.xml" delegate:self];
    #else    
        MBTAQueryStringBuilder *_builder = [MBTAQueryStringBuilder sharedMBTAQueryStringBuilder];     
        stopListOp_ = [[StopListOperation alloc] initWithURLString:[_builder buildRouteConfigQuery:stop] delegate:self];
    #endif
        stopListOp_.stopId = stop;
        [stopListOp_ addObserver:self forKeyPath:@"isFinished" options:NSKeyValueObservingOptionNew context:NULL];
		[opQueue_ addOperation:stopListOp_];
	}
}

- (void)unloadStopList {
	self.stops = nil;
}

- (void)loadStopsForTagIndex:(NSUInteger)index {
	
	MBTARouteDirection *_direction = [self.directions objectForKey:[self.tags objectAtIndex:index]];
	self.stops = _direction.stops;
	self.title = [self.titles objectAtIndex:index];
}

#pragma mark -
#pragma mark BSNetworkOperationDelegate methods

- (void)didConsumeData:(id)consumedData {
    
    NSArray *stopListMeta = (NSArray *)consumedData;
	NSArray *_directions = [stopListMeta objectAtIndex:1];
	
	NSMutableDictionary *_qualifiedDirections = [NSMutableDictionary dictionaryWithCapacity:3];
	NSMutableArray *_tags = [NSMutableArray arrayWithCapacity:3];
	NSMutableArray *_titles = [NSMutableArray arrayWithCapacity:3];
	
	for (MBTARouteDirection *direction in _directions) {
		
		[_qualifiedDirections setObject:direction forKey:direction.tag];
		
		[_tags addObject:direction.tag];
		[_titles addObject:direction.title];
	}
	
	self.directions = [NSDictionary dictionaryWithDictionary:_qualifiedDirections];
	self.tags = [NSArray arrayWithArray:_tags];
	self.titles = [NSArray arrayWithArray:_titles];
	self.title = [self.titles objectAtIndex:0];
	
	MBTARouteDirection *_direction = [self.directions objectForKey:[self.tags objectAtIndex:0]];
	self.stops = _direction.stops;
}

@end
