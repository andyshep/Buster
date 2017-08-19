//
//  BSPredictionsViewController.h
//  Buster
//
//  Created by Andrew Shepard on 1/3/11.
//  Copyright © 2011-2017 Andrew Shepard. All rights reserved.
//

@import UIKit;

@class BSStop;

@interface BSPredictionsViewController : UIViewController

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) BSStop *stop;

@end
