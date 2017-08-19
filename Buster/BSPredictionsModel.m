//
//  BSPredictionsModel.m
//  Buster
//
//  Created by Andrew Shepard on 1/3/11.
//  Copyright © 2011-2017 Andrew Shepard. All rights reserved.
//

#import "BSPredictionsModel.h"

@interface BSPredictionsModel ()

- (void)unloadPredictions;

@end

@implementation BSPredictionsModel

- (instancetype) init {
    if ((self = [super init])) {
        //
    }
    
    return self;
}

#pragma mark - KVC
- (NSUInteger)countOfPredictions {
    return (self.predictions).count;
}

- (id)objectInPredictionsAtIndex:(NSUInteger)index {
    return (self.predictions)[index];
}

- (void)getPredictions:(__unsafe_unretained id *)objects range:(NSRange)range {
    [self.predictions getObjects:objects range:range];
}

#pragma mark - Predictions building
- (void)requestPredictionsForRoute:(NSString *)route andStop:(NSString *)stop {
    NSLog(@"requesting predictions for %@ at %@", route, stop);
    
    // TODO: implement
}

- (void)unloadPredictions {
    self.predictions = nil;
    self.predictionMeta = nil;
}

@end
