//
//  AppDelegate_iPhone.h
//  Buster
//
//  Created by Andrew Shepard on 12/15/10.
//  Copyright __MyCompanyName__ 2010. All rights reserved.
//

#import "MapViewController.h"


@interface AppDelegate_iPhone : NSObject <UIApplicationDelegate> {
    UIWindow *window;
	MapViewController *mapViewController;
}

@property (nonatomic, retain) IBOutlet UIWindow *window;
@property (nonatomic, retain) MapViewController *mapViewController;

@end

