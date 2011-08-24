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
    if (error_) return;
    consumedData = [SMXMLDocument documentWithData:consumedData error:&error_];
}

@end
