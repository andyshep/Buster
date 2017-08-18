//
//  BSRoutesViewController.m
//  Buster
//
//  Created by andyshep on 12/15/10.
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

#import "BSRoutesViewController.h"

#import "BSDirectionsViewController.h"
#import "BSRoutesTableViewCell.h"

#import "BSRoute.h"
#import "BSRoutesModel.h"

#import "BSAppTheme.h"

#define ROUTE_CELL_DEFAULT_HEIGHT       64.0f
#define ROUTE_ENDPOINTS_DEFAULT_HEIGHT  36.0f

@interface BSRoutesViewController ()

@property (nonatomic, strong) BSRoutesModel *model;

- (void)requestRouteList;
- (void)reloadRoutes;
- (void)layoutRoutesListControl;

- (CGRect)sizeForString:(NSString *)string;

@end

@implementation BSRoutesViewController

- (instancetype)init {
    if ((self = [super init])) {
        self.tableView = [[UITableView alloc] initWithFrame:CGRectZero];
        _tableView.delegate = self;
        _tableView.dataSource = self;
    }
    
    return self;
}

- (void)dealloc {
    [_model removeObserver:self forKeyPath:@"routes"];
    [_model removeObserver:self forKeyPath:@"error"];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _tableView.frame = self.view.bounds;
    _tableView.autoresizingMask = (UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight);
    
    [self.view addSubview:_tableView];

    [self.navigationItem setTitle:NSLocalizedString(@"Routes", @"routes table view title")];
    
    UIBarButtonItem *refreshButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemRefresh target:self action:@selector(requestRouteList)];
    [self.navigationItem setRightBarButtonItem:refreshButton animated:YES];
    
    // [self layoutRoutesListControl];
    
    self.model = [[BSRoutesModel alloc] init];
    
    [_model addObserver:self
             forKeyPath:@"routes" 
                options:(NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld) 
                context:@selector(reloadRoutes)];
    
    [_model addObserver:self 
             forKeyPath:@"error" 
                options:(NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld) 
                context:@selector(operationDidFail)];
    
    [self requestRouteList];
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

- (void)layoutRoutesListControl {
//    NSArray *routeListControlItems = [NSArray arrayWithObjects:NSLocalizedString(@"All Routes", @"All Routes"),
//                                        NSLocalizedString(@"Favorites", @"Favorites"), nil];
//
//    self.routesListControl = [[UISegmentedControl alloc] initWithItems:routeListControlItems];
//    [_routesListControl setFrame:CGRectMake(0.0f, 0.0f, 305.0f, 30.0f)];
//    [_routesListControl setSegmentedControlStyle:UISegmentedControlStyleBar];
//    [_routesListControl setSelectedSegmentIndex:0];
//    
//    [_routesListControl addTarget:self action:@selector(switchRoutesList:) forControlEvents:UIControlEventValueChanged];
//    
//    // FIXME: no idea why this causes layout issues on the pad
//    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone) {
//        [_routesListControl setAutoresizingMask:(UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight)];
//    }
//    
//    UIBarButtonItem *buttonItem = [[UIBarButtonItem alloc] initWithCustomView:self.routesListControl];
//    [_toolbar setItems:@[buttonItem]];    
//    [_toolbar setNeedsLayout];
}

#pragma mark - UITableView
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.model.routes.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    BSRoute *route = self.model.routes[indexPath.row];
    CGRect textFrame = [self sizeForString:route.endpoints];
    float padding = ROUTE_CELL_DEFAULT_HEIGHT - ROUTE_ENDPOINTS_DEFAULT_HEIGHT;
    
    if (textFrame.size.height <= ROUTE_ENDPOINTS_DEFAULT_HEIGHT) {
        return ROUTE_CELL_DEFAULT_HEIGHT;
    } else {
        // needs to be mod 2 for pixel alignment?
        // here padding represents the additional space
        // needs for route title label
        return textFrame.size.height + padding;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *RouteCellIdentifier = @"BSRouteTableViewCell";
    
    BSRoutesTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:RouteCellIdentifier];
    if (cell == nil) {
        cell = [[BSRoutesTableViewCell alloc] init];
    }
    
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

- (CGRect)sizeForString:(NSString *)string {
    // where 300 is the width of the label
    CGSize constraint = CGSizeMake(269.0f, 20000.0f);
    CGSize size = [string sizeWithFont:[BSAppTheme twelvePointlabelFont] constrainedToSize:constraint lineBreakMode:NSLineBreakByWordWrapping];
    CGRect commentTextRect = CGRectMake(11.0f, 32.0f, 269.0f, size.height);
    
    return commentTextRect;
}

#pragma mark - KVO
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
    SEL selector = (SEL)context;
    
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Warc-performSelector-leaks"
    [self performSelector:selector];
#pragma clang diagnostic pop
}

#pragma mark - Route Loading and Model Observing
- (void)requestRouteList {
    [_model requestRouteList];
}

- (void)reloadRoutes {
    // FIXME: you are needlessly animating in 40 rows
    // only animate in the rows which are visible.
    NSUInteger routesToAdd = self.model.routes.count;
    NSUInteger routesToDelete = [self.tableView numberOfRowsInSection:0];
    
    [self.tableView beginUpdates];
    
    for (NSUInteger i = 0; i < routesToDelete; i++) {
        NSArray *delete = @[[NSIndexPath indexPathForRow:i inSection:0]];
        [self.tableView deleteRowsAtIndexPaths:delete withRowAnimation:UITableViewRowAnimationBottom];
    }
    
    for (NSUInteger i = 0; i < routesToAdd; i++) {
        NSArray *insert = @[[NSIndexPath indexPathForRow:i inSection:0]];
        [self.tableView insertRowsAtIndexPaths:insert withRowAnimation:UITableViewRowAnimationTop];
    }
    
    [self.tableView endUpdates];
}

- (void)operationDidFail {    
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Error", @"error alert view title") 
                                                    message:_model.error.localizedDescription 
                                                   delegate:nil 
                                          cancelButtonTitle:NSLocalizedString(@"OK", @"ok button title") 
                                          otherButtonTitles:nil];
    [alert show];
}

- (void)switchRoutesList:(id)sender {
    // TODO implement
}

@end
