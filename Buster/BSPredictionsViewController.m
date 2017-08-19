//
//  BSPredictionsViewController.m
//  Buster
//
//  Created by Andrew Shepard on 1/3/11.
//  Copyright © 2011-2017 Andrew Shepard. All rights reserved.
//

#import "BSPredictionsViewController.h"

#import "BSPredictionsModel.h"
#import "BSStop.h"

#import "BSPredictionMetaTableViewCell.h"

static void *myContext = &myContext;

@interface BSPredictionsViewController () <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) BSPredictionsModel *model;

@end

@implementation BSPredictionsViewController

- (instancetype)init {
    if (self = [super init]) {
        self.tableView = [[UITableView alloc] initWithFrame:CGRectZero];
        [_tableView setDelegate:self];
        [_tableView setDataSource:self];
        
        self.model = [[BSPredictionsModel alloc] init];
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
    
    [self.view addSubview:_tableView];
    [self setupTableViewConstraints];
    
    UIBarButtonItem *refreshButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemRefresh target:self action:@selector(refreshList:)];
    self.navigationItem.rightBarButtonItem = refreshButton;
    
    NSKeyValueObservingOptions options = NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld;
    
    [_model addObserver:self forKeyPath:@"predictions" options:options context:myContext];
    [_model addObserver:self forKeyPath:@"predictionMeta" options:options context:myContext];
    [_model addObserver:self forKeyPath:@"error" options:options context:myContext];
    
    assert(_stop != nil);
    
    [_model requestPredictionsForStop:self.stop];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [_tableView deselectRowAtIndexPath:[_tableView indexPathForSelectedRow] animated:YES];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return (section == 0) ? 1 : self.model.predictions.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    // return the prediction meta data cell with route/stop info
    if (indexPath.section == 0) {
        
        BSPredictionMetaTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"BSPredictionsInfoTableCell"];
        if (cell == nil) {
            cell = [[BSPredictionMetaTableViewCell alloc] init];
        }
        
        cell.routeNumberLabel.text = _model.predictionMeta[@"routeTitle"];
        cell.routeDirectionLabel.text = _model.predictionMeta[@"directionTitle"];
        cell.stopNameLabel.text = _model.predictionMeta[@"stopTitle"];
        
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        return cell;
    }
    
    // return a prediction cell with a time
    NSString *BSPredictionsCellIdentifier = @"BSPredictionsTimeTableCell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:BSPredictionsCellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:BSPredictionsCellIdentifier];
    }

    NSDictionary *dict = (NSDictionary *)self.model.predictions[indexPath.row];
    NSString *title = dict[@"minutes"];
    title = [title stringByAppendingFormat:@" %@", NSLocalizedString(@"minutes", @"minutes")];
    
    cell.textLabel.text = title;
    
    return cell;
}

- (void)configureCell:(BSPredictionMetaTableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath {
    cell.routeNumberLabel.text = _model.predictionMeta[@"routeTitle"];
    cell.routeDirectionLabel.text = _model.predictionMeta[@"directionTitle"];
    cell.stopNameLabel.text = _model.predictionMeta[@"stopTitle"];
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
    if (context == myContext) {
        if ([keyPath isEqualToString:@"predictions"]) {
            [self reloadPredictions];
        }
        else if ([keyPath isEqualToString:@"error"]) {
            [self refreshError];
        }
    }
    else {
        [super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
    }
}

- (void)reloadPredictions {
    [_tableView reloadData];
}

- (void)reloadPredictionMeta {
    NSIndexPath *path = [NSIndexPath indexPathForRow:0 inSection:0];
    [_tableView reloadRowsAtIndexPaths:@[path] withRowAnimation:UITableViewRowAnimationNone];
}

- (void)refreshError {
    if (self.model.error != nil) {
        NSString *title = NSLocalizedString(@"Error", @"error alert view title");
        NSString *message = self.model.error.localizedDescription;
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:title message:message preferredStyle:UIAlertControllerStyleAlert];
        
        [self presentViewController:alertController animated:YES completion:nil];
    }
}

- (void)refreshList:(id)sender {
    [_model requestPredictionsForStop:_stop];
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

