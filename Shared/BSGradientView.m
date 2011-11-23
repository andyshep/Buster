//
//  BSGradientView.m
//  Buster
//
//  Created by Andrew Shepard on 11/7/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "BSGradientView.h"

@implementation BSGradientView

@synthesize gradient = _gradient;

- (id)initWithFrame:(CGRect)frame {
    if ((self = [super initWithFrame:frame])) {
        _gradient = [BSAppTheme greyGradientColor];
    }
    
    return self;
}

- (void)awakeFromNib {
    _gradient = [BSAppTheme greyGradientColor];
}

- (void)dealloc {
    CGGradientRelease(_gradient);
    [super dealloc];
}

- (void)drawRect:(CGRect)rect {
    CGContextRef c = UIGraphicsGetCurrentContext();
	BSDrawGradientInRect(c, _gradient, rect);
    
//    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone) {
//        [self applyNoise];
//    }
}

@end
