//
//  BSStop.h
//  Buster
//
//  Created by Andrew Shepard on 1/16/11.
//  Copyright © 2011-2017 Andrew Shepard. All rights reserved.
//

@import Foundation;

@interface BSStop : NSObject <NSCoding>

@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *tag;
@property (nonatomic, copy) NSString *directionTag;

@property (nonatomic, copy) NSString *routeNumber;
@property (nonatomic, copy) NSString *stopId;

@property (nonatomic, copy) NSString *latitude;
@property (nonatomic, copy) NSString *longitude;

@end
