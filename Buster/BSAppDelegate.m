//
//  BSAppDelegate.m
//  Buster
//
//  Created by Andrew Shepard on 12/15/10.
//  Copyright © 2010-2017 Andrew Shepard. All rights reserved.
//

#import "BSAppDelegate.h"

#import "BSRoutesViewController.h"
#import "BSMapViewController.h"

@interface BSAppDelegate ()

@property (nonatomic, strong) BSRoutesViewController *routesViewController;
@property (nonatomic, strong) BSMapViewController *mapViewController;

@end

@implementation BSAppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    self.window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    
    self.routesViewController = [[BSRoutesViewController alloc] init];
    self.navigationController = [[UINavigationController alloc] initWithRootViewController:_routesViewController];
    
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
        // only create a map and split view for the iPad
        self.mapViewController = [[BSMapViewController alloc] initWithNibName:@"MapView_iPad" bundle:nil];
        self.splitViewController = [[UISplitViewController alloc] init];
        
        _splitViewController.viewControllers = @[_navigationController, _mapViewController];
        _splitViewController.delegate = _mapViewController;
        
        // split view is root on iPad
        _window.rootViewController = _splitViewController;
    } else {
        // otherwise nav controller is root on iPhone
        _window.rootViewController = _navigationController;
    }
    
    [_window makeKeyAndVisible];
    
    return YES;
}

- (void)applicationDidReceiveMemoryWarning:(UIApplication *)application {
    NSLog(@"applicationDidReceiveMemoryWarning");
}

//- (void)loadPredictionsForVehicle:(NSString *)vehicle runningRoute:(NSString *)route atEpochTime:(NSString *)time {
//    NSLog(@"loadPredictionsForVehicle: %@ runningRoute: %@ atEpochTime: %@", vehicle, route, time);
//    
//    mapViewController.vehicle = vehicle;
//    mapViewController.route = route;
//    mapViewController.time = time;
//    
//    [mapViewController dropPinForLocation];
//}

@end
