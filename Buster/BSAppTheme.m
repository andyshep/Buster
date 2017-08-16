//
//  BSAppTheme.m
//  Buster
//
//  Created by Andrew Shepard on 9/29/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "BSAppTheme.h"

@implementation BSAppTheme

#pragma mark -
#pragma mark Fonts for UI elements

+ (UIFont *)tenPointlabelFont {
	return [UIFont fontWithName:@"Verdana" size:10];
}

+ (UIFont *)twelvePointlabelFont {
	return [UIFont fontWithName:@"Verdana" size:12];
}

+ (UIFont *)fourteenPointlabelFont {
	return [UIFont fontWithName:@"Verdana" size:14];
}

#pragma mark -
#pragma mark Colors for UI elements

+ (UIColor *)lightBlueColor {
    return [UIColor colorWithRed:66.0f/255.0f 
                           green:155.0f/255.0f 
                            blue:194.0f/255.0f 
                           alpha:1.0f];
}

+ (UIColor *)lightTanColor {
    return[UIColor colorWithRed:246.0f/255.0f 
                          green:246.0f/255.0f 
                           blue:239.0f/255.0f 
                          alpha:1.0f];
}

+ (UIColor *)veryDarkGrey {
    return [UIColor colorWithRed:74.0f/255.0f 
                           green:74.0f/255.0f 
                            blue:74.0f/255.0f 
                           alpha:1.0f];
}

+ (CGGradientRef)blueishGradientColor {
	UIColor *topColor = [UIColor colorWithRed:(122.0f/255.f) 
                                        green:(202.0f/255.0f) 
                                         blue:(255.0f/255.0f) 
                                        alpha:(255.0f/255.0f)];
	
	UIColor *bottomColor = [UIColor colorWithRed:(0.0f/255.f) 
										   green:(153.0f/255.0f) 
											blue:(255.0f/255.0f) 
										   alpha:(255.0f/255.0f)];
	
	return BSGradientWithColors(topColor, bottomColor);
}

+ (CGGradientRef)yellowGradientColor {
	UIColor *topColor = [UIColor colorWithRed:242.0f/255.0f 
                                         green:238.0f/255.0f 
                                          blue:182.0f/255.0f 
                                         alpha:1.0f];
	
	UIColor *bottomColor = [UIColor colorWithRed:(235.0f/255.f) 
										   green:(238.0f/255.0f) 
											blue:(144.0f/255.0f) 
										   alpha:(1.0f)];
	
	return BSGradientWithColors(topColor, bottomColor);
}

+ (CGGradientRef)greyGradientColor {
	UIColor *topColor = [UIColor colorWithRed:232.0f/255.0f 
                                        green:232.0f/255.0f 
                                         blue:232.0f/255.0f 
                                        alpha:1.0f];
	
	UIColor *bottomColor = [UIColor colorWithRed:(215.0f/255.f) 
										   green:(215.0f/255.0f) 
											blue:(215.0f/255.0f) 
										   alpha:(1.0f)];
	
	return BSGradientWithColors(topColor, bottomColor);
}

@end
