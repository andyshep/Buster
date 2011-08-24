//
//  PredictionsTableViewCell.m
//  Buster
//
//  Created by Andrew Shepard on 8/23/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "PredictionsTableViewCell.h"


@implementation PredictionsTableViewCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    
    if ((self = [super initWithStyle:style reuseIdentifier:reuseIdentifier])) {
        containerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 88)];
    }
    
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)dealloc {
    [containerView release];
    [super dealloc];
}

@end
