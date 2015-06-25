//
//  PlacesViewController.m
//  GooglePlaces
//
//  Created by Daniel Trostli on 6/24/15.
//  Copyright (c) 2015 Daniel Trostli. All rights reserved.
//

#import "PlacesViewController.h"
#import "PlacesDetailsViewController.h"
#import "SPGooglePlacesAutocomplete.h"

//#import "DetailViewController.h"
//#import "PresentDetailTransition.h"
//#import "DismissDetailTransition.h"

@interface PlacesViewController () <UIViewControllerTransitioningDelegate, UISearchBarDelegate, UITableViewDataSource, UITableViewDelegate>

@property (weak, nonatomic) IBOutlet UISearchBar *placeSearchBar;
@property (weak, nonatomic) IBOutlet UITableView *placeAutocompleteResultsTableView;

@end

@implementation PlacesViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.navigationItem.title = @"myPlaces";

}

#pragma mark - UITableViewDataSource methods

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"PlaceAutocompleteResultCell" forIndexPath:indexPath];
    
//    HIPlaceAutocompleteResult *placeAutocompleteResult = [_placeAutocompleteResults objectAtIndex:indexPath.row];
//    
//    cell.textLabel.text = placeAutocompleteResult.placeDescription;
    
    return cell;
}

#pragma mark - UISearchBarDelegate methods

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText
{
    if ([searchText isEqualToString:@""]) {
        return;
    }
    
    SPGooglePlacesAutocompleteQuery *query = [[SPGooglePlacesAutocompleteQuery alloc] initWithApiKey:@"AIzaSyAGsKvwzGeKhOfo8nUCUGwndjyoPhMLZfE"];
    query.input = searchText; // search key word
    //query.location = CLLocationCoordinate2DMake(37.76999, -122.44696);  // user's current location
    //query.radius = 100.0;   // search addresses close to user
    query.language = @"en"; // optional
    //query.types = SPPlaceTypeGeocode; // Only return geocoding (address) results.
    [query fetchPlaces:^(NSArray *places, NSError *error) {
        NSLog(@"Places returned %@", places);
    }];
    
    [_placeAutocompleteResultsTableView reloadData];
}

#pragma mark - HIPlacesManagerDelegate protocol methods


//- (void)placesManager:(HIPlacesManager *)placesManager searchForPlaceAutocompleteResultsDidFailWithError:(NSError *)error
//{
//    NSString *alertViewTitle;
//    NSLog(@"Error: %@", error);
//    switch (error.code) {
//        case HIPlacesErrorZeroResults:
//            alertViewTitle = @"No results found!";
//            break;
//            
//        case HIPlacesErrorOverQueryLimit:
//            alertViewTitle = @"Over query limit!";
//            break;
//            
//        case HIPlacesErrorRequestDenied:
//            alertViewTitle = @"Request denied!";
//            break;
//            
//        case HIPlacesErrorInvalidRequest:
//            alertViewTitle = @"Invalid request!";
//            break;
//            
//        case HIPlacesErrorNotFound:
//            alertViewTitle = @"Not found!";
//            break;
//            
//        case HIPlacesErrorUnkownError:
//            alertViewTitle = @"Unknown error!";
//            break;
//            
//        case HIPlacesErrorInvalidJSON:
//            alertViewTitle = @"Invalid JSON!";
//            break;
//            
//        case HIPlacesErrorConnectionFailed:
//            alertViewTitle = @"Connection failed!";
//            break;
//            
//        default:
//            break;
//    }
//    
//    UIAlertView *alertView = [[UIAlertView alloc]
//                              initWithTitle:alertViewTitle
//                              message:nil
//                              delegate:nil
//                              cancelButtonTitle:@"OK"
//                              otherButtonTitles:nil];
//    [alertView show];
//}

#pragma mark - UITableViewDelegate protocol methods

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
//    HIPlaceAutocompleteResult *placeAutocompleteResult = [_placeAutocompleteResults objectAtIndex:indexPath.row];
//    
//    PlacesDetailsViewController *pdtvc = [[PlacesDetailsViewController alloc] initWithPlaceId:placeAutocompleteResult.placeId];
//    
//    [self.navigationController pushViewController:pdtvc animated:YES];
}

//
//- (id<UIViewControllerAnimatedTransitioning>)animationControllerForPresentedController:(UIViewController *)presented presentingController:(UIViewController *)presenting sourceController:(UIViewController *)source
//{
//    return [[PresentDetailTransition alloc] init];
//}
//
//- (id<UIViewControllerAnimatedTransitioning>)animationControllerForDismissedController:(UIViewController *)dismissed
//{
//    return [[DismissDetailTransition alloc] init];
//}


@end
