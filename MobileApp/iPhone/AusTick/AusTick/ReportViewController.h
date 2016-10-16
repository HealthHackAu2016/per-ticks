//
//  ReportViewController.h
//  AusTick
//
//  Created by Jeremy Siao Him Fa on 15/10/2016.
//  Copyright © 2016 MurdochUniversity. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TickAnnotation.h"
@import MapKit;
@import CoreLocation;

@interface ReportViewController : UIViewController <UIScrollViewDelegate, MKMapViewDelegate, CLLocationManagerDelegate>

@property (strong, nonatomic) IBOutlet UIScrollView *scrollView;

@property (weak, nonatomic) IBOutlet MKMapView *mapView;
@property (nonatomic,strong)CLLocationManager * locationManager;

@property (weak, nonatomic) IBOutlet UIDatePicker *datePicker;
@property (weak, nonatomic) IBOutlet UITextView *symptomBox;
@property (weak, nonatomic) IBOutlet UITextField *emailText;
@property (weak, nonatomic) IBOutlet UITextField *phoneText;
- (IBAction)submit:(id)sender;

@end
