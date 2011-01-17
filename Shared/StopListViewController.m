//
//  StopListViewController.m
//  Buster
//
//  Created by andyshep on 8/9/10.
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

#import "StopListViewController.h"


@implementation StopListViewController

@synthesize stopTag, tableView, directionControl, bottomToolbar;

#pragma mark -
#pragma mark View Lifecycle


// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
	[super viewDidLoad];
	
	[[self navigationItem] setTitle:self.title];
	
	UIBarButtonItem *showRouteButton = [[UIBarButtonItem alloc] initWithTitle:@"Show Route" 
																		style:UIBarButtonItemStylePlain 
																	   target:self 
																	   action:@selector(showRoute)];
	
	self.navigationItem.rightBarButtonItem = showRouteButton;
	[showRouteButton release];
	
	StopListModel *model = [StopListModel sharedStopListModel];
	[model requestStopList:self.stopTag];
}

- (void)viewWillAppear:(BOOL)animated {
	[super viewWillAppear:animated];
	
	StopListModel *model = [StopListModel sharedStopListModel];
	
	[model addObserver:self 
			forKeyPath:@"stops" 
			   options:(NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld) 
			   context:@selector(reloadTable)];
	
	[model addObserver:self 
			forKeyPath:@"tags" 
			   options:(NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld) 
			   context:@selector(reloadDirectionControl)];

	[model addObserver:self 
			forKeyPath:@"title" 
			   options:(NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld) 
			   context:@selector(reloadRouteTitle)];
}

- (void)viewDidDisappear:(BOOL)animated {
	
	StopListModel *model = [StopListModel sharedStopListModel];
	[model removeObserver:self forKeyPath:@"stops"];
	[model removeObserver:self forKeyPath:@"tags"];
	[model removeObserver:self forKeyPath:@"title"];
	
	[super viewDidDisappear:animated];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
	return YES;
}

#pragma mark -
#pragma mark Model Observing

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
	
	SEL selector = (SEL)context;
    [self performSelector:selector];
}

- (void)reloadTable {
	[self.tableView reloadData];
}

- (void)reloadDirectionControl {

	StopListModel *model = [StopListModel sharedStopListModel];
	
	directionControl = [[UISegmentedControl alloc] initWithItems:[NSArray arrayWithArray:[model tags]]];
	
	directionControl.segmentedControlStyle = UISegmentedControlStyleBar;
	directionControl.autoresizingMask = UIViewAutoresizingFlexibleWidth;
	directionControl.frame = CGRectMake(0, 0, 295, 30);
	directionControl.selectedSegmentIndex = 0;
	UIBarButtonItem *buttonItem = [[UIBarButtonItem alloc] initWithCustomView:directionControl];
	
	bottomToolbar.items = [NSArray arrayWithObjects:buttonItem, nil];
	
	[self.directionControl addTarget:self action:@selector(switchDirection:) forControlEvents:UIControlEventValueChanged];
}

- (void)reloadRouteTitle {
	
	StopListModel *model = [StopListModel sharedStopListModel];
	
	UIView *containerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 30)];
	UILabel *routeLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 320, 30)];
	
	routeLabel.text = [model title];
	routeLabel.textAlignment = UITextAlignmentCenter;
	routeLabel.adjustsFontSizeToFitWidth = YES;
	[containerView addSubview:routeLabel];
	self.tableView.tableHeaderView = containerView;
	
	[routeLabel release];
	[containerView release];
}

#pragma mark -
#pragma mark Memory Management

- (void)didReceiveMemoryWarning {
	// Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
	
	// Release any cached data, images, etc that aren't in use.
}

- (void)dealloc {
    [super dealloc];
}

#pragma mark -
#pragma mark UITableViewDataSource methods

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	
	StopListModel *model = [StopListModel sharedStopListModel];
	return [model countOfStops];
}

- (UITableViewCell *)tableView:(UITableView *)tView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
    }
	
	StopListModel *model = [StopListModel sharedStopListModel];	
	NSUInteger row = [indexPath row];
	MBTAStop *stop = (MBTAStop *)[model objectInStopsAtIndex:row];
	
	cell.textLabel.text = stop.title;
	cell.textLabel.adjustsFontSizeToFitWidth = YES;
	
	return cell;
}

- (void) tableView:(UITableView *)tView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	
	[self.tableView deselectRowAtIndexPath:indexPath animated:YES];
	
	StopListModel *model = [StopListModel sharedStopListModel];
	NSUInteger row = [indexPath row];
	MBTAStop *stop = (MBTAStop *)[model objectInStopsAtIndex:row];
	NSString *routeTitle = stop.title;
	NSString *_tag = stop.tag;
	
	PredictionsViewController *nextController = [[PredictionsViewController alloc] initWithStyle:UITableViewStyleGrouped];
	nextController.title = @"Predictions";
	nextController.routeNumber = self.title;
	nextController.stopTag = _tag;
	nextController.routeTitle = routeTitle;
	
	[self.navigationController pushViewController:nextController animated:YES];
	
	[nextController release];
}

#pragma mark -
#pragma mark Route Path Assembly

- (void)assembleRoutePath {
//	StopListModel *model = [StopListModel sharedStopListModel];
//	NSArray *stops = [model stops];
//	
//	NSMutableDictionary *directions = [[NSMutableDictionary alloc] initWithCapacity:3];
//	for (NSDictionary *stop in stops) {
//		if ([directions objectForKey:[stop valueForKey:@"dirTag"]] == nil) {
//			[directions setObject:[stop valueForKey:@"dirTag"] forKey:[stop valueForKey:@"dirTag"]];
//		}
//	}
//	
//	NSLog(@"assembleRoutePath: %@", directions);
	
//	NSLog(@"assembleRoutePath: %@", stops);
}

#pragma mark -
#pragma mark IBActions

- (IBAction)showRoute {
	[self assembleRoutePath];
}

- (IBAction)switchDirection:(id)sender {
	// tell the model we're switching directions
	
	StopListModel *model = [StopListModel sharedStopListModel];
	[model loadStopsForTagIndex:self.directionControl.selectedSegmentIndex];
}


@end
