//
//  BSPredictionsViewController.h
//  Buster
//
//  Created by Andrew Shepard on 1/3/11.
//  Copyright © 2011-2017 Andrew Shepard. All rights reserved.
//

#import "BSPredictionMetaTableViewCell.h"
#import "BSPredictionsModel.h"
#import "BSMapViewController.h"

@interface BSPredictionsViewController : UITableViewController

@property (nonatomic, strong) NSString *stopTag;
@property (nonatomic, strong) NSString *latitude;
@property (nonatomic, strong) NSString *longitude;
@property (nonatomic, strong) NSString *routeNumber;
@property (nonatomic, strong) NSString *routeTitle;
@property (nonatomic, strong) NSString *directionTag;

- (IBAction)refreshList:(id)sender;

@end
