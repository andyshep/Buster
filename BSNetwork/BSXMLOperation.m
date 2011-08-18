//
//  BSXMLOperation.m
//  BSNetwork
//
//  Created by Andrew Shepard on 8/17/11.
//  Copyright 2011 Andrew Shepard. All rights reserved.
//

#import "BSXMLOperation.h"


@implementation BSXMLOperation

- (id)consumeData {
    consumedData = [super consumeData];
    SMXMLDocument *xml = [SMXMLDocument documentWithData:consumedData error:NULL];
    return xml;
}

@end
