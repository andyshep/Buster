//
//  BSMBTARequestOperation.h
//  Buster
//
//  Created by Andrew Shepard on 3/24/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

@import Foundation;

@interface BSMBTARequestOperation : NSOperation

- (instancetype)initWithRequest:(NSURLRequest *)urlRequest NS_DESIGNATED_INITIALIZER;

+ (BSMBTARequestOperation *)MBTARequestOperationWithRequest:(NSURLRequest *)urlRequest
                                                        success:(void (^)(NSURLRequest *request, NSHTTPURLResponse *response, id object))success
                                                        failure:(void (^)(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error))failure;

@end