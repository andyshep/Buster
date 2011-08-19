//
//  BSXMLOperation.m
//  BSNetwork
//
//  Created by Andrew Shepard on 8/17/11.
//  Copyright 2011 Andrew Shepard. All rights reserved.
//

#import "BSXMLOperation.h"


@implementation BSXMLOperation

- (void)consumeData {
    [super consumeData];
    NSError *error;
    consumedData = [SMXMLDocument documentWithData:consumedData error:&error];
}

@end
