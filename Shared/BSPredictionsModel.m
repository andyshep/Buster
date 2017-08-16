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

#import "BSMBTARequestOperation.h"

#import "MBTAQueryStringBuilder.h"

@interface BSPredictionsModel ()

- (void)unloadPredictions;

@end

@implementation BSPredictionsModel

- (id) init {
	if ((self = [super init])) {
        //
    }
	
    return self;
}

#pragma mark - KVC
- (NSUInteger)countOfPredictions {
	return [self.predictions count];
}

- (id)objectInPredictionsAtIndex:(NSUInteger)index {
	return [self.predictions objectAtIndex:index];
}

- (void)getPredictions:(__unsafe_unretained id *)objects range:(NSRange)range {
	[self.predictions getObjects:objects range:range];
}

#pragma mark - Predictions building
- (void)requestPredictionsForRoute:(NSString *)route andStop:(NSString *)stop {
    NSLog(@"requesting predictions for %@ at %@", route, stop);
    
    NSString *urlString = [[MBTAQueryStringBuilder sharedInstance] buildPredictionsQueryForRoute:route withDirection:nil atStop:stop];
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:urlString]];
    
    BSMBTARequestOperation *operation = [BSMBTARequestOperation MBTARequestOperationWithRequest:request success:^(NSURLRequest *request, NSHTTPURLResponse *response, id object) {
        // get predictions
    } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *err) {
        self.error = err;
    }];
    
    NSOperationQueue *queue = [[NSOperationQueue alloc] init];
    [queue addOperation:operation];
}

- (void)unloadPredictions {
	self.predictions = nil;
    self.predictionMeta = nil;
}

@end
