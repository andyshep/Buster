//
//  BSDataRequest.h
//  BSNetwork
//
//  Created by Andrew Shepard on 8/15/11.
//  Copyright 2011 Andrew Shepard. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BSDataRequest : NSObject {
	NSData *data;
	NSURLRequest *request;
}

@property (nonatomic, assign) NSData *data;
@property (nonatomic, assign) NSURLRequest *request;

- (id)initWithURLRequest:(NSURLRequest *)aURLRequest;
- (id)initWithURLString:(NSString *)aURLString;
- (id)initWithURLString:(NSString *)aURLString 
                timeout:(NSTimeInterval)aTimeoutInterval
            cachePolicy:(NSURLCacheStoragePolicy)aCachePolicy;


- (void)fetchData;

@end
