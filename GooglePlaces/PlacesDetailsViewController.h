//
//  PlacesDetailsViewController.h
//  GooglePlaces
//
//  Created by Daniel Trostli on 6/24/15.
//  Copyright (c) 2015 Daniel Trostli. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>
#import "SPGooglePlacesAutocomplete.h"

@interface PlacesDetailsViewController : UIViewController <MKMapViewDelegate>
@property (nonatomic, strong) SPGooglePlacesAutocompletePlace *place;
@end
