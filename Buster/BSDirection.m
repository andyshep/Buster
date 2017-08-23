//
//  BSDirection.m
//  Buster
//
//  Created by Andrew Shepard on 1/16/11.
//  Copyright © 2011-2017 Andrew Shepard. All rights reserved.
//

#import "BSDirection.h"

#import "BSRoute.h"
#import "BSStop.h"

@implementation BSDirection

- (instancetype)initWithCoder:(NSCoder *)coder {
    if (self = [super init]) {
        self.tag = [coder decodeObjectForKey:@"tag"];
        self.name = [coder decodeObjectForKey:@"name"];
        self.title = [coder decodeObjectForKey:@"title"];
        self.stops = [coder decodeObjectForKey:@"stops"];
    }
    
    return self;
}

- (void)encodeWithCoder:(NSCoder *)coder {
    [coder encodeObject:self.tag forKey:@"tag"];
    [coder encodeObject:self.name forKey:@"name"];
    [coder encodeObject:self.title forKey:@"title"];
    [coder encodeObject:self.stops forKey:@"stops"];
}

+ (NSDictionary<NSString *, BSDirection *> *)directionsFromData:(NSData *)data forRoute:(BSRoute *)route {
    NSMutableDictionary<NSString *, BSDirection *> *directions = [NSMutableDictionary dictionary];
    
    NSDictionary *json = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
    NSArray<NSDictionary *> *directionsJSON = [json objectForKey:@"direction"];
    
    [directionsJSON enumerateObjectsUsingBlock:^(NSDictionary * _Nonnull obj1, NSUInteger idx, BOOL * _Nonnull s) {
        NSString *directionId = [obj1 objectForKey:@"direction_id"];
        NSString *directionName = [obj1 objectForKey:@"direction_name"];
        
        BSDirection *direction = [[BSDirection alloc] init];
        direction.name = directionName;
        direction.tag = directionId;
        
        NSArray<NSDictionary *> *stopsJSON = [obj1 objectForKey:@"stop"];
        NSMutableArray<BSStop *> *stops = [NSMutableArray array];
        
        [stopsJSON enumerateObjectsUsingBlock:^(NSDictionary * _Nonnull obj2, NSUInteger idx, BOOL * _Nonnull s) {
            NSString *stopName = [obj2 objectForKey:@"stop_name"];
            NSString *stopId = [obj2 objectForKey:@"stop_id"];
            
            BSStop *stop = [[BSStop alloc] init];
            stop.stopId = stopId;
            stop.title = stopName;
            stop.routeId = route.routeId;
            
            [stops addObject:stop];
        }];
        
        direction.stops = [NSArray arrayWithArray:stops];
        
        [directions setObject:direction forKey:directionName];
    }];
    
    return [NSDictionary dictionaryWithDictionary:directions];
}

@end
