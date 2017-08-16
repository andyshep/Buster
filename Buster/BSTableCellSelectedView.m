//
//  BSTableCellSelectedView.m
//  Buster
//
//  Created by Andrew Shepard on 9/30/11.
//  Copyright 2011 Andrew Shepard. All rights reserved.
//

#import "BSTableCellSelectedView.h"


@implementation BSTableCellSelectedView

@synthesize borderColor;

- (id)initWithFrame:(CGRect)frame {
    if ((self = [super initWithFrame:frame])) {
        // Initialization code
		gradient = [BSAppTheme yellowGradientColor];
    }
    return self;
}

- (void)dealloc {
    [borderColor release];
	CGGradientRelease(gradient);
    [super dealloc];
}

- (BOOL) isOpaque {
    return NO;
}

- (void)drawRect:(CGRect)rect {
	// Drawing code
    CGContextRef c = UIGraphicsGetCurrentContext();
    CGContextSetStrokeColorWithColor(c, [borderColor CGColor]);
	BSDrawGradientInRect(c, gradient, rect);
   // CGContextStrokeRectWithWidth(c, rect, 1);
}

@end
