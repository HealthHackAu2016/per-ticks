//
//  MapViewController.h
//  AusTick
//
//  Created by Jeremy Siao Him Fa on 15/10/2016.
//  Copyright © 2016 MurdochUniversity. All rights reserved.
//

#import <UIKit/UIKit.h>
@import MapKit;

@interface MapViewController : UIViewController <MKMapViewDelegate, CLLocationManagerDelegate>

@property (weak, nonatomic) IBOutlet MKMapView *mapView;
@property (nonatomic,strong)CLLocationManager * locationManager;

@end
