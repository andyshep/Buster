//
//  BSDirectionsModel.h
//  Buster
//
//  Created by Andrew Shepard on 12/30/10.
//  Copyright © 2010-2017 Andrew Shepard. All rights reserved.
//

@import Foundation;

@class BSStop;
@class BSDirection;

@interface BSDirectionsModel : NSObject 

@property (nonatomic, copy, readonly) NSArray<BSStop *> *stops;
@property (nonatomic, copy, readonly) NSArray *tags;
@property (nonatomic, copy, readonly) NSArray *titles;

@property (nonatomic, copy, readonly) NSDictionary<NSString *, BSDirection *> *directions;
@property (nonatomic, copy, readonly) NSError *error;
@property (nonatomic, copy, readonly) NSString *title;

- (void)requestDirectionsForStop:(NSString *)stop;
- (void)loadStopsForDirection:(BSDirection *)direction;

@end
