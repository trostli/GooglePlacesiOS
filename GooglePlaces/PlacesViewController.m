//
//  PlacesViewController.m
//  GooglePlaces
//
//  Created by Daniel Trostli on 6/24/15.
//  Copyright (c) 2015 Daniel Trostli. All rights reserved.
//

#import "PlacesViewController.h"
#import "PlacesDetailsViewController.h"
#import "PlaceTableViewCell.h"
#import "SPGooglePlacesAutocomplete.h"
#import "INTULocationManager.h"
#import "SVProgressHUD.h"

@interface PlacesViewController () <UIViewControllerTransitioningDelegate, UISearchBarDelegate, UITableViewDataSource, UITableViewDelegate>
{
    SPGooglePlacesAutocompleteQuery *_query;
    CLLocation *_userLocation;
}
@property (nonatomic, strong) NSArray *searchResultPlaces;
@property (weak, nonatomic) IBOutlet UISearchBar *placeSearchBar;
@property (weak, nonatomic) IBOutlet UITableView *placeAutocompleteResultsTableView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *switchViewHeight;
@property (weak, nonatomic) IBOutlet UISwitch *useLocationSwitch;

@end

@implementation PlacesViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.placeSearchBar.placeholder = @"Search or Address";
    self.navigationItem.title = @"myPlaces";
    self.switchViewHeight.constant = 0;
    _query = [[SPGooglePlacesAutocompleteQuery alloc] initWithApiKey:@"AIzaSyAGsKvwzGeKhOfo8nUCUGwndjyoPhMLZfE"];
}

- (IBAction)hitLocationSwitch:(id)sender {
    if (self.useLocationSwitch.on) {
        [self getUserLocationn];
    }
}

- (void)getUserLocationn {
    [SVProgressHUD show];
    
    INTULocationManager *locMgr = [INTULocationManager sharedInstance];
    [locMgr requestLocationWithDesiredAccuracy:INTULocationAccuracyBlock timeout:10.0 delayUntilAuthorized:YES block:^(CLLocation *currentLocation, INTULocationAccuracy achievedAccuracy, INTULocationStatus status) {
        if (status == INTULocationStatusSuccess) {
            _userLocation = currentLocation;
        }
        else if (status == INTULocationStatusTimedOut) {
            [self showAlert:@"Location status timed out"];
            self.useLocationSwitch.on = NO;
        } else if (status == INTULocationStatusServicesDisabled) {
            [self showAlert:@"Please enable Location Services"];
            self.useLocationSwitch.on = NO;
        } else if (status == INTULocationStatusServicesDenied) {
            [self showAlert:@"Please allow mySpaces to use your location in Privacy Settings"];
            self.useLocationSwitch.on = NO;
        } else if (status == INTULocationStatusServicesRestricted) {
            [self showAlert:@"You do not have permission to enable location services"];
            self.useLocationSwitch.on = NO;
        }
        else {
            [self showAlert:@"An unknown error occured when trying to determine your location"];
            self.useLocationSwitch.on = NO;
        }
        [SVProgressHUD dismiss];
    }];

}

- (void) showAlert:(NSString *)errorMessage {
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error"
                                                    message:errorMessage
                                                   delegate:nil
                                          cancelButtonTitle:@"OK"
                                          otherButtonTitles:nil, nil];
    [alert show];
}

#pragma mark - UITableViewDataSource methods

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.searchResultPlaces count];
}

- (SPGooglePlacesAutocompletePlace *)placeAtIndexPath:(NSIndexPath *)indexPath {
    return self.searchResultPlaces[indexPath.row];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"PlaceAutocompleteResultCell";
    PlaceTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (!cell) {
        cell = [[PlaceTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    }
    
    cell.nameLabel.text = [self placeAtIndexPath:indexPath].name;
    return cell;
}

#pragma mark - UISearchBarDelegate methods

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText
{
    if ([searchText isEqualToString:@""]) {
        return;
    }

    if (_userLocation != nil && self.useLocationSwitch.on == YES) {
        _query.location = _userLocation.coordinate;
        _query.radius = 2000.0;
    } else {
        _query.radius = MAXFLOAT;
    }
    _query.input = searchText;
    _query.language = @"en";
    
    [SVProgressHUD show];
    [_query fetchPlaces:^(NSArray *places, NSError *error) {
        if (error) {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Could not fetch Places"
                                                            message:error.localizedDescription
                                                           delegate:nil
                                                  cancelButtonTitle:@"OK"
                                                  otherButtonTitles:nil, nil];
            [alert show];
        } else {
            self.searchResultPlaces = places;
            [self.placeAutocompleteResultsTableView reloadData];
        }
        [SVProgressHUD dismiss];
    }];

}

- (void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar {
    [UIView animateWithDuration:0.5f
                     animations:^{
                         self.switchViewHeight.constant = 52.0f;
                         [self.view layoutIfNeeded]; // Called on parent view
                     }];
    
}

- (void)searchBarTextDidEndEditing:(UISearchBar *)searchBar {
    [UIView animateWithDuration:0.5f
                     animations:^{
                         self.switchViewHeight.constant = 0;
                         [self.view layoutIfNeeded]; // Called on parent view
                     }];
}

#pragma mark - UITableViewDelegate protocol methods

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    SPGooglePlacesAutocompletePlace *place = [self.searchResultPlaces objectAtIndex:indexPath.row];
    
    [self performSegueWithIdentifier:@"viewDetails" sender:place];
}

#pragma mark - Navigation

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"viewDetails"]) {
        if ([segue.destinationViewController isKindOfClass:[PlacesDetailsViewController class]]) {
            PlacesDetailsViewController *pdvc = (PlacesDetailsViewController *)segue.destinationViewController;
            pdvc.place = sender;
        }
    }
}

@end
