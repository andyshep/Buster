//
//  BSAppDelegate.m
//  Buster
//
//  Created by Andrew Shepard on 12/15/10.
//  Copyright © 2010-2017 Andrew Shepard. All rights reserved.
//

#import "BSAppDelegate.h"
#import "BSRoutesViewController.h"

@interface BSAppDelegate ()

@property (nonatomic, strong) BSRoutesViewController *routesViewController;

@end

@implementation BSAppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    self.window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    
    self.routesViewController = [[BSRoutesViewController alloc] init];
    self.navigationController = [[UINavigationController alloc] initWithRootViewController:_routesViewController];
    
    [_window setRootViewController:_navigationController];
    [_window makeKeyAndVisible];
    
    return YES;
}

@end
