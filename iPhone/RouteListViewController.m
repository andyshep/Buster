//
//  RouteListViewController.m
//  Buster
//
//  Created by Andrew Shepard on 12/15/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "RouteListViewController.h"
#import "BusterRouteList.h"


@implementation RouteListViewController

@synthesize delegate, routeList;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
	
	self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self != nil) {
		
		self.routeList = nil;
			
		BusterRouteList *model = [BusterRouteList sharedBusterRouteList];
		[model addObserver:self forKeyPath:@"routeList" options:NSKeyValueObservingOptionNew context:nil];
    }
    return self;
}


#pragma mark -
#pragma mark View lifecycle


- (void)viewDidLoad {
    [super viewDidLoad];
	
	// set up the navigation bar
	UIBarButtonItem *doneButton = [[UIBarButtonItem alloc] initWithTitle:@"Done" 
																   style:UIBarButtonItemStyleDone 
																  target:self 
																  action:@selector(done)];
	
	[[self navigationItem] setRightBarButtonItem:doneButton];
	[[self navigationItem] setTitle:@"Routes"];
	
	NSLog(@"viewDidLoad:");
}

/*
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
}
*/
/*
- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
}
*/
/*
- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
}
*/
/*
- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
}
*/

// Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations
	return YES;
}


#pragma mark -
#pragma mark Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
	
	return 1;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	
	return [self.routeList count];
}


// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
    }
    
    // Configure the cell...
	NSUInteger row = [indexPath row];
	NSMutableDictionary *dict = (NSMutableDictionary *)[routeList objectAtIndex:row];
	
	cell.textLabel.text = [dict objectForKey:@"routeTitle"];
	//cell.inboundDestination.text = [dict objectForKey:@"inboundTitle"];
	//cell.outboundDestination.text = [dict objectForKey:@"outboundTitle"];
    
    return cell;
}


/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/


/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:YES];
    }   
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/


/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/


/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/


#pragma mark -
#pragma mark Table view delegate

- (void) tableView:(UITableView *)tView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	NSUInteger row = [indexPath row];
	NSMutableDictionary *dict = (NSMutableDictionary *)[routeList objectAtIndex:row];
	
	RouteStopViewController *nextController = [[RouteStopViewController alloc] initWithStyle:UITableViewStylePlain];
	nextController.title = [dict objectForKey:@"routeTitle"];
	
	[self.navigationController pushViewController:nextController animated:YES];
	
	[nextController release];
}

#pragma mark -
#pragma mark Model Observing

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
    NSLog(@"observeValueForKeyPath: %@", keyPath);
	
	self.routeList = [change valueForKey:@"new"];
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
