//
//  RoutesModel.h
//  Buster
//
//  Created by Andrew Shepard on 12/18/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "SynthesizeSingleton.h"
#import "RouteListOperation.h"


@interface RoutesModel : NSObject <RouteListOperationDelegate> {
	NSOperationQueue *opQueue;
	
	NSArray *routeList;
	
	NSMutableDictionary *routesModel;
}

@property (copy) NSArray *routeList;

+ (RoutesModel *)sharedRoutesModel;

- (void) requestRouteList;

@end
