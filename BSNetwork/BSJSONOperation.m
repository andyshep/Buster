//
//  BSJSONOperation.m
//  BSNetworkExample
//
//  Created by Andrew Shepard on 8/17/11.
//  Copyright 2011 Andrew Shepard. All rights reserved.
//

#import "BSJSONOperation.h"


@implementation BSJSONOperation

- (void)performOperationTasks {
    [dataRequest fetchData];
    NSData *data = [dataRequest data];
    NSError *error;
    id json = nil;
    json = [[JSONDecoder decoder] objectWithData:data error:&error];
    
    // TODO: check error
    
    if (!self.isCancelled) {
        
        // return the data back to the main thread
        [delegate performSelectorOnMainThread:@selector(didConsumeJSON:) 
                                   withObject:json
                                waitUntilDone:YES];
    }
}

@end
