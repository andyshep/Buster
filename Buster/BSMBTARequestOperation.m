//
//  BSMBTARequestOperation.m
//  Buster
//
//  Created by Andrew Shepard on 3/24/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "BSMBTARequestOperation.h"

@implementation BSMBTARequestOperation

- (instancetype)initWithRequest:(NSURLRequest *)urlRequest {
    if ((self = [super init])) {
        //
    }
    
    return self;
}

+ (BSMBTARequestOperation *)MBTARequestOperationWithRequest:(NSURLRequest *)urlRequest success:(void (^)(NSURLRequest *, NSHTTPURLResponse *, id))success failure:(void (^)(NSURLRequest *, NSHTTPURLResponse *, NSError *))failure {
    BSMBTARequestOperation *requestOperation = [[BSMBTARequestOperation alloc] initWithRequest:urlRequest];
//    [requestOperation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
//        if (success) {
//            success(operation.request, operation.response, responseObject);
//        }
//    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
//        if (failure) {
//            failure(operation.request, operation.response, error);
//        }
//    }];
    
    return requestOperation;
}

+ (NSSet *)acceptableContentTypes {
    return [NSSet setWithObjects:@"application/xml", @"text/xml", nil];
}

@end