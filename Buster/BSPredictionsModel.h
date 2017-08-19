//
//  BSPredictionsModel.h
//  Buster
//
//  Created by Andrew Shepard on 1/3/11.
//  Copyright © 2011-2017 Andrew Shepard. All rights reserved.
//

@import Foundation;

@class BSStop;

@interface BSPredictionsModel : NSObject

@property (nonatomic, copy, readonly) NSArray *predictions;
@property (nonatomic, copy, readonly) NSDictionary *predictionMeta;
@property (nonatomic, copy, readonly) NSError *error;

- (void)requestPredictionsForStop:(BSStop *)stop;

@end
