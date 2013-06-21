//
//  BSRoutesTableViewCell.m
//  Buster
//
//  Created by Andrew Shepard on 11/11/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "BSRoutesTableViewCell.h"

@implementation BSRoutesTableViewCell

- (id)init {
    if ((self = [super init])) {
        self.routeNumberLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        [_routeNumberLabel setBackgroundColor:[UIColor clearColor]];
        [_routeNumberLabel setFont:[UIFont boldSystemFontOfSize:20.0f]];
        
        self.routeEndpointsLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        [_routeEndpointsLabel setBackgroundColor:[UIColor clearColor]];
        [_routeEndpointsLabel setFont:[BSAppTheme twelvePointlabelFont]];
        [_routeEndpointsLabel setNumberOfLines:4];
        [_routeEndpointsLabel setAutoresizingMask:UIViewAutoresizingFlexibleHeight];
        
        [self.contentView addSubview:self.routeNumberLabel];
        [self.contentView addSubview:self.routeEndpointsLabel];
        
        [self setAccessoryType:UITableViewCellAccessoryDisclosureIndicator];
    }
    
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    [_routeNumberLabel setFrame:CGRectMake(8.0f, 6.0f, 272.0f, 14.0f)];
    [_routeEndpointsLabel setFrame:CGRectMake(8.0f, 23.0f, 272.0f, 36.0f)];
}

@end
