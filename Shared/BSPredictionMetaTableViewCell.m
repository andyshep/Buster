//
//  BSPredictionMetaTableViewCell.m
//  Buster
//
//  Created by andyshep on 8/23/11.
//
//  Copyright (c) 2010-2011 Andrew Shepard
// 
//  Permission is hereby granted, free of charge, to any person obtaining a copy
//  of this software and associated documentation files (the "Software"), to deal
//  in the Software without restriction, including without limitation the rights
//  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//  copies of the Software, and to permit persons to whom the Software is
//  furnished to do so, subject to the following conditions:
// 
//  The above copyright notice and this permission notice shall be included in
//  all copies or substantial portions of the Software.
// 
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
//  THE SOFTWARE.
//

#import "BSPredictionMetaTableViewCell.h"


@implementation BSPredictionMetaTableViewCell

@synthesize routeNumberLabel = _routeNumberLabel;
@synthesize routeDirectionLabel = _routeDirectionLabel; 
@synthesize stopNameLabel = _stopNameLabel;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    
    if ((self = [super initWithStyle:style reuseIdentifier:reuseIdentifier])) {
        containerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 88)];
        
        self.routeNumberLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 5, 40, 25)];
        self.routeDirectionLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 30, 270, 25)];
        self.stopNameLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 55, 270, 25)];
        
        self.routeDirectionLabel.adjustsFontSizeToFitWidth = YES;
        self.stopNameLabel.adjustsFontSizeToFitWidth = YES;
        
        self.routeNumberLabel.backgroundColor = [UIColor clearColor];
        self.routeDirectionLabel.backgroundColor = [UIColor clearColor];
        self.stopNameLabel.backgroundColor = [UIColor clearColor];
        
        [containerView addSubview:self.routeNumberLabel];
        [containerView addSubview:self.routeDirectionLabel];
        [containerView addSubview:self.stopNameLabel];
        [self addSubview:containerView];
    }
    
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}


@end