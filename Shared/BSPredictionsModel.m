//
//  PredictionsModel.m
//  Buster
//
//  Created by andyshep on 1/3/11.
//
//  Copyright (c) 2010-2011 Andrew Shepard
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

#import "BSPredictionsModel.h"


@implementation BSPredictionsModel

@synthesize predictions, predictionMeta, error;

#pragma mark -
#pragma mark Lifecycle

- (id) init {
	if ((self = [super init])) {
		
		// init an empty set of predictions for the model
		self.predictions = nil, self.error = nil, self.predictionMeta = nil;
    }
	
    return self;
}

- (void) dealloc {
    [predictions release];
    [predictionMeta release];
    [error release];
    
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
#pragma mark Predictions building

- (void)requestPredictionsForRoute:(NSString *)route andStop:(NSString *)stop {
	// a controller has requested a prediction
    // NSLog(@"requesting predictions for %@ at %@", route, stop);
    
//#ifdef USE_STUB_SERVICE
//    predictionsOp_ = [[PredictionsOperation alloc] initWithURLString:@"http://localhost:8081/predictions_route57_stop918.xml" delegate:self];
//#else
//    MBTAQueryStringBuilder *_builder = [MBTAQueryStringBuilder sharedMBTAQueryStringBuilder];
//    NSString *predictionsUrl = [_builder buildPredictionsQueryForRoute:route 
//                                              withDirection:nil 
//                                                     atStop:stop];
//
//    predictionsOp_ = [[PredictionsOperation alloc] initWithURLString:predictionsUrl delegate:self];
//#endif
    
    // FIXME: you op doesn't really need these properties
    // leftover refactor
    
//    predictionsOp_.stop = stop;
//    [predictionsOp_ addObserver:self forKeyPath:@"isFinished" options:NSKeyValueObservingOptionNew context:NULL];
//    [opQueue_ addOperation:predictionsOp_];
    
    NSString *urlString = [NSString stringWithFormat:@"http://localhost:4000/route.json/%@/stop/%@", route, stop]; 
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:urlString]];
    AFJSONRequestOperation *operation = [AFJSONRequestOperation operationWithRequest:request success:^(id JSON) {
        
        // TODO: check for error JSON returned
        // TODO: parse out predictions meta
        
        NSArray *_predictions = (NSArray *)JSON;
        NSLog(@"%@", [_predictions objectAtIndex:0]);
        
        self.predictions = _predictions;

//        NSMutableArray *_routes = [NSMutableArray arrayWithCapacity:20];
//        
//        for (NSDictionary *route in [JSON valueForKeyPath:@"routes"]) {
//            // NSLog(@"%@, %@", [route valueForKeyPath:@"tag"], [route valueForKeyPath:@"title"]);
//            
//            BSRoute *aRoute = [[[BSRoute alloc] init] autorelease];
//            [aRoute setTag:[route valueForKeyPath:@"tag"]];
//            [aRoute setTitle:[route valueForKeyPath:@"title"]];
//            
//            [_routes addObject:aRoute];
//        }
//        
//        self.routes = _routes;
//        
//        // TODO: implement
//        [self saveChanges];
        
    } failure:^(NSError *err) {
        // TODO: handle error
        self.error = err;
    }];
    
    NSOperationQueue *queue = [[[NSOperationQueue alloc] init] autorelease];
    [queue addOperation:operation];
}

- (void)unloadPredictions {
	self.predictions = nil;
    self.predictionMeta = nil;
}

#pragma mark -
#pragma mark BSNetworkOperationDelegate
     
- (void)didConsumeData:(id)consumedData {
    self.predictionMeta = [(NSArray *)consumedData objectAtIndex:0];
    self.predictions = [(NSArray *)consumedData objectAtIndex:1];
}

- (void)didFailWithError:(NSError *)aError {
    self.error = aError;
}

@end
