//
//  BSDirection.h
//  Buster
//
//  Created by Andrew Shepard on 1/16/11.
//  Copyright © 2011-2017 Andrew Shepard. All rights reserved.
//

@import Foundation;

@class BSStop;

@interface BSDirection : NSObject <NSCoding>

@property (nonatomic, copy) NSArray<BSStop *> *stops;
@property (nonatomic, copy) NSString *tag;
@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSString *title;

+ (NSDictionary<NSString *, BSDirection *> *)directionsFromData:(NSData *)data;

@end
