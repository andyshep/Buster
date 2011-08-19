//
//  BSNetworkOperation.h
//  BSNetwork
//
//  Created by Andrew Shepard on 8/16/11.
//  Copyright 2011 Andrew Shepard. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BSDataRequest.h"


@protocol BSNetworkOperationDelegate <NSObject>
- (void)didConsumeData:(id)consumedData;
@end

@interface BSNetworkOperation : NSOperation {
    id<BSNetworkOperationDelegate> delegate;
    id consumedData;
    
    BSDataRequest *dataRequest;
    
    BOOL executing_, finished_;
}

@property (assign) id<BSNetworkOperationDelegate> delegate;

- (id)initWithURLRequest:(NSURLRequest *)aURLRequest 
                delegate:(id<BSNetworkOperationDelegate>)aDelegate;
- (id)initWithURLString:(NSString *)aURLString 
                delegate:(id<BSNetworkOperationDelegate>)aDelegate;

- (void)consumeData;
- (void)done;

@end
