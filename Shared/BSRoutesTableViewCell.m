//
//  BSRoutesTableViewCell.m
//  Buster
//
//  Created by Andrew Shepard on 11/6/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "BSRoutesTableViewCell.h"

@implementation BSRoutesTableViewCell

@synthesize routeNumberLabel = _routeNumberLabel;
@synthesize routeEndpointsLabel = _routeEndpointsLabel;

- (void)dealloc {
    [_routeEndpointsLabel release];
    [_routeNumberLabel release];
    [super dealloc];
}

- (void)awakeFromNib {
    // self.routeEndpointsLabel.numberOfLines = 4;
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
