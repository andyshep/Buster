//
//  MapViewController.h
//  Buster
//
//  Created by Andrew Shepard on 12/15/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "RouteListViewController.h"

@protocol MapViewControllerDelegate

- (void)flipsideViewControllerDidFinish:(id)sender;

@end


@interface MapViewController : UIViewController <MapViewControllerDelegate> {

}

- (IBAction)handleInfoButton:(id)sender;
- (void)flipsideViewControllerDidFinish:(id)sender;

@end
