//
//  BSDirectionsViewController.h
//  Buster
//
//  Created by Andrew Shepard on 8/9/10.
//  Copyright © 2010-2017 Andrew Shepard. All rights reserved.
//

@import UIKit;

@class BSRoute;

@interface BSDirectionsViewController : UIViewController

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) UIToolbar *bottomToolbar;
@property (nonatomic, strong) UISegmentedControl *directionControl;

@property (nonatomic, strong) BSRoute *route;

@end
