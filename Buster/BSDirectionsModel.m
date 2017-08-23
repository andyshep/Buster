//
//  BSDirectionsModel.m
//  Buster
//
//  Created by Andrew Shepard on 12/30/10.
//  Copyright © 2010-2017 Andrew Shepard. All rights reserved.
//

#import "BSDirectionsModel.h"

#import "BSRoute.h"
#import "BSDirection.h"
#import "BSStop.h"

@interface BSDirectionsModel ()

@property (nonatomic, copy, readwrite) NSArray<BSStop *> *stops;
@property (nonatomic, copy, readwrite) NSArray *tags;
@property (nonatomic, copy, readwrite) NSArray *titles;

@property (nonatomic, copy, readwrite) NSDictionary<NSString *, BSDirection *> *directions;
@property (nonatomic, copy, readwrite) NSError *error;
@property (nonatomic, copy, readwrite) NSString *title;

@end

@implementation BSDirectionsModel

- (void)requestStopsByRoute:(BSRoute *)route {
    // TODO: check cache first
    
    NSString *urlString = [NSString stringWithFormat:@"http://realtime.mbta.com/developer/api/v2/stopsbyroute?api_key=wX9NwuHnZU2ToO7GmGR9uw&route=%@&format=json", route.routeId];
    NSURL *url = [NSURL URLWithString:urlString];
    
    [[[NSURLSession sharedSession] dataTaskWithURL:url completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        
        dispatch_async(dispatch_get_main_queue(), ^{
            if (data) {
                NSDictionary *directions = [BSDirection directionsFromData:data forRoute:route];
                self.directions = directions;
            }
            
            self.error = error;
        });
        
    }] resume];
}

- (void)loadStopsForDirection:(BSDirection *)direction {
    NSArray<BSStop *> *stops = direction.stops;
    self.stops = stops;
}

- (NSString *)archivePathForStop:(NSString *)stop {
    NSURL *documentsURL = [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
    NSString *filename = [NSString stringWithFormat:@"stops_%@.plist", stop];
    NSURL *pathURL = [documentsURL URLByAppendingPathComponent:filename];
    
    return [pathURL absoluteString];
}

@end
