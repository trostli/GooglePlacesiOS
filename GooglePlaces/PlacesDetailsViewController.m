//
//  PlacesDetailsViewController.m
//  GooglePlaces
//
//  Created by Daniel Trostli on 6/24/15.
//  Copyright (c) 2015 Daniel Trostli. All rights reserved.
//

#import "PlacesDetailsViewController.h"
#import <MapKit/MapKit.h>

@interface PlacesDetailsViewController ()
{
    NSString *_placeID;
    CLLocationCoordinate2D _location;
}
@property (weak, nonatomic) IBOutlet MKMapView *mapView;
@property (weak, nonatomic) IBOutlet UILabel *addressLabel;

@end

@implementation PlacesDetailsViewController

- (id)initWithPlaceId:(NSString *)placeId
{
    self = [super init];
    if (self) {
        _placeID = placeId;
    }
    
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.navigationItem.title = @"Details";
    
//    placeDetailsRequest.key = @"AIzaSyAGsKvwzGeKhOfo8nUCUGwndjyoPhMLZfE";
//    placeDetailsRequest.placeId = _placeID;
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)showPlaceOnMap
{
    MKCoordinateRegion region = MKCoordinateRegionMakeWithDistance(_location, 500, 500);
    [self.mapView setRegion:[self.mapView regionThatFits:region] animated:YES];
}

- (void)updateAddress {
//    self.addressLabel.text = _placeDetailsResult.formattedAddress;
}


//- (void)placesManager:(HIPlacesManager *)placesManager searchForPlaceDetailsResultDidFailWithError:(NSError *)error
//{
//    NSString *alertViewTitle;
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


@end
