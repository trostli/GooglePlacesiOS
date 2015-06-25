//
//  PlacesDetailsViewController.m
//  GooglePlaces
//
//  Created by Daniel Trostli on 6/24/15.
//  Copyright (c) 2015 Daniel Trostli. All rights reserved.
//

#import "PlacesDetailsViewController.h"
#import "SPGooglePlacesPlaceDetailQuery.h"
#import "SVProgressHUD.h"

@interface PlacesDetailsViewController ()
{
    SPGooglePlacesPlaceDetailQuery *_detailQuery;
    CLPlacemark *_placemark;
    NSString *_addressString;
    MKPointAnnotation *_selectedPlaceAnnotation;
}
@property (weak, nonatomic) IBOutlet MKMapView *mapView;
@property (weak, nonatomic) IBOutlet UILabel *addressLabel;

@end

@implementation PlacesDetailsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.navigationItem.title = @"Details";
    [SVProgressHUD show];
    [self.place resolveToPlacemark:^(CLPlacemark *placemark, NSString *addressString, NSError *error) {
        if (error) {
            NSLog(@"ERROR");
        } else {
            _addressString = addressString;
            [self updateAddress:addressString];
            _placemark = placemark;
            [self showPlaceOnMap:placemark];
            [SVProgressHUD dismiss];
        }
    }];
    
}

- (IBAction)directionsButtonPushed:(id)sender {
    [self openAddressinMaps:_placemark];
}


- (void)openAddressinMaps:(CLPlacemark *)placemark
{
    Class mapItemClass = [MKMapItem class];
    if (mapItemClass && [mapItemClass respondsToSelector:@selector(openMapsWithItems:launchOptions:)])
    {
        MKPlacemark *mkPlacemark = [[MKPlacemark alloc] initWithCoordinate:placemark.location.coordinate addressDictionary:nil];
        MKMapItem *mapItem = [[MKMapItem alloc] initWithPlacemark:mkPlacemark];
        [mapItem setName:self.addressLabel.text];
        [mapItem openInMapsWithLaunchOptions:nil];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)showPlaceOnMap:(CLPlacemark*)placemark
{
    [self addPlacemarkAnnotationToMap:placemark addressString:_addressString];
    MKCoordinateRegion region = MKCoordinateRegionMakeWithDistance(placemark.location.coordinate, 500, 500);
    [self.mapView setRegion:[self.mapView regionThatFits:region] animated:YES];
}

- (void)updateAddress:(NSString *)addressString {
    self.addressLabel.text = addressString;
}

- (void)addPlacemarkAnnotationToMap:(CLPlacemark *)placemark addressString:(NSString *)address {
    [self.mapView removeAnnotation:_selectedPlaceAnnotation];
    
    _selectedPlaceAnnotation = [[MKPointAnnotation alloc] init];
    _selectedPlaceAnnotation.coordinate = placemark.location.coordinate;
    _selectedPlaceAnnotation.title = address;
    [self.mapView addAnnotation:_selectedPlaceAnnotation];
}

#pragma mark MKMapView Delegate

- (MKAnnotationView *)mapView:(MKMapView *)mapViewIn viewForAnnotation:(id <MKAnnotation>)annotation {
    if (mapViewIn != self.mapView || [annotation isKindOfClass:[MKUserLocation class]]) {
        return nil;
    }
    static NSString *annotationIdentifier = @"SPGooglePlacesAutocompleteAnnotation";
    MKPinAnnotationView *annotationView = (MKPinAnnotationView *)[self.mapView dequeueReusableAnnotationViewWithIdentifier:annotationIdentifier];
    if (!annotationView) {
        annotationView = [[MKPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:annotationIdentifier];
    }
    annotationView.animatesDrop = YES;
    annotationView.canShowCallout = YES;
        
    return annotationView;
}

- (void)mapView:(MKMapView *)mapView didAddAnnotationViews:(NSArray *)views {
    // Whenever we've dropped a pin on the map, immediately select it to present its callout bubble.
    [self.mapView selectAnnotation:_selectedPlaceAnnotation animated:YES];
}

@end
