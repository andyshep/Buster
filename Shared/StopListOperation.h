//
//  StopListOperation.h
//  Buster
//
//  Created by Andrew Shepard on 12/20/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "MBTAQueryStringBuilder.h"

@protocol StopListOperationDelegate

- (void)updateStopList:(NSArray *)data;

@end

@interface StopListOperation : NSOperation {
	id	delegate;
	NSString *routeTitle;
}

@property (assign) id<StopListOperationDelegate> delegate;
@property (nonatomic, retain) NSString *routeTitle;

- (id)initWithDelegate:(id<StopListOperationDelegate>)operationDelegate andTitle:(NSString *)title;

@end
