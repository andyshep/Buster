//
//  BSPrediction.m
//  Buster
//
//  Created by Andrew Shepard on 8/22/17.
//  Copyright © 2017 Andrew Shepard. All rights reserved.
//

#import "BSPrediction.h"

@implementation BSPrediction

- (instancetype)initWithCoder:(NSCoder *)decoder {
    if (self = [super init]) {
        //
    }
    
    return self;
}

- (void)encodeWithCoder:(NSCoder *)coder {
    
}

+ (NSArray<BSPrediction *> *)predictionsFromData:(NSData *)data {
    NSMutableArray<BSPrediction *> *predictions = [NSMutableArray array];
    
    NSDictionary *json = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
    NSArray<NSDictionary *> *modesJSON = [json objectForKey:@"mode"];
    
    NSString *stopId = [json objectForKey:@"stop_id"];
//    NSString *stopName = [json objectForKey:@"stop_name"];
    
    [modesJSON enumerateObjectsUsingBlock:^(NSDictionary * _Nonnull obj1, NSUInteger idx1, BOOL * _Nonnull stop1) {
        NSArray<NSDictionary *> *routeJSON = [obj1 objectForKey:@"route"];
        
        [routeJSON enumerateObjectsUsingBlock:^(NSDictionary * _Nonnull obj2, NSUInteger idx2, BOOL * _Nonnull stop2) {
            NSString *routeId = [obj2 objectForKey:@"route_id"];
            NSArray<NSDictionary *> *directionJSON = [obj2 objectForKey:@"direction"];
            
            [directionJSON enumerateObjectsUsingBlock:^(NSDictionary * _Nonnull obj3, NSUInteger idx3, BOOL * _Nonnull stop3) {
                NSString *directionName = [obj3 objectForKey:@"direction_name"];
                NSArray<NSDictionary *> *tripJSON = [obj3 objectForKey:@"trip"];
                
                [tripJSON enumerateObjectsUsingBlock:^(NSDictionary * _Nonnull obj4, NSUInteger idx4, BOOL * _Nonnull stop4) {
                    
//                    NSString *tripId = [obj4 objectForKey:@"trip_id"];
                    NSString *tripName = [obj4 objectForKey:@"trip_name"];
//                    NSString *scheduledArrival = [obj4 objectForKey:@"sch_arr_dt"];
                    
                    BSPrediction *prediction = [[BSPrediction alloc] init];
                    prediction.routeId = routeId;
                    prediction.stopId = stopId;
                    prediction.direction = directionName;
                    
                    prediction.name = tripName;
                    
                    [predictions addObject:prediction];
                }];
            }];
        }];
    }];
    
    return [NSArray arrayWithArray:predictions];
}

- (NSString *)description {
    return [NSString stringWithFormat:@"%@", self.name];
}

@end
