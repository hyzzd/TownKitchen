//
//  AddressInputViewController.m
//  TownKitchen
//
//  Created by Peter Bai on 3/8/15.
//  Copyright (c) 2015 The Town Kitchen. All rights reserved.
//

#import "AddressInputViewController.h"
#import <GoogleKit.h>
#import "UIImage+SolidColors.h"
#import "UIColor+TKColorPalette.h"

@interface AddressInputViewController () <UITableViewDataSource, UITableViewDelegate, UISearchBarDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) IBOutlet UISearchBar *searchBar;
@property (strong, nonatomic) GKPlaceAutocompleteQuery *autocompleteQuery;
@property NSTimer *autoCompleteTimer;  // timer to avoid searching too often

@property (strong, nonatomic) NSMutableArray *searchResults;

@end

@implementation AddressInputViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setup];
}

- (void)viewDidAppear:(BOOL)animated {
    [self.searchBar becomeFirstResponder];
}

#pragma mark Custom Setters

- (void)setCurrentLocation:(CLLocation *)currentLocation {
    _currentLocation = [currentLocation copy];
}

#pragma mark Private Methods

- (void)setup {
    // Set up search bar
    self.searchBar.delegate = self;
    self.searchBar.text = self.initialSearchTerm;
    [[UITextField appearanceWhenContainedIn:[UISearchBar class], nil]
     setDefaultTextAttributes:@{
                                NSFontAttributeName: [UIFont fontWithName:@"AvenirNext-Regular" size:14],
                                NSForegroundColorAttributeName: [UIColor colorWithWhite:0.1 alpha:1.0]
                                }];

    NSDictionary *attributes =
    [NSDictionary dictionaryWithObjectsAndKeys:
     [UIColor whiteColor], NSForegroundColorAttributeName,
     [UIFont fontWithName:@"AvenirNext-Regular" size:17], NSFontAttributeName,
     nil];
    [[UIBarButtonItem appearanceWhenContainedIn:[UISearchBar class], nil]
     setTitleTextAttributes:attributes forState:UIControlStateNormal];
    [[UIBarButtonItem appearanceWhenContainedIn:[UISearchBar class], nil]
     setTitleTextAttributes:attributes forState:UIControlStateHighlighted];
    
    // Set up navigation bar
    self.navigationItem.titleView = self.searchBar;
    self.navigationController.navigationBar.translucent = NO;;
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageWithColor:[UIColor TKRedColor]] forBarMetrics:UIBarMetricsDefault];
    
    // Set up tableview
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    
    // Set up GoogleKit
    [GKQuery provideAPIKey:@"AIzaSyDJtsfCfGzZIpPu5dV9OXtDU3TmY_iJw70"];
//    [GKQuery loggingEnabled:YES];
    self.autocompleteQuery = [GKPlaceAutocompleteQuery query];
    
    // Initialize search results
    self.searchResults = [NSMutableArray array];
}

- (void)runDelayedSearch {
    [self.autoCompleteTimer invalidate];
    self.autoCompleteTimer = [NSTimer scheduledTimerWithTimeInterval:0.6f
                                                              target:self
                                                            selector:@selector(searchAutocomplete)
                                                            userInfo:nil
                                                             repeats:NO];
}
                              
- (void)searchAutocomplete {
    [self.searchResults removeAllObjects];
    
    self.autocompleteQuery.input = self.searchBar.text;
    self.autocompleteQuery.coordinate = self.currentLocation.coordinate;
    self.autocompleteQuery.radius = 200000;
    self.autocompleteQuery.components = @[ @"country:us" ];
    self.autocompleteQuery.types = @[@""];  // use empty string to return all types

    [self.autocompleteQuery fetchPlaces:^(id results, NSError *error) {
        [self.searchResults addObjectsFromArray:results];
        [self.tableView reloadData];
    }];
}

#pragma mark UISearchBarDelegate Methods

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText {
    NSString *parsedSearchText = [self.searchBar.text stringByReplacingOccurrencesOfString:@" " withString:@""];
    if (parsedSearchText.length != 0) {
        [self runDelayedSearch];
    }
}

- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar {
    [self.delegate addressInputViewController:self shouldDismissAddressInputNavigationController:self.navigationController];
}

#pragma mark Table view methods

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.searchResults.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"SearchCell"];
    GKPlaceAutocomplete *placeResult = self.searchResults[indexPath.row];
    cell.textLabel.text = [(GKPlaceAutocompleteTerm *)[placeResult.terms firstObject] value];
    cell.textLabel.font = [UIFont fontWithName:@"AvenirNext-Regular" size:16];
    cell.textLabel.textColor = [UIColor colorWithWhite:0.1 alpha:1.0];
    
    cell.detailTextLabel.text = placeResult.textDescription;
    cell.detailTextLabel.font = [UIFont fontWithName:@"AvenirNext-Regular" size:12];
    cell.detailTextLabel.textColor = [UIColor colorWithWhite:0.2 alpha:1.0];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    GKPlaceAutocomplete *placeResult = self.searchResults[indexPath.row];
    GKPlaceDetailsQuery *query = [GKPlaceDetailsQuery query];
    query.placeId = placeResult.placeId;
    [query fetchDetails:^(GKPlaceDetails *place, NSError *error) {
        [self.delegate addressInputViewController:self didSelectPlaceDetails:place];
        [self.delegate addressInputViewController:self shouldDismissAddressInputNavigationController:self.navigationController];
    }];
}

#pragma mark System Methods

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
