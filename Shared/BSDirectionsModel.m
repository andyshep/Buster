//
//  BSDirectionsModel.m
//  Buster
//
//  Created by andyshep on 12/30/10.
//
//  Copyright (c) 2010-2011 Andrew Shepard
// 
//  Permission is hereby granted, free of charge, to any person obtaining a copy
//  of this software and associated documentation files (the "Software"), to deal
//  in the Software without restriction, including without limitation the rights
//  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//  copies of the Software, and to permit persons to whom the Software is
//  furnished to do so, subject to the following conditions:
// 
//  The above copyright notice and this permission notice shall be included in
//  all copies or substantial portions of the Software.
// 
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
//  THE SOFTWARE.
//

#import "BSDirectionsModel.h"

#import "BSDirection.h"
#import "BSStop.h"

#import "BSMBTARequestOperation.h"
#import "MBTAQueryStringBuilder.h"

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
    // TODO: implement stops caching
    
    if (self.stops == nil) {
        NSLog(@"loading stops from the intertubes...");
        
        MBTAQueryStringBuilder *builder = [MBTAQueryStringBuilder sharedInstance];
        NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:[builder buildRouteConfigQuery:stop]]];
        
        BSMBTARequestOperation *operation = [BSMBTARequestOperation MBTARequestOperationWithRequest:request success:^(NSURLRequest *request, NSHTTPURLResponse *response, id object) {
                // get directions
            
        } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error) {
            // TODO: handle failure
        }];
        
        NSOperationQueue *queue = [[NSOperationQueue alloc] init];
        [queue addOperation:operation];
    }
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
