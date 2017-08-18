//
//  BSRoute.h
//  Buster
//
//  Created by Andrew Shepard on 1/16/11.
//  Copyright © 2011-2017 Andrew Shepard. All rights reserved.
//

@import Foundation;

@interface BSRoute : NSObject <NSCoding>

@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSString *routeId;

//@property (nonatomic, copy) NSString *endpoints;
//@property (nonatomic, copy) NSArray *stops;

+ (NSArray<BSRoute *> *)routesFromData:(NSData *)data;

@end
