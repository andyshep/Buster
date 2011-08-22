//
//  PredictionsModel.m
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

#pragma mark -
#pragma mark Lifecycle

- (id) init {
	if ((self = [super init])) {
		
		// init an empty set of predictions for the model
		self.predictions = nil;
		
		// create our operation queue
		opQueue_ = [[NSOperationQueue alloc] init];
    }
	
    return self;
}

- (void) dealloc {
    [opQueue_ release];
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

#pragma mark -
#pragma mark Operation Observing

// we use this method to cleanup after operations complete

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
    // only observing keyPath "isFinished".  cleanup stop list op
    // NSLog(@"StopListOperation isFinished");
    [predictionsOp_ removeObserver:self forKeyPath:@"isFinished"];
    [predictionsOp_ release];
}

#pragma mark -
#pragma mark Predictions building

- (void)requestPredictionsForRoute:(NSString *)route andStop:(NSString *)stop {
	// a controller has requested a prediction
    // NSLog(@"requesting predictions for %@ at %@", route, stop);
    
    #ifdef USE_STUB_SERVICE
        predictionsOp_ = [[PredictionsOperation alloc] initWithURLString:@"http://localhost:8081/predictions_route57_stop918.xml" delegate:self];
    #else
        MBTAQueryStringBuilder *_builder = [MBTAQueryStringBuilder sharedMBTAQueryStringBuilder];
        NSString *predictionsUrl = [_builder buildPredictionsQueryForRoute:route 
                                                  withDirection:nil 
                                                         atStop:stop];
    
        predictionsOp_ = [[PredictionsOperation alloc] initWithURLString:predictionsUrl delegate:self];
    #endif
    
    // FIXME: you op doesn't really need these properties
    // leftover refactor
    
    predictionsOp_.stop = stop;
    [predictionsOp_ addObserver:self forKeyPath:@"isFinished" options:NSKeyValueObservingOptionNew context:NULL];
    [opQueue_ addOperation:predictionsOp_];
}

- (void)unloadPredictions {
	self.predictions = nil;
}

#pragma mark -
#pragma mark BSNetworkOperationDelegate
     
- (void)didConsumeData:(id)consumedData {
    // NSLog(@"predictions model didConsumeData: %@", consumedData);
    self.predictions = (NSArray *)consumedData;
}

@end
