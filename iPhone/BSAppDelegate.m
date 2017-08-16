//
//  BSAppDelegate.m
//  Buster
//
//  Created by andyshep on 12/15/10.
//
//  Copyright (c) 2010 Andrew Shepard
// 
//  Permission is hereby granted, free of charge, to any person obtaining a copy
//  of this software and associated documentation files (the "Software"), to deal
//  in the Software without restriction, including without limitation the rights
//  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//  copies of the Software, and to permit persons to whom the Software is
//  furnished to do so, subject to the following conditions:
// 
//  The above copyright notice and this permission notice shall be included in
//  all copies or substantial portions of the Software.
// 
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
//  THE SOFTWARE.
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
