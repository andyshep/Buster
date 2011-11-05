//
//  BSAppTheme.h
//  Buster
//
//  Created by Andrew Shepard on 9/29/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>
#import "BSArtistTools.h"

@interface BSAppTheme : NSObject

+ (UIFont *)tenPointlabelFont;
+ (UIFont *)twelvePointlabelFont;
+ (UIFont *)fourteenPointlabelFont;

+ (UIColor *)lightBlueColor;
+ (UIColor *)lightTanColor;
+ (UIColor *)veryDarkGrey;

+ (CGGradientRef)tanGradientColor;
+ (CGGradientRef)blueishGradientColor;
+ (CGGradientRef)greyGradientColor;

@end
