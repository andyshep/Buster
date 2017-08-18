//
//  BSRoutesTableViewCell.m
//  Buster
//
//  Created by Andrew Shepard on 11/11/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "BSRoutesTableViewCell.h"

@implementation BSRoutesTableViewCell

- (instancetype)init {
    if ((self = [super init])) {
        self.routeNumberLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        _routeNumberLabel.backgroundColor = [UIColor clearColor];
        _routeNumberLabel.font = [UIFont preferredFontForTextStyle:UIFontTextStyleTitle1];
        
        self.routeEndpointsLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        _routeEndpointsLabel.backgroundColor = [UIColor clearColor];
        _routeEndpointsLabel.font = [UIFont preferredFontForTextStyle:UIFontTextStyleCaption1];
        _routeEndpointsLabel.numberOfLines = 4;
        _routeEndpointsLabel.autoresizingMask = UIViewAutoresizingFlexibleHeight;
        
        [self.contentView addSubview:self.routeNumberLabel];
        [self.contentView addSubview:self.routeEndpointsLabel];
        
        self.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    _routeNumberLabel.frame = CGRectMake(8.0f, 6.0f, 272.0f, 14.0f);
    _routeEndpointsLabel.frame = CGRectMake(8.0f, 23.0f, 272.0f, 36.0f);
}

@end
