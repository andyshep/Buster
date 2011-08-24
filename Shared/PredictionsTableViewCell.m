//
//  PredictionsTableViewCell.m
//  Buster
//
//  Created by Andrew Shepard on 8/23/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "PredictionsTableViewCell.h"


@implementation PredictionsTableViewCell

@synthesize routeNumberLabel, routeDirectionLabel, stopNameLabel;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    
    if ((self = [super initWithStyle:style reuseIdentifier:reuseIdentifier])) {
        containerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 88)];
        
        routeNumberLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 5, 40, 25)];
        routeDirectionLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 30, 270, 25)];
        stopNameLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 55, 270, 25)];
        
        routeDirectionLabel.adjustsFontSizeToFitWidth = YES;
        stopNameLabel.adjustsFontSizeToFitWidth = YES;
        
        
        [containerView addSubview:routeNumberLabel];
        [containerView addSubview:routeDirectionLabel];
        [containerView addSubview:stopNameLabel];
        [self addSubview:containerView];
    }
    
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)dealloc {
    [routeNumberLabel release];
    [routeDirectionLabel release];
    [stopNameLabel release];
    [containerView release];
    [super dealloc];
}

@end
