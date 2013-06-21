//
//  PredictionsViewController.m
//  Buster
//
//  Created by andyshep on 1/3/11.
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

#import "BSPredictionsViewController.h"

@interface BSPredictionsViewController ()

@property (nonatomic, strong) BSPredictionsModel *model;

@end

@implementation BSPredictionsViewController

- (id)init {
    if ((self = [super initWithStyle:UITableViewStyleGrouped])) {
        //
    }
                 
    return self;
}

- (void)dealloc {
    [_model removeObserver:self forKeyPath:@"predictions"];
    [_model removeObserver:self forKeyPath:@"predictionMeta"];
    [_model removeObserver:self forKeyPath:@"error"];
}

- (void)viewDidLoad {
    [super viewDidLoad];
	
	UIBarButtonItem *refreshButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemRefresh target:self action:@selector(refreshList:)];
	self.navigationItem.rightBarButtonItem = refreshButton;
    
    [self.tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    
    self.model = [[BSPredictionsModel alloc] init];
    
    [_model addObserver:self
             forKeyPath:@"predictions" 
                options:(NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld) 
                context:@selector(reloadPredictions)];
    
    [_model addObserver:self
             forKeyPath:@"predictionMeta" 
                options:(NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld) 
                context:@selector(reloadPredictionMeta)];
    
    [_model addObserver:self 
             forKeyPath:@"error" 
                options:(NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld) 
                context:@selector(operationDidFail)];
    
    [_model requestPredictionsForRoute:_routeNumber andStop:_stopTag];
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

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	if (section == 0) {
		return 1;
	}

	return [_model countOfPredictions];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	// return the prediction meta data cell with route/stop info
	if ([indexPath section] == 0) {
        
		BSPredictionMetaTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"BSPredictionsInfoTableCell"];
		if (cell == nil) {
			cell = [[BSPredictionMetaTableViewCell alloc] init];
		}
		
        cell.routeNumberLabel.text = [[_model predictionMeta] objectForKey:@"routeTitle"];
        cell.routeDirectionLabel.text = [[_model predictionMeta] objectForKey:@"directionTitle"];
        cell.stopNameLabel.text = [[_model predictionMeta] objectForKey:@"stopTitle"];
        
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
		
		return cell;
	}
	
	// return a prediction cell with a time
	NSString *BSPredictionsCellIdentifier = @"BSPredictionsTimeTableCell";
	
	UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:BSPredictionsCellIdentifier];
	if (cell == nil) {
		cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:BSPredictionsCellIdentifier];
	}

	NSMutableDictionary *dict = (NSMutableDictionary *)[_model objectInPredictionsAtIndex:[indexPath row]];
	NSString *title = [dict objectForKey:@"minutes"];
	title = [title stringByAppendingFormat:@" %@", NSLocalizedString(@"minutes", @"minutes")];
	
	cell.textLabel.text = title;
	
	return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if ([indexPath section] == 0) {
        return;
    }
	
	NSMutableDictionary *dict = (NSMutableDictionary *)[_model objectInPredictionsAtIndex:[indexPath row]];
	NSString *vehicle = [dict objectForKey:@"vehicle"];
	NSString *time = [dict objectForKey:@"time"];
	
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone) {
        // push on the map view control if running on the phone/touch
        
        // NSLog(@"loadPredictionsForVehicle: %@ runningRoute: %@ atEpochTime: %@", vehicle, route, time);
        
        BSMapViewController *nextController = [[BSMapViewController alloc] initWithNibName:@"MapView_iPhone" bundle:nil];
        
        nextController.title = NSLocalizedString(@"Maps", @"Maps title");
        nextController.vehicle = vehicle;
        nextController.route = self.routeNumber;
        nextController.time = time;
        
        [self.navigationController pushViewController:nextController animated:YES];
        
    }
    else {
        // on the pad the map is shown in the detail view of the split view
        // we ask our delegate to load the predictions
        
        id delegate = [[UIApplication sharedApplication] delegate];
        [delegate loadPredictionsForVehicle:vehicle runningRoute:self.routeNumber atEpochTime:time];
    }
}

- (void)configureCell:(BSPredictionMetaTableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath {
    cell.routeNumberLabel.text = [[_model predictionMeta] objectForKey:@"routeTitle"];
    cell.routeDirectionLabel.text = [[_model predictionMeta] objectForKey:@"directionTitle"];
    cell.stopNameLabel.text = [[_model predictionMeta] objectForKey:@"stopTitle"];
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
	// first section is the custom cell
	if ([indexPath section] == 0) {
		return 88.0f;
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

#pragma mark - KVO
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
    SEL selector = (SEL)context;
    
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Warc-performSelector-leaks"
    [self performSelector:selector];
#pragma clang diagnostic pop
}

- (void)reloadPredictions {
    int predictionsToAdd = [_model countOfPredictions];
	int predictionsToDelete = [self.tableView numberOfRowsInSection:1];
    
    [self.tableView beginUpdates];
	
	for (int i = 0; i < predictionsToDelete; i++) {
		NSArray *delete = [NSArray arrayWithObject:[NSIndexPath indexPathForRow:i inSection:1]];
		[self.tableView deleteRowsAtIndexPaths:delete withRowAnimation:UITableViewRowAnimationBottom];
	}
    
    for (int i = 0; i < predictionsToAdd; i++) {
		NSArray *insert = [NSArray arrayWithObject:[NSIndexPath indexPathForRow:i inSection:1]];
		[self.tableView insertRowsAtIndexPaths:insert withRowAnimation:UITableViewRowAnimationTop];
	}
    
    [self.tableView endUpdates];
}

- (void)reloadPredictionMeta {
    // reconfigure the predictions meta data cell
    NSIndexPath *path = [NSIndexPath indexPathForRow:0 inSection:0];
    BSPredictionMetaTableViewCell *cell = (BSPredictionMetaTableViewCell *)[self.tableView cellForRowAtIndexPath:path];
    [self configureCell:cell atIndexPath:path];
}

- (void)operationDidFail {
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Error", @"error alert view title") 
                                                    message:[[_model error] localizedDescription]
                                                   delegate:nil 
                                          cancelButtonTitle:NSLocalizedString(@"OK", @"ok button title") 
                                          otherButtonTitles:nil];
    [alert show];
}

- (IBAction)refreshList:(id)sender {
    [_model requestPredictionsForRoute:_routeNumber andStop:_stopTag];
}

@end

