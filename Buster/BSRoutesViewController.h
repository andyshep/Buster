//
//  BSRoutesViewController.h
//  Buster
//
//  Created by Andrew Shepard on 12/15/10.
//  Copyright © 2010-2017 Andrew Shepard. All rights reserved.
//

@import UIKit;

@interface BSRoutesViewController : UIViewController <UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) UIToolbar *toolbar;
@property (nonatomic, strong) UISegmentedControl *routesListControl;

@end
