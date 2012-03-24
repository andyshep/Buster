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

@implementation BSRoutesModel

@synthesize routes = _routes;
@synthesize error = _error;

#pragma mark -
#pragma mark Lifecycle

- (id) init {
	if ((self = [super init])) {
		self.routes = nil, self.error = nil;
        // [[AFNetworkActivityIndicatorManager sharedManager] setEnabled:YES];
    }
	
    return self;
}

- (void) dealloc {
    [_routes release];
    [_error release];
    [super dealloc];
}

#pragma mark -
#pragma mark Model KVC

// our view controller uses these to display table data

- (NSUInteger)countOfRoutes {
	return [self.routes count];
}

- (id)objectInRoutesAtIndex:(NSUInteger)index {
	return [self.routes objectAtIndex:index];
}

- (void)getRoutes:(id *)objects range:(NSRange)range {
	[self.routes getObjects:objects range:range];
}

#pragma mark - Disk Access

- (NSString *)routesEndpointsArchivePath {
    return [[NSBundle mainBundle] pathForResource:@"routes.endpoints" ofType:@"plist"];
}

- (NSString *)pathInDocumentDirectory:(NSString *)aPath {
    NSArray *documentPaths =
    NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,
                                        NSUserDomainMask,
                                        YES);
    
    NSString *documentDirectoryPath = [documentPaths objectAtIndex:0];
    
    return [documentDirectoryPath stringByAppendingPathComponent:aPath];
}

- (NSString *)routesArchivePath {
    return [self pathInDocumentDirectory:@"routes.data"];
}

- (BOOL)saveChanges
{
    // returns success or failure
    return [NSKeyedArchiver archiveRootObject:self.routes
                                       toFile:[self routesArchivePath]];
}

#pragma mark -
#pragma mark Route List building

- (void)requestRouteList {
    NSDictionary *routeEndpoints = [NSDictionary dictionaryWithContentsOfFile:[self routesEndpointsArchivePath]];
    NSString *cachedFilePath = [self routesArchivePath];
    
    if (self.routes == nil) {
        NSLog(@"loading from disk...");
        self.routes = [NSKeyedUnarchiver unarchiveObjectWithFile:cachedFilePath];
    }
    
    if (self.routes == nil) {
        NSLog(@"loading from the intertubes...");
        MBTAQueryStringBuilder *_builder = [MBTAQueryStringBuilder sharedInstance];
        NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:[_builder buildRouteListQuery]]];

        NSLog(@"routeList: %@", [_builder buildRouteListQuery]);
        
        BSMBTARequestOperation *operation = [BSMBTARequestOperation MBTARequestOperationWithRequest:request success:^(NSURLRequest *request, NSHTTPURLResponse *response, id object) {
            NSError *error_ = nil;
            SMXMLDocument *xml = [SMXMLDocument documentWithData:object error:&error_];
            
            // make sure there was no error parsing the xml
            if (!error_) {
                NSMutableArray *mRouteList = [NSMutableArray arrayWithCapacity:20];
                
                for (SMXMLElement *routeElement in [xml.root childrenNamed:@"route"]) {
                    
                    BSRoute *route = [[BSRoute alloc] init];
                    
                    route.title = [routeElement attributeNamed:@"title"];
                    route.tag = [routeElement attributeNamed:@"tag"];
                    
                    NSString *endpoints = [routeEndpoints objectForKey:route.tag];
                    
                    if (endpoints != nil) {
                        route.endpoints = endpoints;
                    }
                    
                    [mRouteList addObject:route];
                    [route release];
                }
                
                NSArray *aRouteList = [NSArray arrayWithArray:mRouteList];
                self.routes = aRouteList;
                
                // save the routes the disk for next time
                [NSKeyedArchiver archiveRootObject:aRouteList toFile:cachedFilePath];
            }
        } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *err) {
            self.error = err;
        }];
        
        NSOperationQueue *queue = [[[NSOperationQueue alloc] init] autorelease];
        [queue addOperation:operation];
    }
}

@end
