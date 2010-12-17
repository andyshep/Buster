//
//  BusterRouteList.m
//  Buster
//
//  Created by Andrew Shepard on 12/16/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "BusterRouteList.h"


@implementation BusterRouteList

SYNTHESIZE_SINGLETON_FOR_CLASS(BusterRouteList);

@synthesize routeList;

#pragma mark -
#pragma mark Lifecycle

- (id) init {
    self = [super init];
    
	if (self != nil) {
		
		NSLog(@"model init'd!");
		
		// init an empty set of routeTitles for the model
        self.routeList = nil;
		
		// create and start up an operation
		NSOperationQueue *opQueue = [[NSOperationQueue alloc] init];
		RouteListOperation *loadingOp = [[RouteListOperation alloc] initWithDelegate:self];
		[opQueue addOperation:loadingOp];
		
		[loadingOp release];
		[opQueue release];
    }
	
    return self;
}

- (void) dealloc
{
    [routeList release];
    [super dealloc];
}

#pragma mark -
#pragma mark Route List Loading

#pragma mark -
#pragma mark RouteListOperationDelegate methods

- (void)didConsumeXMLData:(NSDictionary *)data {
	NSLog(@"didConsumeXMLData: %d", [data count]);
	
	self.routeList = data;
}



@end
