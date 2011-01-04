//
//  RouteListViewController.m
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

#import "RouteListViewController.h"


@implementation RouteListViewController

@synthesize delegate;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
	
	self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self != nil) {
		
    }
    return self;
}

#pragma mark -
#pragma mark View lifecycle

//- (void)awakeFromNib {
//	BusterRouteList *model = [BusterRouteList sharedBusterRouteList];
//	[model addObserver:self forKeyPath:@"routeList" options:NSKeyValueObservingOptionNew context:nil];
//}

- (void)viewDidLoad {
    [super viewDidLoad];
	
	// set up the navigation bar
	UIBarButtonItem *doneButton = [[UIBarButtonItem alloc] initWithTitle:@"Done" 
																   style:UIBarButtonItemStyleDone 
																  target:self 
																  action:@selector(done)];
	
	[[self navigationItem] setRightBarButtonItem:doneButton];
	[[self navigationItem] setTitle:@"Routes"];
	
	[doneButton release];
	
	NSLog(@"viewDidLoad:");
}


- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];

	RouteListModel *model = [RouteListModel sharedRouteListModel];
	
	[model requestRouteList];
	[model addObserver:self 
			forKeyPath:@"routes" 
			   options:(NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld) 
			   context:NULL];
}

- (void)viewWillDisappear:(BOOL)animated {
	
	RouteListModel *model = [RouteListModel sharedRouteListModel];
	[model removeObserver:self forKeyPath:@"routes"];
	
	[super viewWillDisappear:animated];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
	return YES;
}


#pragma mark -
#pragma mark Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
	
	return 1;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	
	RouteListModel *model = [RouteListModel sharedRouteListModel];
	return [model countOfRoutes];
}


// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
    }
    
    // Configure the cell...
	RouteListModel *model = [RouteListModel sharedRouteListModel];
	NSUInteger row = [indexPath row];
	NSMutableDictionary *dict = (NSMutableDictionary *)[model objectInRoutesAtIndex:row];
	
	cell.textLabel.text = [dict objectForKey:@"title"];
	//cell.inboundDestination.text = [dict objectForKey:@"inboundTitle"];
	//cell.outboundDestination.text = [dict objectForKey:@"outboundTitle"];
    
    return cell;
}

#pragma mark -
#pragma mark Table view delegate

- (void) tableView:(UITableView *)tView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	
	RouteListModel *model = [RouteListModel sharedRouteListModel];
	NSUInteger row = [indexPath row];
	NSMutableDictionary *dict = (NSMutableDictionary *)[model objectInRoutesAtIndex:row];
	
	StopListViewController *nextController = [[StopListViewController alloc] initWithStyle:UITableViewStylePlain];
	nextController.title = [dict objectForKey:@"title"];
	nextController.stopTag = [dict objectForKey:@"tag"];
	
	[self.navigationController pushViewController:nextController animated:YES];
	
	[nextController release];
}

#pragma mark -
#pragma mark Model Observing

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
    NSLog(@"observeValueForKeyPath: %@", keyPath);
	
	[self.tableView reloadData];
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
    [super dealloc];
}

#pragma mark -
#pragma mark IBActions

#pragma mark -
#pragma mark IBActions

- (IBAction)done {
	[self.delegate flipsideViewControllerDidFinish:self];	
}


@end

