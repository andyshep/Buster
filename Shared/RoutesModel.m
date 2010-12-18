//
//  RoutesModel.m
//  Buster
//
//  Created by Andrew Shepard on 12/18/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "RoutesModel.h"


@implementation RoutesModel

@synthesize routeList;

SYNTHESIZE_SINGLETON_FOR_CLASS(RoutesModel);

#pragma mark -
#pragma mark Lifecycle

- (id) init {
    self = [super init];
    
	if (self != nil) {
		
		NSLog(@"RoutesModel init'd!");
		
		// init an empty set of routeTitles for the model
		self.routeList = nil;
		
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

#pragma mark -
#pragma mark RouteListOperationDelegate methods

- (void)didConsumeXMLData:(NSArray *)data {
	NSLog(@"didConsumeXMLData: %d", [data count]);
	
	self.routeList = data;
}

@end
