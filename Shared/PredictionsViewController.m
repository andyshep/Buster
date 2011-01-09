//
//  PredictionsViewController.m
//  Buster
//
//  Created by andyshep on 1/3/11.
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

#import "PredictionsViewController.h"


@implementation PredictionsViewController

@synthesize stopTag, latitude, longitude;
@synthesize routeNumber, routeTitle, directionTag;


#pragma mark -
#pragma mark View lifecycle

- (void)viewDidLoad {
    [super viewDidLoad];

    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
	
	// [[self navigationItem] setTitle:self.title];
	
	UIBarButtonItem *refreshButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemRefresh 
																				   target:self 
																				   action:@selector(refreshList:)];
	
	self.navigationItem.rightBarButtonItem = refreshButton;
	
	PredictionsModel *model = [PredictionsModel sharedPredictionsModel];
	[model requestPredictionsForRoute:self.routeNumber andStop:self.stopTag];
}


- (void)viewWillAppear:(BOOL)animated {
	[super viewWillAppear:animated];
	
	PredictionsModel *model = [PredictionsModel sharedPredictionsModel];
	[model addObserver:self 
			forKeyPath:@"predictions" 
			   options:(NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld) 
			   context:NULL];
}

- (void)viewDidDisappear:(BOOL)animated {
	PredictionsModel *model = [PredictionsModel sharedPredictionsModel];
	[model removeObserver:self forKeyPath:@"predictions"];
	
	[super viewDidDisappear:animated];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
	
	// first section is the custom cell
	if ([indexPath section] == 0) {
		return 150.0f;
	}
	
	// else return standard detail table cell height
	return 44.0f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
	
	// only the second section has a header
	if (section == 1) {
		return 40.0f;	
	}
	
	return 0.0f;
}


#pragma mark -
#pragma mark Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 2;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	if (section == 0) {
		return 1;
	}
	
    PredictionsModel *model = [PredictionsModel sharedPredictionsModel];
	return [model countOfPredictions];
}


// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	
	// return the first placeholder title cell
	if ([indexPath section] == 0) {
		static NSString *CellIdentifier = @"Cell";
		
		UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
		if (cell == nil) {
			cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
		}
		
		// Configure the cell...
		
		return cell;
	}
	
	// return a prediction cell
	static NSString *CellIdentifier = @"Cell";
	
	UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
	if (cell == nil) {
		cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
	}
	
	PredictionsModel *model = [PredictionsModel sharedPredictionsModel];
	NSMutableDictionary *dict = (NSMutableDictionary *)[model objectInPredictionsAtIndex:[indexPath row]];
	NSString *title = [dict objectForKey:@"minutes"];
	title = [title stringByAppendingFormat:@" minutes"];
	
	cell.textLabel.text = title;
	
	return cell;
}


#pragma mark -
#pragma mark Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	
	PredictionsModel *model = [PredictionsModel sharedPredictionsModel];
	NSMutableDictionary *dict = (NSMutableDictionary *)[model objectInPredictionsAtIndex:[indexPath row]];
	NSString *vehicle = [dict objectForKey:@"vehicle"];
	NSString *time = [dict objectForKey:@"time"];
	
	id delegate = [[UIApplication sharedApplication] delegate];
	[delegate loadPredictionsForVehicle:vehicle runningRoute:self.routeNumber atEpochTime:time];
}

#pragma mark -
#pragma mark Model Observing

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
	[self.tableView reloadData];
}

#pragma mark -
#pragma mark IBActions

- (IBAction)refreshList:(id)sender {
	NSLog(@"refreshList:");
	
	// TODO: implement with periodic updater?
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


@end

