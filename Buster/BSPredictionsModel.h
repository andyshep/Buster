//
//  BSPredictionsModel.h
//  Buster
//
//  Created by Andrew Shepard on 1/3/11.
//  Copyright © 2011-2017 Andrew Shepard. All rights reserved.
//

@import Foundation;

@interface BSPredictionsModel : NSObject

@property (nonatomic, copy) NSArray *predictions;
@property (nonatomic, copy) NSDictionary *predictionMeta;
@property (nonatomic, copy) NSError *error;

- (void)requestPredictionsForRoute:(NSString *)route andStop:(NSString *)stop;

@property (NS_NONATOMIC_IOSONLY, readonly) NSUInteger countOfPredictions;
- (id)objectInPredictionsAtIndex:(NSUInteger)index;
- (void)getPredictions:(__unsafe_unretained id *)objects range:(NSRange)range;

@end
