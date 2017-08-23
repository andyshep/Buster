//
//  BSDirection.h
//  Buster
//
//  Created by Andrew Shepard on 1/16/11.
//  Copyright © 2011-2017 Andrew Shepard. All rights reserved.
//

@import Foundation;

@class BSRoute;
@class BSStop;

@interface BSDirection : NSObject <NSCoding>

@property (nonnull, nonatomic, copy) NSArray<BSStop *> *stops;
@property (nonnull, nonatomic, copy) NSString *tag;
@property (nonnull, nonatomic, copy) NSString *name;
@property (nonnull, nonatomic, copy) NSString *title;

+ (NSDictionary<NSString *, BSDirection *> * _Nonnull)directionsFromData:(NSData * _Nonnull)data forRoute:(BSRoute * _Nonnull)route;

@end
