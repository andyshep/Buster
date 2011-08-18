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

@synthesize routes;

#pragma mark -
#pragma mark View lifecycle

- (void)viewDidLoad {
    [super viewDidLoad];
	
	// set up the navigation bar
	[[self navigationItem] setTitle:@"Routes"];
    
    [self loadRouteList];
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
    return [routes count];
}


// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
    }
    
    // Configure the cell...
	MBTARoute *route = (MBTARoute *)[routes objectAtIndex:indexPath.row];
	
	cell.textLabel.text = route.title;
	//cell.inboundDestination.text = [dict objectForKey:@"inboundTitle"];
	//cell.outboundDestination.text = [dict objectForKey:@"outboundTitle"];
    
    return cell;
}

#pragma mark -
#pragma mark Table view delegate

- (void) tableView:(UITableView *)tView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	MBTARoute *route = (MBTARoute *)[routes objectAtIndex:indexPath.row];
	
	//StopListViewController *nextController = [[StopListViewController alloc] initWithStyle:UITableViewStylePlain];
	
	StopListViewController *nextController = [[StopListViewController alloc] initWithNibName:@"StopListViewController" bundle:nil];
	nextController.title = route.title;
	nextController.stopTag = route.tag;
	
	[self.navigationController pushViewController:nextController animated:YES];
	
	[nextController release];
}

- (void)loadRouteList {
//    MBTAQueryStringBuilder *_builder = [[[MBTAQueryStringBuilder alloc] 
//                                         initWithBaseURL:@"http://webservices.nextbus.com/service/publicXMLFeed"] autorelease];
    
    // RouteListOperation *loadingOp = [[RouteListOperation alloc] initWithURLString:[_builder buildRouteListQuery] delegate:self];
    
    RouteListOperation *loadingOp = [[RouteListOperation alloc] initWithURLString:@"http://localhost:8081/routeList.xml" delegate:self];
    [loadingOp start];
}

#pragma mark -
#pragma mark RouteListOperationDelegate methods

- (void)didConsumeData:(id)data {
    self.routes = (NSArray *)data;
    
    // [self didConsumeRouteList:data];
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

