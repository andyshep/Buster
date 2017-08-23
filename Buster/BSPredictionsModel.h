//
//  BSPredictionsModel.h
//  Buster
//
//  Created by Andrew Shepard on 1/3/11.
//  Copyright © 2011-2017 Andrew Shepard. All rights reserved.
//

@import Foundation;

@class BSStop;
@class BSDirection;
@class BSPrediction;

@interface BSPredictionsModel : NSObject

@property (nonnull, nonatomic, copy, readonly) NSArray<BSPrediction *> *predictions;
@property (nonnull, nonatomic, copy, readonly) NSDictionary *predictionMeta;
@property (nullable, nonatomic, copy, readonly) NSError *error;

- (void)requestPredictionsForStop:(BSStop * _Nonnull)stop direction:(BSDirection * _Nonnull)direction;

@end
