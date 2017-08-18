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

#import "BSDirection.h"

#import "BSDirectionsModel.h"
#import "BSPredictionsViewController.h"

@interface BSDirectionsViewController ()

@property (nonatomic, strong) BSDirectionsModel *model;

@end

@implementation BSDirectionsViewController

- (instancetype)init {
    if ((self = [super initWithNibName:@"BSDirectionsView" bundle:nil])) {
        self.directionTitle = @"";
    }
    
    return self;
}

- (void)dealloc {
    [_model removeObserver:self forKeyPath:@"directions"];
    [_model removeObserver:self forKeyPath:@"stops"];
    [_model removeObserver:self forKeyPath:@"tags"];
    [_model removeObserver:self forKeyPath:@"title"];
    [_model removeObserver:self forKeyPath:@"error"];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.navigationItem setTitle:NSLocalizedString(@"Stops", @"Stops title")];
    
    self.model = [[BSDirectionsModel alloc] init];
    
    [_model addObserver:self 
             forKeyPath:@"directions" 
                options:(NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld) 
                context:@selector(directionsDidLoad)];
    
    [_model addObserver:self 
             forKeyPath:@"stops" 
                options:(NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld) 
                context:@selector(stopsDidLoad)];    
    
    [_model addObserver:self 
             forKeyPath:@"tags" 
                options:(NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld) 
                context:@selector(reloadDirectionControl)];
    
    [_model addObserver:self 
             forKeyPath:@"title" 
                options:(NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld) 
                context:@selector(titleDidLoad)];
    
    [_model addObserver:self 
             forKeyPath:@"error" 
                options:(NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld) 
                context:@selector(operationDidFail)];

    [_model requestDirectionsList:self.stopTag];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    if ((self.tableView).indexPathForSelectedRow != nil) {
        [self.tableView deselectRowAtIndexPath:(self.tableView).indexPathForSelectedRow animated:YES];
    }
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    return interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown;
}

#pragma mark -
#pragma mark Model Observing

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
    SEL selector = (SEL)context;
    
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Warc-performSelector-leaks"
    [self performSelector:selector];
#pragma clang diagnostic pop
}

- (void)directionsDidLoad {
    // once the model has all the directions
    // we ask for the zeroth direction
    [_model loadStopsForDirection:0];
}

- (void)stopsDidLoad {
    [self reloadTable];
}

- (void)titleDidLoad {
    // FIXME: stop init these views each time!
    
    CGRect frame = self.view.bounds;
    
    UIView *containerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, frame.size.width, 30)];
    UILabel *routeLabel = [[UILabel alloc] initWithFrame:CGRectInset(containerView.bounds, 5.0, 0.0)];
    
    routeLabel.text = _model.title;
    routeLabel.textAlignment = NSTextAlignmentCenter;
    routeLabel.adjustsFontSizeToFitWidth = YES;
    routeLabel.font = [UIFont boldSystemFontOfSize:16.0];
    routeLabel.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    [containerView addSubview:routeLabel];
    self.tableView.tableHeaderView = containerView;
    
}

- (void)reloadTable {
    
//    [self hideActivityViewer];
    
    int stopsToAdd = [_model countOfStops];
    int stopsToDelete = [self.tableView numberOfRowsInSection:0];
    
    [self.tableView beginUpdates];
    
    for (int i = 0; i < stopsToDelete; i++) {
        NSArray *delete = @[[NSIndexPath indexPathForRow:i inSection:0]];
        [self.tableView deleteRowsAtIndexPaths:delete withRowAnimation:UITableViewRowAnimationBottom];
    }
    
    for (int i = 0; i < stopsToAdd; i++) {
        // for each route title
        // and stick it into the model
        // then insert it into the table with animations
        NSArray *insert = @[[NSIndexPath indexPathForRow:i inSection:0]];
        [self.tableView insertRowsAtIndexPaths:insert withRowAnimation:UITableViewRowAnimationTop];
    }
    
    // we're all done so do the cleanup
    [self.tableView endUpdates];
}

- (void)reloadDirectionControl {
    
    CGRect frame = self.view.bounds;
    
    NSMutableArray *items = [NSMutableArray arrayWithCapacity:2];
    for (int i = 1 ; i <= _model.tags.count ; i++) {
        [items addObject:[NSString stringWithFormat:@"Leg #%d", i]];
    }
    
    // FIXME: no really, fix this.
    // FIXME: alloc/initWithFrame and the add/remove segments to controll
    // stop allocing a new one each time.
    self.directionControl = [[UISegmentedControl alloc] initWithItems:[NSArray arrayWithArray:items]];
    self.directionControl.segmentedControlStyle = UISegmentedControlStyleBar;
    self.directionControl.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    self.directionControl.frame = CGRectMake(0, 0, frame.size.width - 15.0, 30);
    self.directionControl.selectedSegmentIndex = 0;
    UIBarButtonItem *buttonItem = [[UIBarButtonItem alloc] initWithCustomView:self.directionControl];
    
    self.bottomToolbar.items = @[buttonItem];
    
    [self.directionControl addTarget:self action:@selector(switchDirection:) forControlEvents:UIControlEventValueChanged];
    
}

- (void)operationDidFail {    
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Error", @"error alert view title") 
                                                    message:_model.error.localizedDescription 
                                                   delegate:nil 
                                          cancelButtonTitle:NSLocalizedString(@"OK", @"ok button title") 
                                          otherButtonTitles:nil];
    [alert show];
}

#pragma mark -
#pragma mark UITableViewDataSource methods

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [_model countOfStops];
}

- (UITableViewCell *)tableView:(UITableView *)tView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *BSStopCellIdentifier = @"BSStopTableViewCell";
    
    UITableViewCell *cell = [tView dequeueReusableCellWithIdentifier:BSStopCellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:BSStopCellIdentifier];
        cell.textLabel.adjustsFontSizeToFitWidth = YES;
        cell.textLabel.font = [UIFont preferredFontForTextStyle:UIFontTextStyleBody];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        cell.selectionStyle = UITableViewCellSelectionStyleGray;
    }
    
    BSDirection *stop = (BSDirection *)[_model objectInStopsAtIndex:indexPath.row];
    cell.textLabel.text = stop.title;
    
    return cell;
}

- (void) tableView:(UITableView *)tView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    BSDirection *stop = (BSDirection *)[_model objectInStopsAtIndex:indexPath.row];
    NSString *routeTitle = stop.title;
    NSString *_tag = stop.tag;
    
    BSPredictionsViewController *nextController = [[BSPredictionsViewController alloc] init];
    nextController.title = NSLocalizedString(@"Predictions", @"predictions table view title");
    
    // FIXME: how much of this do i need?
    nextController.routeNumber = self.title;
    nextController.stopTag = _tag;
    nextController.routeTitle = routeTitle;
    
    [self.navigationController pushViewController:nextController animated:YES];
    
}

#pragma mark -
#pragma mark IBActions

- (void)switchDirection:(id)sender {
    // tell the model we're switching directions
    [_model loadStopsForDirection:self.directionControl.selectedSegmentIndex];
}

@end
