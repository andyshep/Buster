//
//  RouteListViewController.h
//  Buster
//
//  Created by Andrew Shepard on 12/15/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "MapViewController.h"

@protocol MapViewControllerDelegate;

@interface RouteListViewController : UITableViewController {
	id <MapViewControllerDelegate> delegate;
	
	
}

@property (nonatomic, assign) id <MapViewControllerDelegate> delegate;

- (IBAction)done;

@end
