//
//  BSDataRequest.m
//  BSNetwork
//
//  Created by Andrew Shepard on 8/15/11.
//  Copyright 2011 Andrew Shepard. All rights reserved.
//

#import "BSDataRequest.h"


@implementation BSDataRequest

@synthesize data, request;

#pragma mark - Initialization and memory mangement

- (id)initWithURLRequest:(NSURLRequest *)aURLRequest {
    
    if ((self = [super init])) {
        self.request = aURLRequest;
        self.data = nil;
    }
    
    return self;
}

- (id)initWithURLString:(NSString *)aURLString {
    
    // create a request and pass it along
    NSURL *url_ = [NSURL URLWithString:aURLString];
    NSURLRequest *request_ = [NSURLRequest requestWithURL:url_ cachePolicy:NSURLRequestReturnCacheDataElseLoad timeoutInterval:30];
    return [self initWithURLRequest:request_];
}

- (id)initWithURLString:(NSString *)aURLString 
                timeout:(NSTimeInterval)aTimeoutInterval
            cachePolicy:(NSURLCacheStoragePolicy)aCachePolicy {
    
    // create a request, set the timeout and cache, and pass it along
    NSURL *url_ = [NSURL URLWithString:aURLString];
    NSURLRequest *request_ = [NSURLRequest requestWithURL:url_ cachePolicy:aCachePolicy timeoutInterval:aTimeoutInterval];
    return [self initWithURLRequest:request_];
}

- (void)dealloc {
    [request release];
    [data release];
    [super dealloc];
}

- (NSError *)fetchData {
    NSHTTPURLResponse *response = nil;
    NSError *error = nil;
    NSData *reqData = nil;
    reqData = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&error];
    
    if ([response statusCode] >= 400) {
        NSLog(@"Connection failed with status code: %d", [response statusCode]);
    }
    else if (error && [[error domain] compare:@"NSURLErrorDomain"] == 0) {
        NSLog(@"Connection did fail with error message: %@", [error localizedDescription]);    
    }
    
    if (reqData) {
        self.data  = reqData;
    }
    
    return error;
}

@end
