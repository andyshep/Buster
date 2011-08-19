//
//  PredictionsOperation.m
//  Buster
//
//  Created by andyshep on 1/3/11.
//
//  Copyright (c) 2010 Andrew Shepard
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

#import "PredictionsOperation.h"


@implementation PredictionsOperation

@synthesize route, stop;

#pragma mark -
#pragma mark Predictions Processing

- (void)consumeData {
    
    [super consumeData];
	
	// a list of route stops will be passed back and stored into the model
	NSMutableArray *predictions = [NSMutableArray arrayWithCapacity:5];
	
	if (consumedData != nil) {
		
		// parse out the xml data
		CXMLDocument *doc = [[CXMLDocument alloc] initWithData:consumedData options:0 error:nil];
		NSArray *nodes;
		
		// searching for prediction nodes
		nodes = [doc nodesForXPath:@"//prediction" error:nil];
		
		for (CXMLElement *node in nodes) {
			
			NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithCapacity:5];
			
			// FIXME: this is leaky			
			[dict setObject:[[node attributeForName:@"minutes"] stringValue] forKey:@"minutes"];
			[dict setObject:[[node attributeForName:@"seconds"] stringValue] forKey:@"seconds"];
			[dict setObject:[[node attributeForName:@"vehicle"] stringValue] forKey:@"vehicle"];
			[dict setObject:[[node attributeForName:@"dirTag"] stringValue] forKey:@"dirTag"];
			[dict setObject:[[node attributeForName:@"epochTime"] stringValue] forKey:@"time"];
			
			[predictions addObject:dict];
			
			dict = nil;
		}
		
		[doc release];
		nodes = nil;
	}
	
	consumedData = predictions;
}

@end
