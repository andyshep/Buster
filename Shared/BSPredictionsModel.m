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

@synthesize predictions = _predictions, predictionMeta = _predictionMeta, error = _error;

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
    [_predictions release];
    [_predictionMeta release];
    [_error release];
    
    [super dealloc];
}

#pragma mark -
#pragma mark Model KVC

- (NSUInteger)countOfPredictions {
	return [self.predictions count];
}

- (id)objectInPredictionsAtIndex:(NSUInteger)index {
	return [self.predictions objectAtIndex:index];
}

- (void)getPredictions:(id *)objects range:(NSRange)range {
	[self.predictions getObjects:objects range:range];
}

#pragma mark -
#pragma mark Predictions building

- (void)requestPredictionsForRoute:(NSString *)route andStop:(NSString *)stop {
	// a controller has requested a prediction
    NSLog(@"requesting predictions for %@ at %@", route, stop);
    
    NSString *urlString = [[MBTAQueryStringBuilder sharedInstance] buildPredictionsQueryForRoute:route withDirection:nil atStop:stop];
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:urlString]];
    
    AFHTTPRequestOperation *operation = [AFHTTPRequestOperation HTTPRequestOperationWithRequest:request success:^(id object) {
        NSError *error_ = nil;
        SMXMLDocument *xml = [SMXMLDocument documentWithData:object error:NULL];
        
       // NSLog(@"%@", xml);
        
        if (!error_) {
            NSMutableArray *predictions = [NSMutableArray arrayWithCapacity:5];
            NSDictionary *predictionInfo = [NSMutableDictionary dictionaryWithCapacity:3];
            SMXMLElement *predictionsElement = [xml.root childNamed:@"predictions"];
            SMXMLElement *directionElement = [predictionsElement childNamed:@"direction"];
            
            [predictionInfo setValue:[predictionsElement attributeNamed:@"routeTitle"] forKey:@"routeTitle"];
            [predictionInfo setValue:[predictionsElement attributeNamed:@"stopTitle"] forKey:@"stopTitle"];
            [predictionInfo setValue:[directionElement attributeNamed:@"title"] forKey:@"directionTitle"]; 
            
            // go thru each prediction and get the time and vehicle attributes
            for (SMXMLElement *predictionElement in [directionElement childrenNamed:@"prediction"]) {
                NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithCapacity:5];
                
                [dict setObject:[predictionElement attributeNamed:@"minutes"] forKey:@"minutes"];
                [dict setObject:[predictionElement attributeNamed:@"seconds"] forKey:@"seconds"];
                [dict setObject:[predictionElement attributeNamed:@"vehicle"] forKey:@"vehicle"];
                [dict setObject:[predictionElement attributeNamed:@"dirTag"] forKey:@"dirTag"];
                [dict setObject:[predictionElement attributeNamed:@"epochTime"] forKey:@"epochTime"];
                
                [predictions addObject:dict];
                dict = nil;
            }
            
            self.predictionMeta = [NSDictionary dictionaryWithDictionary:predictionInfo];
            self.predictions = [NSArray arrayWithArray:predictions];
        }
    } failure:^(NSHTTPURLResponse *response, NSError *err) {
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
