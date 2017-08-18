//
//  BSDirectionsModel.h
//  Buster
//
//  Created by Andrew Shepard on 12/30/10.
//  Copyright © 2010-2017 Andrew Shepard. All rights reserved.
//

@import Foundation;

@interface BSDirectionsModel : NSObject 

@property (nonatomic, copy) NSArray *stops;
@property (nonatomic, copy) NSArray *tags;
@property (nonatomic, copy) NSArray *titles;

@property (nonatomic, copy) NSArray *directions;
@property (nonatomic, copy) NSError *error;
@property (nonatomic, copy) NSString *title;

- (void)requestDirectionsList:(NSString *)stop;
- (void)loadStopsForDirection:(NSUInteger)directionIndex;

@property (NS_NONATOMIC_IOSONLY, readonly) NSUInteger countOfStops;
- (id)objectInStopsAtIndex:(NSUInteger)index;
- (void)getStops:(__unsafe_unretained id *)objects range:(NSRange)range;

@end
