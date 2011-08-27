//
//  MapViewController.m
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

#import "MapViewController.h"

@implementation MapViewController

@synthesize toolbar, popoverController;
@synthesize vehicle, route, time;
@synthesize mapView;

#pragma mark -
#pragma mark View lifecycle

- (void)viewDidLoad {
    [super viewDidLoad];
    
    model_ = [[VehicleLocationModel alloc] init];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
	[model_ addObserver:self 
			forKeyPath:@"location" 
			   options:(NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld) 
			   context:NULL];
    
    [model_ addObserver:self 
             forKeyPath:@"error" 
                options:(NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld) 
                context:NULL];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    return interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown;
}

- (void)configureView {	
	self.vehicle = nil;
	self.route = nil;
	self.time = nil;
}

#pragma mark - Split view support

- (void)splitViewController: (UISplitViewController*)svc willHideViewController:(UIViewController *)aViewController withBarButtonItem:(UIBarButtonItem*)barButtonItem forPopoverController: (UIPopoverController*)pc {
    
    barButtonItem.title = NSLocalizedString(@"Routes", @"routes popover bar button title");
    NSMutableArray *items = [[toolbar items] mutableCopy];
    [items insertObject:barButtonItem atIndex:0];
    [toolbar setItems:items animated:YES];
    [items release];
    self.popoverController = pc;
}

- (void)splitViewController: (UISplitViewController*)svc willShowViewController:(UIViewController *)aViewController invalidatingBarButtonItem:(UIBarButtonItem *)barButtonItem {
    
    NSMutableArray *items = [[toolbar items] mutableCopy];
    [items removeObjectAtIndex:0];
    [toolbar setItems:items animated:YES];
    [items release];
    self.popoverController = nil;
}

#pragma mark - MKMapViewDelegate methods

- (void)mapView:(MKMapView *)mView didAddAnnotationViews:(NSArray *)views {
	// zoom and center to where the annotation is placed.
	MKAnnotationView *annotationView = [views objectAtIndex:0];
	id <MKAnnotation> mp = [annotationView annotation];
	MKCoordinateRegion region = MKCoordinateRegionMakeWithDistance([mp coordinate], 250, 250);
	[mView setRegion:region animated:YES];
}

#pragma mark - Model Observing

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
    
    if ([keyPath compare:@"location"] == 0) {
        NSDictionary *locData = [change objectForKey:NSKeyValueChangeNewKey];
        
        CLLocationCoordinate2D location;
        location.latitude = [[locData objectForKey:@"latitude"] floatValue];
        location.longitude = [[locData objectForKey:@"longitude"] floatValue];
        
        MKCoordinateSpan span;
        span.latitudeDelta = 0.00015f;
        span.longitudeDelta = 0.00015f;
        
        MKCoordinateRegion region;
        region.span = span;
        region.center = location;
        
        VehicleLocationAnnotation *vehicleLocation = [[VehicleLocationAnnotation alloc] initWithCoordinate:location];
        
        [mapView setRegion:region animated:YES];
        [mapView regionThatFits:region];
        [mapView addAnnotation:vehicleLocation];
        
        [vehicleLocation release];
    }
    else if ([keyPath compare:@"error"] == 0) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Error", @"error alert view title") 
                                                        message:[[model_ error] localizedDescription] 
                                                       delegate:nil 
                                              cancelButtonTitle:NSLocalizedString(@"OK", @"ok button title") 
                                              otherButtonTitles:nil];
        [alert show];
        [alert release];
    }
}

#pragma mark - Location Management

- (void)dropPinForLocation {	
	[model_ requestLocationOfVehicle:vehicle runningRoute:route atEpochTime:time];
}

- (void)updateLocation {
    
}

#pragma mark - Memory management

- (void)dealloc {
    [popoverController release];
    [toolbar release];
    [mapView release];
    
    [model_ removeObserver:self forKeyPath:@"location"];
    [model_ removeObserver:self forKeyPath:@"error"];
    [model_ release];
    
    [super dealloc];
}

@end