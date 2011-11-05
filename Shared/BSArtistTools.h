//
//  BSArtistTools.h
//  Buster
//
//  Created by Andrew Shepard on 10/18/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

// based on code and examples from:
// http://www.raywenderlich.com/2033/core-graphics-101-lines-rectangles-and-gradients
// https://github.com/samsoffes/sstoolkit/blob/master/SSToolkit/SSDrawingUtilities.m

#import <Foundation/Foundation.h>

@interface BSArtistTools : NSObject

// FIXME: don't need both of these
void BSDrawGradientInRect(CGContextRef context, CGGradientRef gradient, CGRect rect);
void BSDrawLinearGradientInRect(CGContextRef context, CGRect rect, CGColorRef startColor, CGColorRef  endColor);

void BSStrokeRect(CGContextRef context, CGPoint startPoint, CGPoint endPoint, CGColorRef color);

CGRect BSRectForStroke(CGRect rect);
CGGradientRef BSGradientWithColors(UIColor *topColor, UIColor *bottomColor);
CGGradientRef BSGradientWithColorsAndLocations(UIColor *topColor, UIColor *bottomColor, CGFloat topLocation, CGFloat bottomLocation);

@end

