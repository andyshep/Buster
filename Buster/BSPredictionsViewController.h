//
//  BSPredictionsViewController.h
//  Buster
//
//  Created by Andrew Shepard on 1/3/11.
//  Copyright © 2011-2017 Andrew Shepard. All rights reserved.
//

@import UIKit;

@class BSStop;
@class BSDirection;

@interface BSPredictionsViewController : UIViewController

@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, strong) BSDirection *direction;
@property (nonatomic, strong) BSStop *stop;

@end
