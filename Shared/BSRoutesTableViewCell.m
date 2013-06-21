//
//  BSRoutesTableViewCell.m
//  Buster
//
//  Created by Andrew Shepard on 11/11/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "BSRoutesTableViewCell.h"

@implementation BSRoutesTableViewCell

@synthesize routeNumberLabel = _routeNumberLabel, routeEndpointsLabel = _routeEndpointsLabel;

- (id)init
{
    self = [super init];
    if (self) {
        CGRect frame = CGRectMake(0.0f, 0.0f, 320.0f, 64.0f);
        UIView *containerView = [[UIView alloc] initWithFrame:frame];
        
        self.routeNumberLabel = [[UILabel alloc] initWithFrame:CGRectMake(8.0, 6.0, 272.0, 14.0)];
        self.routeEndpointsLabel = [[UILabel alloc] initWithFrame:CGRectMake(8.0, 14.0, 272.0, 36.0)];
        
        self.routeNumberLabel.font = [UIFont boldSystemFontOfSize:20.0];
        self.routeNumberLabel.backgroundColor = [UIColor clearColor];
        self.routeEndpointsLabel.font = [BSAppTheme twelvePointlabelFont];
        self.routeEndpointsLabel.numberOfLines = 4;
        self.routeEndpointsLabel.textColor = [BSAppTheme veryDarkGrey];
        self.routeEndpointsLabel.backgroundColor = [UIColor clearColor];
        self.routeEndpointsLabel.autoresizingMask = UIViewAutoresizingFlexibleHeight;
        
        [containerView setAutoresizingMask:UIViewAutoresizingFlexibleHeight];
        
        [containerView addSubview:self.routeNumberLabel];
        [containerView addSubview:self.routeEndpointsLabel];
        
        [self addSubview:containerView];
        
        BSGradientView *backgroundView = [[BSGradientView alloc] initWithFrame:frame];
        [self setBackgroundView:backgroundView];
        
        BSGradientView *selectedView = [[BSGradientView alloc] initWithFrame:frame];
        selectedView.gradient = [BSAppTheme yellowGradientColor];
        [self setSelectedBackgroundView:selectedView];
        
        [self setAccessoryType:UITableViewCellAccessoryDisclosureIndicator];
    }
    return self;
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
