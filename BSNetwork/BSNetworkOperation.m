//
//  BSNetworkOperation.m
//  BSNetwork
//
//  Created by Andrew Shepard on 8/16/11.
//  Copyright 2011 Andrew Shepard. All rights reserved.
//

#import "BSNetworkOperation.h"


@implementation BSNetworkOperation

@synthesize delegate;

#pragma mark - Initialization

- (id)initWithURLRequest:(NSURLRequest *)aURLRequest 
                delegate:(id<BSNetworkOperationDelegate>)aDelegate {
    if ((self = [super init])) {
        self.delegate = aDelegate;
        consumedData = nil, error_ = nil;
        dataRequest = [[BSDataRequest alloc] initWithURLRequest:aURLRequest];
    }
    
    return self;
}

- (id)initWithURLString:(NSString *)aURLString 
               delegate:(id<BSNetworkOperationDelegate>)aDelegate {
    NSURL *url = [NSURL URLWithString:aURLString];
    NSURLRequest *request = [NSURLRequest requestWithURL:url 
                                             cachePolicy:NSURLRequestReturnCacheDataElseLoad 
                                         timeoutInterval:30];
    return [self initWithURLRequest:request delegate:aDelegate];
}

- (void)dealloc {
    [dataRequest release];
    [super dealloc];
}

#pragma mark - Network Resource Consumption

- (void)consumeData {
    error_ = [dataRequest fetchData];
    
    if (!error_) {
        consumedData = [dataRequest data];
    }
}

#pragma mark - NSOperation

- (BOOL)isConcurrent {
    return YES;
}

- (BOOL)isExecuting {
    return executing_;
}

- (BOOL)isFinished {
    return finished_;
}

- (void)start {
    if( finished_ || [self isCancelled] ) { 
        [self done]; 
        return; 
    }
    
    [self willChangeValueForKey:@"isExecuting"];
    executing_ = YES;
    [self didChangeValueForKey:@"isExecuting"];

    // do the actual work
    [self consumeData];
    
    // call our delegate when complete
    if (!error_) {
        [(NSObject *)delegate performSelectorOnMainThread:@selector(didConsumeData:) 
                                               withObject:consumedData
                                            waitUntilDone:YES];
    }
    else {
        [(NSObject *)delegate performSelectorOnMainThread:@selector(didFailWithError:) 
                                               withObject:error_
                                            waitUntilDone:YES];
    }
    
    // notify any observer this operation is complete
    [self done];
}
    
- (void)done {
    [self willChangeValueForKey:@"isExecuting"];
    [self willChangeValueForKey:@"isFinished"];
    executing_ = NO;
    finished_  = YES;
    [self didChangeValueForKey:@"isFinished"];
    [self didChangeValueForKey:@"isExecuting"];
}

@end
