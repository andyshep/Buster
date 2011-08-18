//
//  BSNetworkOperation.h
//  BSNetwork
//
//  Created by Andrew Shepard on 8/16/11.
//  Copyright 2011 Andrew Shepard. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BSDataRequest.h"


@protocol BSNetworkOperationDelegate
- (void)didConsumeData:(NSData *)data;
@end

@interface BSNetworkOperation : NSOperation {
    id<BSNetworkOperationDelegate> delegate;
    BSDataRequest *dataRequest;
}

@property (assign) id<BSNetworkOperationDelegate> delegate;

- (id)initWithURLRequest:(NSURLRequest *)aURLRequest 
                delegate:(id<BSNetworkOperationDelegate>)aDelegate;
- (id)initWithURLString:(NSString *)aURLString 
                delegate:(id<BSNetworkOperationDelegate>)aDelegate;

- (void)performOperationTasks;

@end
