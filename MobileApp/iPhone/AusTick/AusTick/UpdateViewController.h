//
//  UpdateViewController.h
//  AusTick
//
//  Created by Jeremy Siao Him Fa on 15/10/2016.
//  Copyright © 2016 MurdochUniversity. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TickAnnotation.h"
@import MapKit;

@interface UpdateViewController : UIViewController <MKMapViewDelegate, CLLocationManagerDelegate, UIScrollViewDelegate>


@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;

@property (nonatomic,strong)CLLocationManager * locationManager;
@property (weak, nonatomic) IBOutlet MKMapView *mapView;
@property (weak, nonatomic) IBOutlet UITextField *emailBox;
@property (weak, nonatomic) IBOutlet UITextField *phoneBox;
@property (weak, nonatomic) IBOutlet UITextView *symptomBox;
@property (weak, nonatomic) IBOutlet UIDatePicker *datePicker;
- (IBAction)cancel:(id)sender;
- (IBAction)submit:(id)sender;


@property(nonatomic) double lat;
@property(nonatomic) double lon;
@property(nonatomic) NSString *email;
@property(nonatomic) NSString *phone;
@property(nonatomic) NSString *symptom;
@property(nonatomic) NSString *date;

@end
