//
//  RootViewController.h
//  SplitTest
//
//  Created by Andrew Shepard on 12/16/10.
//  Copyright __MyCompanyName__ 2010. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RoutesModel.h"

@class DetailViewController;

@interface RootViewController : UITableViewController {
    DetailViewController *detailViewController;
	
	NSArray *routeList;
}

@property (nonatomic, retain) IBOutlet DetailViewController *detailViewController;
@property (copy) NSArray *routeList;

@end
