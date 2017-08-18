//
//  BSRoute.m
//  Buster
//
//  Created by Andrew Shepard on 1/16/11.
//  Copyright © 2011-2017 Andrew Shepard. All rights reserved.
//

#import "BSRoute.h"

@implementation BSRoute

- (instancetype)initWithCoder:(NSCoder *)coder {
    if (self = [super init]) {
        self.name = [coder decodeObjectForKey:@"name"];
        self.routeId = [coder decodeObjectForKey:@"routeId"];
//        self.stops = [coder decodeObjectForKey:@"stops"];
//        self.endpoints = [coder decodeObjectForKey:@"endpoints"];
    }
    
    return self;
}
     
- (void)encodeWithCoder:(NSCoder *)coder {
    [coder encodeObject:self.name forKey:@"name"];
    [coder encodeObject:self.routeId forKey:@"routeId"];
//    [coder encodeObject:self.stops forKey:@"stops"];
//    [coder encodeObject:self.endpoints forKey:@"endpoints"];
}

+ (NSArray<BSRoute *> *)routesFromData:(NSData *)data {
    NSMutableArray<BSRoute *> *routes = [NSMutableArray array];
    
    NSDictionary *json = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
    NSArray<NSDictionary *> *modesJSON = [json objectForKey:@"mode"];
    
    [modesJSON enumerateObjectsUsingBlock:^(NSDictionary * _Nonnull mode, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([[mode objectForKey:@"mode_name"] isEqualToString:@"Bus"]) {
            NSArray<NSDictionary *> *routesJSON = [mode objectForKey:@"route"];
            
            [routesJSON enumerateObjectsUsingBlock:^(NSDictionary * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                if ([[obj objectForKey:@"route_hide"] isEqualToString:@"true"] == false) {
                    NSString *name = [obj objectForKey:@"route_name"];
                    NSString *routeId = [obj objectForKey:@"route_id"];
                    
                    BSRoute *route = [[BSRoute alloc] init];
                    route.name = name;
                    route.routeId = routeId;
                    
                    [routes addObject:route];
                }
            }];
            
            *stop = YES;
        }
    }];
    
    return [NSArray arrayWithArray:routes];
}

@end
