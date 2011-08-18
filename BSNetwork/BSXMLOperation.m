//
//  BSXMLOperation.m
//  BSNetwork
//
//  Created by Andrew Shepard on 8/17/11.
//  Copyright 2011 Andrew Shepard. All rights reserved.
//

#import "BSXMLOperation.h"


@implementation BSXMLOperation

- (void)performOperationTasks {
    [dataRequest fetchData];
    NSData *data = [dataRequest data];
    SMXMLDocument *xml = [SMXMLDocument documentWithData:data error:NULL];
    
    if (!self.isCancelled) {
        
        // return the data back to the main thread
        [delegate performSelectorOnMainThread:@selector(didConsumeData:) 
                                   withObject:xml
                                waitUntilDone:YES];
    }
}

@end
