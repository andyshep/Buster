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

- (void)performOperationTasks {
    [dataRequest fetchData];
    NSData *data = [dataRequest data];
    
    if (!self.isCancelled) {
        
        // return the data back to the main thread
        [delegate performSelectorOnMainThread:@selector(didConsumeData:) 
                                   withObject:data
                                waitUntilDone:YES];
    }
}

#pragma mark - NSOperation

- (void)main {
	
	@try {
		NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];

        [self performOperationTasks];
		
		[pool drain];
	}
	@catch (NSException *e) {
		// an NSOperation cannot throw an exception
		NSLog(@"exception: %@", e);
	}
}

@end
