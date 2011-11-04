//
//  BSDirectionsViewController.m
//  Buster
//
//  Created by andyshep on 8/9/10.
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

#import "BSDirectionsViewController.h"


@implementation BSDirectionsViewController

@synthesize stopTag;//, tableView, directionControl, bottomToolbar;

#pragma mark -
#pragma mark View Lifecycle

- (id)init {
    if ((self = [super init])) {
        //
    }
    
    return self;
}

- (void)viewDidLoad {
	[super viewDidLoad];
	
	// [[self navigationItem] setTitle:self.title];
    [[self navigationItem] setTitle:@"Stops"];
    
//    UIBarButtonItem *addToFavoritesButton = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"28-star.png"] style:UIBarButtonItemStylePlain target:self action:@selector(somthing)];
//    [[self navigationItem] setRightBarButtonItem:addToFavoritesButton];
//    [addToFavoritesButton release];
	// show a spinner
//	[self showActivityViewer];
    
    // self.tableView.frame = CGRectMake(0, 0, 320, 100);
	
	model_ = [[BSDirectionsModel alloc] init];
    
    [model_ addObserver:self 
             forKeyPath:@"directions" 
                options:(NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld) 
                context:@selector(directionsDidLoad)];
    
    [model_ addObserver:self 
             forKeyPath:@"stops" 
                options:(NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld) 
                context:@selector(stopsDidLoad)];    
	
//	[model_ addObserver:self 
//             forKeyPath:@"tags" 
//                options:(NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld) 
//                context:@selector(reloadDirectionControl)];
//    
	[model_ addObserver:self 
             forKeyPath:@"title" 
                options:(NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld) 
                context:@selector(titleDidLoad)];
    
    [model_ addObserver:self 
             forKeyPath:@"error" 
                options:(NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld) 
                context:@selector(operationDidFail)];

    [model_ requestDirectionsList:self.stopTag];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
	return interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown;
}

#pragma mark -
#pragma mark Model Observing

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
	SEL selector = (SEL)context;
    [self performSelector:selector];
}

- (void)directionsDidLoad {
    NSLog(@"directions loaded!");
    
    // once the model has all the directions
    // we ask for the zeroth direction
    [model_ loadStopsForDirection:0];
}

- (void)stopsDidLoad {
    NSLog(@"stops loaded!");
    [self.tableView reloadData];
}

- (void)titleDidLoad {
    // FIXME: stop init these views each time!
	UIView *containerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 30)];
	UILabel *routeLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 320, 30)];
	
	routeLabel.text = [model_ title];
	routeLabel.textAlignment = UITextAlignmentCenter;
	routeLabel.adjustsFontSizeToFitWidth = YES;
	[containerView addSubview:routeLabel];
	self.tableView.tableHeaderView = containerView;
	
	[routeLabel release];
	[containerView release];
}

- (void)reloadTable {
	
//	[self hideActivityViewer];
	
//	int stopsToAdd = [model_ countOfStops];
//	int stopsToDelete = [self.tableView numberOfRowsInSection:0];
//	
//	[self.tableView beginUpdates];
//	
//	for (int i = 0; i < stopsToDelete; i++) {
//		NSArray *delete = [NSArray arrayWithObject:[NSIndexPath indexPathForRow:i inSection:0]];
//		[self.tableView deleteRowsAtIndexPaths:delete withRowAnimation:UITableViewRowAnimationBottom];
//	}
//	
//	for (int i = 0; i < stopsToAdd; i++) {
//		// for each route title
//		// and stick it into the model
//		// then insert it into the table with animations
//		NSArray *insert = [NSArray arrayWithObject:[NSIndexPath indexPathForRow:i inSection:0]];
//		[self.tableView insertRowsAtIndexPaths:insert withRowAnimation:UITableViewRowAnimationTop];
//	}
//	
//	// we're all done so do the cleanup
//	[self.tableView endUpdates];

    [self.tableView reloadData];
}

//- (void)reloadDirectionControl {
//	
//	NSMutableArray *items = [NSMutableArray arrayWithCapacity:2];
//	for (int i = 0 ; i < model_.tags.count ; i++) {
//		[items addObject:[NSString stringWithFormat:@"%d", i]];
//		//[items addObject:[model.titles objectAtIndex:i]];
//	}
//    
//    // FIXME: alloc/initWithFrame and the add/remove segments to controll
//    // stop allocing a new one each time.
//	directionControl = [[UISegmentedControl alloc] initWithItems:[NSArray arrayWithArray:items]];
//	directionControl.segmentedControlStyle = UISegmentedControlStyleBar;
//	directionControl.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin;
//	directionControl.frame = CGRectMake(0, 0, 305, 30);
//	directionControl.selectedSegmentIndex = 0;
//	UIBarButtonItem *buttonItem = [[UIBarButtonItem alloc] initWithCustomView:directionControl];
//	
//	bottomToolbar.items = [NSArray arrayWithObjects:buttonItem, nil];
//	
//	[self.directionControl addTarget:self action:@selector(switchDirection:) forControlEvents:UIControlEventValueChanged];
//	
//	[buttonItem release];
//}

- (void)operationDidFail {    
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Error", @"error alert view title") 
                                                    message:[[model_ error] localizedDescription] 
                                                   delegate:nil 
                                          cancelButtonTitle:NSLocalizedString(@"OK", @"ok button title") 
                                          otherButtonTitles:nil];
    [alert show];
    [alert release];
}

#pragma mark -
#pragma mark Memory Management

- (void)didReceiveMemoryWarning {
	// Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
	
	// Release any cached data, images, etc that aren't in use.
}

- (void)dealloc {
    
    [model_ removeObserver:self forKeyPath:@"directions"];
    [model_ removeObserver:self forKeyPath:@"stops"];
	// [model_ removeObserver:self forKeyPath:@"tags"];
	[model_ removeObserver:self forKeyPath:@"title"];
    [model_ removeObserver:self forKeyPath:@"error"];
    [model_ release];
    
    [super dealloc];
}

#pragma mark -
#pragma mark UITableViewDataSource methods

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	return [model_ countOfStops];
}

- (UITableViewCell *)tableView:(UITableView *)tView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	
    static NSString *BSStopCellIdentifier = @"BSStopTableViewCell";
    
    UITableViewCell *cell = [tView dequeueReusableCellWithIdentifier:BSStopCellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:BSStopCellIdentifier] autorelease];
    }
    
	BSDirection *stop = (BSDirection *)[model_ objectInStopsAtIndex:indexPath.row];
	cell.textLabel.text = stop.title;
	cell.textLabel.adjustsFontSizeToFitWidth = YES;
	
	return cell;
}

- (void) tableView:(UITableView *)tView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	
	[self.tableView deselectRowAtIndexPath:indexPath animated:YES];
	
	BSDirection *stop = (BSDirection *)[model_ objectInStopsAtIndex:indexPath.row];
	NSString *routeTitle = stop.title;
	NSString *_tag = stop.tag;
	
	BSPredictionsViewController *nextController = [[BSPredictionsViewController alloc] init];
	nextController.title = NSLocalizedString(@"Predictions", @"predictions table view title");
    
    // FIXME: how much of this do i need?
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

- (void)showRoutePath {
    NSLog(@"showRoutePath");
    
//    for (MBTARoutePath *path in model_.paths) {
//        for (NSDictionary *points in path.points) {
//            NSLog(@"%@", points);
//        }
//    }
//
//    RoutePathViewController *pathController = [[RoutePathViewController alloc] initWithNibName:@"MapView_iPhone" 
//                                                                                        bundle:nil];
//    
//    pathController.pathPoints = [model_ pathPoints];
//    
//    [self.navigationController pushViewController:pathController animated:YES];
//    [pathController release];
}

#pragma mark -
#pragma mark Spinners

//-(void)showActivityViewer
//{
//    [activityView release];
//    activityView = [[UIView alloc] initWithFrame: CGRectMake(self.tableView.frame.origin.x, 
//															 self.tableView.frame.origin.y,
//															 self.tableView.frame.size.width, 
//															 self.tableView.frame.size.height)];
//    activityView.backgroundColor = [UIColor blackColor];
//    activityView.alpha = 0.5;
//    
//    UIActivityIndicatorView *activityWheel = 
//		[[UIActivityIndicatorView alloc] initWithFrame: CGRectMake(self.tableView.frame.size.width / 2 - 18, 
//																   self.tableView.frame.size.height / 2 - 18, 
//																   36, 
//																   36)];
//    activityWheel.activityIndicatorViewStyle = UIActivityIndicatorViewStyleWhite;
//    activityWheel.autoresizingMask = (UIViewAutoresizingFlexibleLeftMargin |
//                                      UIViewAutoresizingFlexibleRightMargin |
//                                      UIViewAutoresizingFlexibleTopMargin |
//                                      UIViewAutoresizingFlexibleBottomMargin);
//    [activityView addSubview:activityWheel];
//    [activityWheel release];
//    [self.view addSubview:activityView];
//    [activityView release];
//    
//    [[[activityView subviews] objectAtIndex:0] startAnimating];
//}

//-(void)hideActivityViewer
//{
//    [[[activityView subviews] objectAtIndex:0] stopAnimating];
//    [activityView removeFromSuperview];
//    activityView = nil;
//}

#pragma mark -
#pragma mark IBActions

//- (IBAction)showRoute {
//	[self assembleRoutePath];
//}
//
//- (IBAction)switchDirection:(id)sender {
//	// tell the model we're switching directions
//	[model_ loadStopsForTagIndex:self.directionControl.selectedSegmentIndex];
//}


@end