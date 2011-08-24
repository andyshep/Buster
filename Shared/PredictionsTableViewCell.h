//
//  PredictionsTableViewCell.h
//  Buster
//
//  Created by Andrew Shepard on 8/23/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface PredictionsTableViewCell : UITableViewCell {

    UILabel *routeNumberLabel, *routeDirectionLabel, *stopNameLabel;
    
@private
	UIView *containerView;
}

@property (nonatomic, retain) UILabel *routeNumberLabel, *routeDirectionLabel, *stopNameLabel;

@end
