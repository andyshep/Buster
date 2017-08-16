//
//  BSArtistTools.m
//  Buster
//
//  Created by Andrew Shepard on 10/18/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "BSArtistTools.h"

@implementation BSArtistTools

void BSDrawGradientInRect(CGContextRef context, CGGradientRef gradient, CGRect rect) {
    CGContextSaveGState(context);
    CGContextClipToRect(context, rect);
    CGPoint start = CGPointMake(rect.origin.x, rect.origin.y);
    CGPoint end = CGPointMake(rect.origin.x, rect.origin.y + rect.size.height);
    CGContextDrawLinearGradient(context, gradient, start, end, 0);
    CGContextRestoreGState(context);
}

void BSDrawLinearGradientInRect(CGContextRef context, CGRect rect, CGColorRef startColor, CGColorRef  endColor) {
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    CGFloat locations[] = { 0.0, 1.0 };
    
    NSArray *colors = @[(__bridge id)startColor, (__bridge id)endColor];
    
    CGGradientRef gradient = CGGradientCreateWithColors(colorSpace, 
                                                        (__bridge CFArrayRef) colors, locations);
    
    CGPoint startPoint = CGPointMake(CGRectGetMidX(rect), CGRectGetMinY(rect));
    CGPoint endPoint = CGPointMake(CGRectGetMidX(rect), CGRectGetMaxY(rect));
    
    CGContextSaveGState(context);
    CGContextAddRect(context, rect);
    CGContextClip(context);
    CGContextDrawLinearGradient(context, gradient, startPoint, endPoint, 0);
    CGContextRestoreGState(context);
    
    CGGradientRelease(gradient);
    CGColorSpaceRelease(colorSpace);
}

CGRect BSRectForStroke(CGRect rect) {
    return CGRectMake(rect.origin.x + 0.5, rect.origin.y + 0.5, 
                      rect.size.width - 1, rect.size.height - 1);
}

void BSStrokeRect(CGContextRef context, CGPoint startPoint, CGPoint endPoint, CGColorRef color) {
    CGContextSaveGState(context);
    CGContextSetLineCap(context, kCGLineCapSquare);
    CGContextSetStrokeColorWithColor(context, color);
    CGContextSetLineWidth(context, 1.0);
    CGContextMoveToPoint(context, startPoint.x + 0.5, startPoint.y + 0.5);
    CGContextAddLineToPoint(context, endPoint.x + 0.5, endPoint.y + 0.5);
    CGContextStrokePath(context);
    CGContextRestoreGState(context);
}

CGGradientRef BSGradientWithColors(UIColor *topColor, UIColor *bottomColor) {
    return BSGradientWithColorsAndLocations(topColor, bottomColor, 0.0f, 1.0f);
}

CGGradientRef BSGradientWithColorsAndLocations(UIColor *topColor, UIColor *bottomColor, CGFloat topLocation, CGFloat bottomLocation) {
    CGFloat locations[] = {
        topLocation,
        bottomLocation
    };
    
    CGColorRef topCGColor = topColor.CGColor;
    CGColorSpaceRef colorSpace = CGColorGetColorSpace(topCGColor);
    NSArray *colors = @[(__bridge id)topCGColor, (id)bottomColor.CGColor];
    CGGradientRef gradient = CGGradientCreateWithColors(colorSpace, (__bridge CFArrayRef)colors, locations);
    
    return gradient;
}

@end
