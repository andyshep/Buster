//
//  BSRoutesModel.m
//  Buster
//
//  Created by Andrew Shepard on 12/30/10.
//  Copyright © 2010-2017 Andrew Shepard. All rights reserved.
//

#import "BSRoutesModel.h"
#import "BSRoute.h"

@interface BSRoutesModel ()

@property (nonatomic, copy, readwrite) NSArray<BSRoute *> *routes;
@property (nonatomic, copy, readwrite) NSError *error;

@end

@implementation BSRoutesModel

- (void)requestRouteList {
    NSString *cachedFilePath = [self routesArchivePath];
    
    if (self.routes == nil) {
        self.routes = [NSKeyedUnarchiver unarchiveObjectWithFile:cachedFilePath];
    }
    
    if (self.routes == nil) {
        // fetch routes
        // if error, set self.error
        // otherwise, set self.routes
        
        NSURL *url = [NSURL URLWithString:@"http://realtime.mbta.com/developer/api/v2/routes?api_key=wX9NwuHnZU2ToO7GmGR9uw&format=json"];
        [[[NSURLSession sharedSession] dataTaskWithURL:url completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
            if (data) {
                // parse data
                NSLog(@"data: %@", data);
            }
            
            self.error = error;
        }] resume];
    } 
}

#pragma mark - Private

- (BOOL)saveChanges {
    return [NSKeyedArchiver archiveRootObject:self.routes toFile:[self routesArchivePath]];
}

- (NSString *)routesArchivePath {
    NSURL *documentsURL = [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
    NSURL *pathURL = [documentsURL URLByAppendingPathComponent:@"routes.plist"];
    
    return [pathURL absoluteString];
}

@end
