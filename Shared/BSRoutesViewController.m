//
//  BSRoutesViewController.m
//  Buster
//
//  Created by andyshep on 12/15/10.
//
//  Copyright (c) 2010-2011 Andrew Shepard
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

#import "BSRoutesViewController.h"


@implementation BSRoutesViewController

@synthesize tableView = _tableView;
@synthesize bottomToolbar = _bottomToolbar;
@synthesize routesListControl = _routesListControl;

#pragma mark - Initalization

- (id)init {
    if (self = [super initWithNibName:@"BSRoutesView" bundle:nil]) {
        self.routesListControl = [[[UISegmentedControl alloc] init] autorelease];
    }
    
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
	
	[[self navigationItem] setTitle:NSLocalizedString(@"Routes", @"routes table view title")];
    
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone) {
        [[self bottomToolbar] setTintColor:[BSAppTheme lightBlueColor]];
    }
    
    UIBarButtonItem *refreshButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemRefresh target:self action:@selector(requestRouteList)];
    [[self navigationItem] setRightBarButtonItem:refreshButton animated:YES];
    [refreshButton release];
    
    [self.tableView setBackgroundColor:[UIColor whiteColor]];
    [self.tableView setSeparatorColor:[UIColor lightGrayColor]];
    
    [self layoutRoutesListControl];
    
    model_ = [[BSRoutesModel alloc] init];
    
    [model_ addObserver:self 
             forKeyPath:@"routes" 
                options:(NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld) 
                context:@selector(reloadRoutes)];
    
    [model_ addObserver:self 
             forKeyPath:@"error" 
                options:(NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld) 
                context:@selector(operationDidFail)];
    
    [self requestRouteList];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    if ([self.tableView indexPathForSelectedRow] != nil) {
        [self.tableView deselectRowAtIndexPath:[self.tableView indexPathForSelectedRow] animated:YES];
    }
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
	return interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown;
}

- (void)layoutRoutesListControl {
    NSArray *routeListControlItems = [NSArray arrayWithObjects:NSLocalizedString(@"All Routes", @"All Routes"),
                                        NSLocalizedString(@"Favorites", @"Favorites"), nil];
    
	self.routesListControl = [[[UISegmentedControl alloc] initWithItems:routeListControlItems] autorelease];
	self.routesListControl.segmentedControlStyle = UISegmentedControlStyleBar;
	//self.routesListControl.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin;
	self.routesListControl.frame = CGRectMake(0, 0, 305, 30);
	self.routesListControl.selectedSegmentIndex = 0;
	UIBarButtonItem *buttonItem = [[UIBarButtonItem alloc] initWithCustomView:self.routesListControl];
	
	self.bottomToolbar.items = [NSArray arrayWithObjects:buttonItem, nil];
	
	[self.routesListControl addTarget:self action:@selector(switchRoutesList:) forControlEvents:UIControlEventValueChanged];
	
	[buttonItem release];
}

#pragma mark -
#pragma mark Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
	return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [model_ countOfRoutes];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 64.0f;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *RouteCellIdentifier = @"BSRouteTableViewCell";
    
    BSRoutesTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:RouteCellIdentifier];
    if (cell == nil) {
        NSArray *topLevelObjects = [[NSBundle mainBundle] loadNibNamed:@"BSRoutesTableViewCell" owner:self options:nil];
        cell = [topLevelObjects objectAtIndex:0];
        
        //cell.routeEndpointsLabel.numberOfLines = 4;
    }
    
	BSRoute *route = (BSRoute *)[model_ objectInRoutesAtIndex:indexPath.row];
	
	cell.routeNumberLabel.text = route.tag;
    
    if (route.endpoints != nil) {
        cell.routeEndpointsLabel.text = route.endpoints;
        cell.routeEndpointsLabel.adjustsFontSizeToFitWidth = YES;
        //cell.routeEndpointsLabel.numberOfLines = 0;
    } else {
        cell.routeEndpointsLabel.text = @"unknown";
        //cell.routeEndpointsLabel.numberOfLines = 1;
    }
    
    return cell;
}

#pragma mark -
#pragma mark Table view delegate

- (void) tableView:(UITableView *)tView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	BSRoute *route = (BSRoute *)[model_ objectInRoutesAtIndex:[indexPath row]];
	
	BSDirectionsViewController *nextController = [[BSDirectionsViewController alloc] init];
	nextController.title = route.title;
	nextController.stopTag = route.tag;
	
	[self.navigationController pushViewController:nextController animated:YES];
	
	[nextController release];
}

#pragma mark -
#pragma mark Route Loading and Model Observing

- (void)requestRouteList {
    [model_ requestRouteList];
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
    SEL selector = (SEL)context;
    [self performSelector:selector];
}

- (void)reloadRoutes {

    // FIXME: you are needlessly animating in 40 rows
    // only animate in the rows which are visible.
    int routesToAdd = [model_ countOfRoutes];
	int routesToDelete = [self.tableView numberOfRowsInSection:0];
    
    [self.tableView beginUpdates];
	
	for (int i = 0; i < routesToDelete; i++) {
		NSArray *delete = [NSArray arrayWithObject:[NSIndexPath indexPathForRow:i inSection:0]];
		[self.tableView deleteRowsAtIndexPaths:delete withRowAnimation:UITableViewRowAnimationBottom];
	}
    
    for (int i = 0; i < routesToAdd; i++) {
		NSArray *insert = [NSArray arrayWithObject:[NSIndexPath indexPathForRow:i inSection:0]];
		[self.tableView insertRowsAtIndexPaths:insert withRowAnimation:UITableViewRowAnimationTop];
	}
    
    [self.tableView endUpdates];
}

- (void)operationDidFail {    
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Error", @"error alert view title") 
                                                    message:[[model_ error] localizedDescription] 
                                                   delegate:nil 
                                          cancelButtonTitle:NSLocalizedString(@"OK", @"ok button title") 
                                          otherButtonTitles:nil];
    [alert show];
    [alert release];
}

- (void)switchRoutesList:(id)sender {
    NSLog(@"switchRoutesList");
}

#pragma mark -
#pragma mark Memory management

- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Relinquish ownership any cached data, images, etc that aren't in use.
}

- (void)viewDidUnload {
    // Relinquish ownership of anything that can be recreated in viewDidLoad or on demand.
    // For example: self.myOutlet = nil;
}


- (void)dealloc {
    [_tableView release];
    [_bottomToolbar release];
    [_routesListControl release];
    
    [model_ removeObserver:self forKeyPath:@"routes"];
    [model_ removeObserver:self forKeyPath:@"error"];
    [model_ release];
    [super dealloc];
}


@end