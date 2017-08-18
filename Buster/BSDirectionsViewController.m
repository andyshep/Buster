//
//  BSDirectionsViewController.m
//  Buster
//
//  Created by Andrew Shepard on 8/9/10.
//  Copyright © 2010-2017 Andrew Shepard. All rights reserved.
//

#import "BSDirectionsViewController.h"
#import "BSPredictionsViewController.h"

#import "BSStop.h"
#import "BSDirection.h"
#import "BSDirectionsModel.h"

static void *myContext = &myContext;

@interface BSDirectionsViewController () <UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) BSDirectionsModel *model;

@end

@implementation BSDirectionsViewController

- (instancetype)init {
    if (self = [super init]) {
        self.directionTitle = @"";
        
        self.tableView = [[UITableView alloc] initWithFrame:CGRectZero];
        [_tableView setDelegate:self];
        [_tableView setDataSource:self];
        
        self.directionControl = [[UISegmentedControl alloc] initWithItems:@[]];
        
        UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithCustomView:_directionControl];
        [self setToolbarItems:@[item]];
        
        self.model = [[BSDirectionsModel alloc] init];
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
    
    [_tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"BSStopTableViewCellIdentifier"];
    
    [self.view addSubview:_tableView];
    [self setupTableViewConstraints];
    
    NSKeyValueObservingOptions options = NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld;
    
    [_model addObserver:self forKeyPath:@"directions" options:options context:myContext];
    [_model addObserver:self forKeyPath:@"stops" options:options context:myContext];
    [_model addObserver:self forKeyPath:@"tags" options:options context:myContext];
    [_model addObserver:self forKeyPath:@"title" options:options context:myContext];
    [_model addObserver:self forKeyPath:@"error" options:options context:myContext];

    [_model requestDirectionsForStop:self.stopTag];
    
    [_directionControl addObserver:self forKeyPath:@"selectedSegmentIndex" options:options context:myContext];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self.navigationController setToolbarHidden:NO];
    [_tableView deselectRowAtIndexPath:[_tableView indexPathForSelectedRow] animated:YES];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    [self.navigationController setToolbarHidden:YES];
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
    if (context == myContext) {
        if ([keyPath isEqualToString:@"directions"]) {
            [self directionsDidLoad];
        }
        else if ([keyPath isEqualToString:@"stops"]) {
            [self stopsDidLoad];
        }
        else if ([keyPath isEqualToString:@"selectedSegmentIndex"]) {
            [self reloadStops];
        }
    }
    else {
        [super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
    }
}

- (void)directionsDidLoad {
    [self reloadDirectionControl];
}

- (void)stopsDidLoad {
    [_tableView reloadData];
}

- (void)reloadStops {
    NSUInteger index = [_directionControl selectedSegmentIndex];
    NSString *key = [_directionControl titleForSegmentAtIndex:index];
    
    BSDirection *direction = [[_model directions] objectForKey:key];
    [_model loadStopsForDirection:direction];
}

- (void)reloadDirectionControl {
    [_directionControl removeAllSegments];
    NSArray *items = [[[_model directions] allKeys] sortedArrayUsingSelector:@selector(caseInsensitiveCompare:)];
    
    [items enumerateObjectsUsingBlock:^(id _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [_directionControl insertSegmentWithTitle:obj atIndex:idx animated:NO];
    }];
    
    [_directionControl setSelectedSegmentIndex:0];
}

- (void)operationDidFail {    
    NSString *title = NSLocalizedString(@"Error", @"error alert view title");
    NSString *message = self.model.error.localizedDescription;
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:title message:message preferredStyle:UIAlertControllerStyleAlert];
    
    [self presentViewController:alertController animated:YES completion:nil];
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.model.stops.count;
}

- (UITableViewCell *)tableView:(UITableView *)tView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *identifier = @"BSStopTableViewCellIdentifier";
    UITableViewCell *cell = [tView dequeueReusableCellWithIdentifier:identifier forIndexPath:indexPath];
    
    BSStop *stop = self.model.stops[indexPath.row];
    cell.textLabel.text = stop.title;
    
    return cell;
}

- (void) tableView:(UITableView *)tView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    BSStop *stop = self.model.stops[indexPath.row];
    NSString *routeTitle = stop.title;
    NSString *tag = stop.tag;
    
    BSPredictionsViewController *nextController = [[BSPredictionsViewController alloc] init];
    nextController.title = NSLocalizedString(@"Predictions", @"predictions table view title");
    
    nextController.routeNumber = self.title;
    nextController.stopTag = tag;
    nextController.routeTitle = routeTitle;
    
    [self.navigationController pushViewController:nextController animated:YES];
}

- (void)setupTableViewConstraints {
    [_tableView setTranslatesAutoresizingMaskIntoConstraints:NO];
    
    NSDictionary *views = @{@"tableView": _tableView};
    NSArray *verticalConstraints = [NSLayoutConstraint constraintsWithVisualFormat:@"V:|[tableView]|" options:0 metrics:nil views:views];
    NSArray *horizontalConstraints = [NSLayoutConstraint constraintsWithVisualFormat:@"H:|[tableView]|" options:0 metrics:nil views:views];
    
    [NSLayoutConstraint activateConstraints:verticalConstraints];
    [NSLayoutConstraint activateConstraints:horizontalConstraints];
}

@end
