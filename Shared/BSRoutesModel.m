//
//  BSRoutesModel.m
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

#import "BSRoutesModel.h"
#import "BSRoute.h"

#import "BSMBTARequestOperation.h"
#import "MBTAQueryStringBuilder.h"

@interface BSRoutesModel ()

- (NSString *)routesEndpointsArchivePath;

@end

@implementation BSRoutesModel

- (id)init {
	if ((self = [super init])) {
        //
    }
	
    return self;
}

- (NSUInteger)countOfRoutes {
	return self.routes.count;
}

- (id)objectInRoutesAtIndex:(NSUInteger)index {
	return [_routes objectAtIndex:index];
}

- (void)getRoutes:(__unsafe_unretained id *)objects range:(NSRange)range {
	[_routes getObjects:objects range:range];
}

#pragma mark - Disk Access
- (NSString *)routesEndpointsArchivePath {
    return [[NSBundle mainBundle] pathForResource:@"routes.endpoints" ofType:@"plist"];
}

- (NSString *)pathInDocumentDirectory:(NSString *)aPath {
    NSArray *documentPaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentDirectoryPath = [documentPaths objectAtIndex:0];
    return [documentDirectoryPath stringByAppendingPathComponent:aPath];
}

- (NSString *)routesArchivePath {
    return [self pathInDocumentDirectory:@"routes.data"];
}

- (BOOL)saveChanges {
    return [NSKeyedArchiver archiveRootObject:self.routes toFile:[self routesArchivePath]];
}

#pragma mark - Route List building
- (void)requestRouteList {
    NSDictionary *routeEndpoints = [NSDictionary dictionaryWithContentsOfFile:[self routesEndpointsArchivePath]];
    NSString *cachedFilePath = [self routesArchivePath];
    
    if (self.routes == nil) {
        self.routes = [NSKeyedUnarchiver unarchiveObjectWithFile:cachedFilePath];
    }
    
    if (self.routes == nil) {
        MBTAQueryStringBuilder *builder = [MBTAQueryStringBuilder sharedInstance];
        NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:[builder buildRouteListQuery]]];
        
        BSMBTARequestOperation *operation = [BSMBTARequestOperation MBTARequestOperationWithRequest:request success:^(NSURLRequest *request, NSHTTPURLResponse *response, id object) {
                // get routes
                
        } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *err) {
            self.error = err;
        }];
        
        NSOperationQueue *queue = [[NSOperationQueue alloc] init];
        [queue addOperation:operation];
    }
}

@end
