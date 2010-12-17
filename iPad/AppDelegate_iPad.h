//
//  AppDelegate_iPad.h
//  Buster
//
//  Created by Andrew Shepard on 12/15/10.
//  Copyright __MyCompanyName__ 2010. All rights reserved.
//


@class RootViewController;
@class DetailViewController;

@interface AppDelegate_iPad : NSObject <UIApplicationDelegate> {
    UIWindow *window;
    
    UISplitViewController *splitViewController;
    
    RootViewController *rootViewController;
    DetailViewController *detailViewController;
}

@property (nonatomic, retain) IBOutlet UIWindow *window;

@property (nonatomic, retain) IBOutlet UISplitViewController *splitViewController;
@property (nonatomic, retain) IBOutlet RootViewController *rootViewController;
@property (nonatomic, retain) IBOutlet DetailViewController *detailViewController;

@end

