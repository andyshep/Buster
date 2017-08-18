//
//  BSDirection.h
//  Buster
//
//  Created by Andrew Shepard on 1/16/11.
//  Copyright © 2011-2017 Andrew Shepard. All rights reserved.
//

@import Foundation;

@interface BSDirection : NSObject <NSCoding>

@property (nonatomic, copy) NSArray *stops;

@property (nonatomic, copy) NSString *tag;
@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSString *title;

@end
