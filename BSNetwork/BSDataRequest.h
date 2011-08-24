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

@property (retain) NSData *data;
@property (retain) NSURLRequest *request;

- (id)initWithURLRequest:(NSURLRequest *)aURLRequest;
- (id)initWithURLString:(NSString *)aURLString;
- (id)initWithURLString:(NSString *)aURLString 
                timeout:(NSTimeInterval)aTimeoutInterval
            cachePolicy:(NSURLCacheStoragePolicy)aCachePolicy;


- (NSError *)fetchData;

@end
