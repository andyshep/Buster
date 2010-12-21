//
//  RoutesModel.h
//  Buster
//
//  Created by Andrew Shepard on 12/18/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "SynthesizeSingleton.h"
#import "RouteListOperation.h"
#import "StopListOperation.h"


@interface RoutesModel : NSObject <RouteListOperationDelegate, StopListOperationDelegate> {
	NSOperationQueue *opQueue;
	
	NSArray *routeList;
	NSArray *stopList;
	
	NSMutableDictionary *routesModel;
}

@property (copy) NSArray *routeList;
@property (copy) NSArray *stopList;

+ (RoutesModel *)sharedRoutesModel;

- (void) requestRouteList;

@end
