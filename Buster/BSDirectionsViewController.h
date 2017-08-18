//
//  BSDirectionsViewController.h
//  Buster
//
//  Created by Andrew Shepard on 8/9/10.
//  Copyright © 2010-2017 Andrew Shepard. All rights reserved.
//

@import UIKit;

@interface BSDirectionsViewController : UIViewController

@property (nonatomic, strong) IBOutlet UITableView *tableView;
@property (nonatomic, strong) IBOutlet UIToolbar *bottomToolbar;
@property (nonatomic, strong) UISegmentedControl *directionControl;

@property (nonatomic, strong) NSString *stopTag;
@property (nonatomic, strong) NSString *directionTitle;

- (void)switchDirection:(id)sender;
- (void)reloadTable;

@end
