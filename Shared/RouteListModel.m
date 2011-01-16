//
//  RouteListModel.m
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

#import "RouteListModel.h"


@implementation RouteListModel

@synthesize routes;

SYNTHESIZE_SINGLETON_FOR_CLASS(RouteListModel);

#pragma mark -
#pragma mark Lifecycle

- (id) init {
    self = [super init];
    
	if (self != nil) {
		
		// init an empty set of routeTitles for the model
		self.routes = nil;
		
		// create our operation queue
		opQueue = [[NSOperationQueue alloc] init];
		
		routeListCache = [[NSMutableArray alloc] initWithCapacity:5];
    }
	
    return self;
}

- (void) dealloc
{
    [opQueue release];
	[routeListCache release];
    [super dealloc];
}

#pragma mark -
#pragma mark Model KVC

- (NSUInteger)countOfRoutes {
	return [routes count];
}

- (id)objectInRoutesAtIndex:(NSUInteger)index {
	return [routes objectAtIndex:index];
}

- (void)getRoutes:(id *)objects range:(NSRange)range {
	[routes getObjects:objects range:range];
}

- (id)routes {
	return routes;
}

#pragma mark -
#pragma mark Route List building

- (void) requestRouteList {
	// a controller has requested a route list
	// controller is observing routeList property
	// make sure the route list is available if someone wants it
	
	// TODO: should be checking a cache here
	
	if ([routeListCache count] > 0) {
		self.routes = [routeListCache objectAtIndex:0];
	}
	else {
		RouteListOperation *loadingOp = [[RouteListOperation alloc] initWithDelegate:self];
		[opQueue addOperation:loadingOp];
		[loadingOp release];
	}
}

#pragma mark -
#pragma mark RouteListOperationDelegate methods

- (void)updateRouteList:(NSArray *)data {
	
	self.routes = data;
	[routeListCache addObject:data];
}

@end
