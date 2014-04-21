//
//  FoodMapViewController.h
//  PinFood
//
//  Created by Tanaka Koichi on 2014/04/08.
//  Copyright (c) 2014年 Tanaka Koichi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import <CoreLocation/CoreLocation.h>

@interface FoodMapViewController : UIViewController<MKMapViewDelegate, CLLocationManagerDelegate> {
	
    MKMapView *mapView;
    NSMutableArray *mapAnnotations;
	UIView *thumbnailBaseView;
	UIView *thumbnailAreaView;
    CLLocationManager *locationManager;
}
@property(nonatomic,retain)CLLocationManager *locationManager;
@property (nonatomic, retain) MKMapView *mapView;
@property (nonatomic, retain) NSMutableArray *mapAnnotations;
@property (nonatomic, retain) UIView *thumbnailBaseView;
@property (nonatomic, retain) UIView *thumbnailAreaView;

- (void)addAnnotations;


@end
