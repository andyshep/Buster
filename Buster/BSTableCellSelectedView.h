//
//  BSTableCellSelectedView.h
//  Buster
//
//  Created by Andrew Shepard on 9/30/11.
//  Copyright 2011 Andrew Shepard. All rights reserved.
//

#import "BSAppTheme.h"


@interface BSTableCellSelectedView : UIView {
	UIColor *borderColor;
	CGGradientRef gradient;
}

@property (nonatomic, retain) UIColor *borderColor;

@end
