//
//  BSRoutesModel.h
//  Buster
//
//  Created by Andrew Shepard on 12/30/10.
//  Copyright © 2010-2011 Andrew Shepard. All rights reserved.
//

@import Foundation;

@class BSRoute;

@interface BSRoutesModel : NSObject

@property (nonatomic, copy, readonly) NSArray<BSRoute *> *routes;
@property (nonatomic, copy, readonly) NSError *error;

- (void)requestRouteList;

@end
