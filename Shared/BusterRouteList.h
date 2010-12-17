//
//  BusterRouteList.h
//  Buster
//
//  Created by Andrew Shepard on 12/16/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "SynthesizeSingleton.h"
#import "RouteListOperation.h"


@interface BusterRouteList : NSObject <RouteListOperationDelegate> {
	NSArray *routeList;
}

@property (copy) NSArray *routeList;

+ (BusterRouteList *)sharedBusterRouteList;

@end
