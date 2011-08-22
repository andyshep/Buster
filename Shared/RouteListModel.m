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

#pragma mark -
#pragma mark Lifecycle

- (id) init {
	if ((self = [super init])) {
		
		// init an empty set of routeTitles for the model
		self.routes = nil;
		
		// create our operation queue
		opQueue_ = [[NSOperationQueue alloc] init];
    }
	
    return self;
}

- (void) dealloc {
    [opQueue_ release];
    [routeListOp_ release];
    [routes release];
    [super dealloc];
}

#pragma mark -
#pragma mark Model KVC

// our view controller uses these to display table data

- (NSUInteger)countOfRoutes {
	return [routes count];
}

- (id)objectInRoutesAtIndex:(NSUInteger)index {
	return [routes objectAtIndex:index];
}

- (void)getRoutes:(id *)objects range:(NSRange)range {
	[routes getObjects:objects range:range];
}

#pragma mark -
#pragma mark Operation Observing

// we use this method to cleanup after operations complete

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
    // only observing keyPath "isFinished".  cleanup route list op
    // NSLog(@"RouteListOperation isFinished");
    [routeListOp_ removeObserver:self forKeyPath:@"isFinished"];
    [routeListOp_ release];
}

#pragma mark -
#pragma mark Route List building

- (void) requestRouteList {
	// a controller has requested a route list
	// controller is observing routeList property
	// make sure the route list is available if someone wants it
	
	// TODO: should be checking a cache here
        
//        MBTAQueryStringBuilder *_builder = [MBTAQueryStringBuilder sharedMBTAQueryStringBuilder];
//        routeListOp_ = [[RouteListOperation alloc] initWithURLString:[_builder buildRouteListQuery] delegate:self];
   
    
    #ifdef USE_STUB_SERVICE
    routeListOp_ = [[RouteListOperation alloc] initWithURLString:@"http://localhost:8081/routeList.xml" delegate:self];
    #else
    MBTAQueryStringBuilder *_builder = [MBTAQueryStringBuilder sharedMBTAQueryStringBuilder];
    routeListOp_ = [[RouteListOperation alloc] initWithURLString:[_builder buildRouteListQuery] delegate:self];    
    #endif
    
    [routeListOp_ addObserver:self forKeyPath:@"isFinished" options:NSKeyValueObservingOptionNew context:NULL];
    [opQueue_ addOperation:routeListOp_];
}

#pragma mark - BSNetworkOperationDelegate

- (void)didConsumeData:(id)consumedData {
    NSLog(@"didConsumeData: %@", consumedData);
    
    self.routes = consumedData;
}

@end
