//
//  RouteStopViewController.m
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

@synthesize stopTag;

#pragma mark -
#pragma mark View Lifecycle

- (id)initWithStyle:(UITableViewStyle)style {
    if ((self = [super initWithStyle:style])) {
		isUnloading = YES;
    }
	
    return self;
}

// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
	[super viewDidLoad];
	
	[[self navigationItem] setTitle:self.title];
	
	StopListModel *model = [StopListModel sharedStopListModel];
	[model requestStopList:self.stopTag];
}

- (void)viewWillAppear:(BOOL)animated {
	[super viewWillAppear:animated];
	
	StopListModel *model = [StopListModel sharedStopListModel];
	
	[model addObserver:self 
			forKeyPath:@"stops" 
			   options:(NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld) 
			   context:NULL];
}

- (void)viewDidDisappear:(BOOL)animated {
	NSLog(@"viewDidDisappear:");
	
	StopListModel *model = [StopListModel sharedStopListModel];
	[model removeObserver:self forKeyPath:@"stops"];
	
	[super viewDidDisappear:animated];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
	return YES;
}

#pragma mark -
#pragma mark Model Observing

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
	[self.tableView reloadData];
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
	NSMutableDictionary *dict = (NSMutableDictionary *)[model objectInStopsAtIndex:row];
	
	cell.textLabel.text = [dict objectForKey:@"title"];
	
	return cell;
}

- (void) tableView:(UITableView *)tView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	
	StopListModel *model = [StopListModel sharedStopListModel];
	NSUInteger row = [indexPath row];
	NSMutableDictionary *dict = (NSMutableDictionary *)[model objectInStopsAtIndex:row];
	NSString *routeTitle = (NSString *)[dict objectForKey:@"title"];
	NSString *_directionTag = (NSString *)[dict objectForKey:@"dirTag"];
	NSString *_tag = (NSString *)[dict objectForKey:@"tag"];
	
	PredictionsViewController *nextController = [[PredictionsViewController alloc] initWithStyle:UITableViewStyleGrouped];
	nextController.title = @"Predictions";
	nextController.directionTag = _directionTag;
	nextController.routeNumber = self.title;
	nextController.stopTag = _tag;
	nextController.routeTitle = routeTitle;
	
	// FIXME: figure out better delegate handling
	// nextController.delegate = self.delegate;
	
	isUnloading = NO;
	[self.navigationController pushViewController:nextController animated:YES];
	
	[nextController release];
}


@end
