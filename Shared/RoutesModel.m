//
//  RoutesModel.m
//  Buster
//
//  Created by andyshep on 12/18/10.
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

#import "RoutesModel.h"


@implementation RoutesModel

@synthesize routeList, stopList;

SYNTHESIZE_SINGLETON_FOR_CLASS(RoutesModel);

#pragma mark -
#pragma mark Lifecycle

- (id) init {
    self = [super init];
    
	if (self != nil) {
		
		NSLog(@"RoutesModel init'd!");
		
		// init an empty set of routeTitles for the model
		self.routeList = nil;
		self.stopList = nil;
		
		// create our operation queue
		opQueue = [[NSOperationQueue alloc] init];
    }
	
    return self;
}

- (void) dealloc
{
    [opQueue release];
    [super dealloc];
}

#pragma mark -
#pragma mark Route List building

- (void) requestRouteList {
	// a controller has requested a route list
	// controller is observing routeList property
	// make sure the route list is available if someone wants it
	
	// TODO: should be checking a cache here
	
	RouteListOperation *loadingOp = [[RouteListOperation alloc] initWithDelegate:self];
	[opQueue addOperation:loadingOp];
	[loadingOp release];
}

- (void) requestStopList:(NSString *)stop {
	// a controller has requested a route stop list
	
	// TODO: should be checking a cache here
	
	StopListOperation *loadingOp = [[StopListOperation alloc] initWithDelegate:self andTitle:stop];
	[opQueue addOperation:loadingOp];
	[loadingOp release];
}

#pragma mark -
#pragma mark RouteListOperationDelegate methods

- (void)updateRouteList:(NSArray *)data {
	NSLog(@"updateRouteList: %d", [data count]);
	
	self.routeList = data;
}

- (void)updateStopList:(NSArray *)data {
	NSLog(@"updateStopList: %d", [data count]);
	
	self.stopList = data;
}

@end
