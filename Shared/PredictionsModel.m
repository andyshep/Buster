//
//  StopModel.m
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

#import "PredictionsModel.h"


@implementation PredictionsModel

@synthesize predictions;

SYNTHESIZE_SINGLETON_FOR_CLASS(PredictionsModel);

#pragma mark -
#pragma mark Lifecycle

- (id) init {
    self = [super init];
    
	if (self != nil) {
		
		// init an empty set of predictions for the model
		self.predictions = nil;
		
		// create our operation queue
		opQueue = [[NSOperationQueue alloc] init];
    }
	
    return self;
}

- (void) dealloc {
    [opQueue release];
    [super dealloc];
}

#pragma mark -
#pragma mark Model KVC

- (NSUInteger)countOfPredictions {
	return [predictions count];
}

- (id)objectInPredictionsAtIndex:(NSUInteger)index {
	return [predictions objectAtIndex:index];
}

- (void)getPredictions:(id *)objects range:(NSRange)range {
	[predictions getObjects:objects range:range];
}

- (id)predictions {
	return predictions;
}

#pragma mark -
#pragma mark Predictions building

- (void)requestPredictionsForRoute:(NSString *)route andStop:(NSString *)stop {
	// a controller has requested a prediction
	
	PredictionsOperation *loadingOp = [[PredictionsOperation alloc] initWithDelegate:self route:route stop:stop];
	[opQueue addOperation:loadingOp];
	[loadingOp release];
}

#pragma mark -
#pragma mark PredictionsOperationDelegate methods

- (void)updatePredictions:(NSArray *)data {
	// TODO: implement
	
	self.predictions = data;
}

@end
