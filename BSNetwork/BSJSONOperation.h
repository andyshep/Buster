//
//  BSJSONOperation.h
//  BSNetwork
//
//  Created by Andrew Shepard on 8/17/11.
//  Copyright 2011 Andrew Shepard. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BSNetworkOperation.h"
#import "JSONKit.h"

@protocol BSJSONOperationDelegate
- (void)didConsumeJSON:(id)json;
@end

@interface BSJSONOperation : BSNetworkOperation {
    
}

@end
