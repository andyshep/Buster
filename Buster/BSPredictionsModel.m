//
//  BSPredictionsModel.m
//  Buster
//
//  Created by Andrew Shepard on 1/3/11.
//  Copyright © 2011-2017 Andrew Shepard. All rights reserved.
//

#import "BSPredictionsModel.h"
#import "BSStop.h"

@interface BSPredictionsModel ()

@property (nonatomic, copy, readwrite) NSArray *predictions;
@property (nonatomic, copy, readwrite) NSDictionary *predictionMeta;
@property (nonatomic, copy, readwrite) NSError *error;

@end

@implementation BSPredictionsModel

- (void)requestPredictionsForStop:(BSStop *)stop {
    NSString *urlString = [NSString stringWithFormat:@"http://realtime.mbta.com/developer/api/v2/predictionsbystop?api_key=wX9NwuHnZU2ToO7GmGR9uw&stop=%@&format=json", stop.stopId];
    NSURL *url = [NSURL URLWithString:urlString];
    
    [[[NSURLSession sharedSession] dataTaskWithURL:url completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        dispatch_async(dispatch_get_main_queue(), ^{
            if (data) {
                NSLog(@"%@", data);
            }
            
            self.error = error;
        });
    }] resume];
}

@end
