//
//  BSRoutesViewController.m
//  Buster
//
//  Created by Andrew Shepard on 12/15/10.
//  Copyright © 2010-2017 Andrew Shepard. All rights reserved.
//

#import "BSRoutesViewController.h"

#import "BSDirectionsViewController.h"
#import "BSRoutesTableViewCell.h"

#import "BSRoute.h"
#import "BSRoutesModel.h"

static void *myContext = &myContext;

@interface BSRoutesViewController ()

@property (nonatomic, strong) BSRoutesModel *model;

- (void)requestRouteList;
- (void)reloadRoutes;

@end

@implementation BSRoutesViewController

- (instancetype)init {
    if ((self = [super init])) {
        self.tableView = [[UITableView alloc] initWithFrame:CGRectZero];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        
        self.model = [[BSRoutesModel alloc] init];
    }
    
    return self;
}

- (void)dealloc {
    [_model removeObserver:self forKeyPath:@"routes"];
    [_model removeObserver:self forKeyPath:@"error"];
}

- (void)viewDidLoad {
    [super viewDidLoad];

    [self.navigationItem setTitle:NSLocalizedString(@"Routes", @"routes table view title")];

    [self.view addSubview:_tableView];
    [self setupTableViewConstraints];
    
    UIBarButtonItem *refreshButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemRefresh target:self action:@selector(requestRouteList)];
    [self.navigationItem setRightBarButtonItem:refreshButton animated:YES];

    [_model addObserver:self
             forKeyPath:@"routes" 
                options:(NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld) 
                context:myContext];
    
    [_model addObserver:self 
             forKeyPath:@"error" 
                options:(NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld) 
                context:myContext];
    
    [self requestRouteList];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [_tableView deselectRowAtIndexPath:[_tableView indexPathForSelectedRow] animated:YES];
}

#pragma mark - UITableView
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.model.routes.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *identifier = @"BSRouteTableViewCellIdentifier";
    
    BSRoutesTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier forIndexPath:indexPath];
    
    BSRoute *route = self.model.routes[indexPath.row];
    
    cell.routeNumberLabel.text = route.title;
    
    if (route.endpoints != nil) {
        cell.routeEndpointsLabel.text = route.endpoints;
        cell.routeEndpointsLabel.adjustsFontSizeToFitWidth = YES;
        cell.routeEndpointsLabel.numberOfLines = 0;
    } else {
        cell.routeEndpointsLabel.text = @"Indeterminate Route Endpoints";
    }
    
    return cell;
}

- (void) tableView:(UITableView *)tView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    BSRoute *route = self.model.routes[indexPath.row];
    
    BSDirectionsViewController *nextController = [[BSDirectionsViewController alloc] init];
    nextController.title = route.title;
    nextController.stopTag = route.tag;
    
    [self.navigationController pushViewController:nextController animated:YES];
}

#pragma mark - KVO
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
    
    if (context == myContext) {
        // TODO: implement
    }
    else {
        [super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
    }
}

- (void)setupTableViewConstraints {
    [_tableView setTranslatesAutoresizingMaskIntoConstraints:NO];
    
    NSDictionary *views = @{@"tableView": _tableView};
    NSArray *verticalConstraints = [NSLayoutConstraint constraintsWithVisualFormat:@"V:|[tableView]|" options:0 metrics:nil views:views];
    NSArray *horizontalConstraints = [NSLayoutConstraint constraintsWithVisualFormat:@"H:|[tableView]|" options:0 metrics:nil views:views];
    
    [NSLayoutConstraint activateConstraints:verticalConstraints];
    [NSLayoutConstraint activateConstraints:horizontalConstraints];
}

#pragma mark - Route Loading and Model Observing
- (void)requestRouteList {
    [_model requestRouteList];
}

- (void)reloadRoutes {
    [_tableView reloadData];
}

- (void)operationDidFail {
    NSString *title = NSLocalizedString(@"Error", @"error alert view title");
    NSString *message = self.model.error.localizedDescription;
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:title message:message preferredStyle:UIAlertControllerStyleAlert];
    
    [self presentViewController:alertController animated:YES completion:nil];
}

@end
