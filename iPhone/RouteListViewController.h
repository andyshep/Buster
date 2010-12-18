//
//  RouteListViewController.h
//  Buster
//
//  Created by Andrew Shepard on 12/15/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "MapViewController.h"
#import "RouteStopViewController.h"
#import "RoutesModel.h"

@protocol MapViewControllerDelegate;

@interface RouteListViewController : UITableViewController {
	id <MapViewControllerDelegate> delegate;
	
	NSArray *routeList;
}

@property (nonatomic, assign) id <MapViewControllerDelegate> delegate;
@property (copy) NSArray *routeList;

- (IBAction)done;

@end
