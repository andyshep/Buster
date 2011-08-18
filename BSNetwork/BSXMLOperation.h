//
//  BSXMLOperation.h
//  BSNetwork
//
//  Created by Andrew Shepard on 8/17/11.
//  Copyright 2011 Andrew Shepard. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BSNetworkOperation.h"
#import "SMXMLDocument.h"


@protocol BSXMLOperationDelegate
- (void)didConsumeXML:(SMXMLDocument *)xml;
@end

@interface BSXMLOperation : BSNetworkOperation {
    
}

@end
