//
//  BSDirectionsModel.m
//  Buster
//
//  Created by Andrew Shepard on 12/30/10.
//  Copyright © 2010-2017 Andrew Shepard. All rights reserved.
//

#import "BSDirectionsModel.h"

#import "BSDirection.h"
#import "BSStop.h"

@interface BSDirectionsModel ()

- (void)unloadStopList;
- (NSString *)archivePathForStop:(NSString *)stop;

@end

@implementation BSDirectionsModel

- (instancetype)init {
    if ((self = [super init])) {
        //
    }
    
    return self;
}

- (NSUInteger)countOfStops {
    return (self.stops).count;
}

- (id)objectInStopsAtIndex:(NSUInteger)index {
    return (self.stops)[index];
}

- (void)getStops:(__unsafe_unretained id *)objects range:(NSRange)range {
    [self.stops getObjects:objects range:range];
}

- (void)requestDirectionsList:(NSString *)stop {
    // TODO: implement
}

- (void)unloadStopList {
    self.stops = nil;
}

- (void)loadStopsForDirection:(NSUInteger)directionIndex {
    NSArray *stops = ((BSDirection *)(self.directions)[directionIndex]).stops;
    NSMutableArray *mStops = [NSMutableArray arrayWithCapacity:20];
    
    for (NSDictionary *stop in stops) {
        BSDirection *aStop = [[BSDirection alloc] init];
        aStop.tag = [stop valueForKey:@"tag"];
        aStop.title = [stop valueForKey:@"title"];
        
        [mStops addObject:aStop];
    }
    
    self.stops = [NSArray arrayWithArray:mStops];
    self.title = ((BSDirection *)(self.directions)[directionIndex]).title;
}

#pragma mark - Disk Access
- (NSString *)pathInDocumentDirectory:(NSString *)aPath {
    NSArray *documentPaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentDirectoryPath = documentPaths[0];
    return [documentDirectoryPath stringByAppendingPathComponent:aPath];
}

- (NSString *)archivePathForStop:(NSString *)stop {
    NSString *filename = [NSString stringWithFormat:@"stops_%@.data", stop];
    return [self pathInDocumentDirectory:filename];
}

@end
