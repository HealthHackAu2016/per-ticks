//
//  UpdateViewController.m
//  AusTick
//
//  Created by Jeremy Siao Him Fa on 15/10/2016.
//  Copyright © 2016 MurdochUniversity. All rights reserved.
//

#import "UpdateViewController.h"

@interface UpdateViewController ()

@end

@implementation UpdateViewController

-(void)viewWillAppear:(BOOL)animated {
    _emailBox.text = self.email;
    _phoneBox.text = self.phone;
    _symptomBox.text = self.symptom;
    
    /* configure map and date */
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UILongPressGestureRecognizer *lpgr = [[UILongPressGestureRecognizer alloc]
                                          initWithTarget:self action:@selector(handleLongPress:)];
    lpgr.minimumPressDuration = 1.5; //user needs to press for 2 seconds
    [self.mapView addGestureRecognizer:lpgr];
    
    TickAnnotation *annot = [[TickAnnotation alloc] init];
    annot.coordinate = CLLocationCoordinate2DMake(self.lat, self.lon);
    
    [self.mapView addAnnotation:annot];
}

/*
  USED TO ADD ANNOTATIONS TO THE PLACE YOU WANT TO LOCATE
 */
- (void)handleLongPress:(UIGestureRecognizer *)gestureRecognizer
{
    if (gestureRecognizer.state != UIGestureRecognizerStateBegan)
        return;
    
    CGPoint touchPoint = [gestureRecognizer locationInView:self.mapView];
    CLLocationCoordinate2D touchMapCoordinate =
    [self.mapView convertPoint:touchPoint toCoordinateFromView:self.mapView];
    
    TickAnnotation *annot = [[TickAnnotation alloc] init];
    annot.coordinate = touchMapCoordinate;
    
    /* REMOVE PREVIOUS ANNOTATIONS */
    [self.mapView removeAnnotations:_mapView.annotations];
    [self.mapView addAnnotation:annot];
    self.lat = annot.coordinate.latitude;
    self.lon = annot.coordinate.longitude;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    NSDate *currentDate = [NSDate date];
    [_datePicker setDate:currentDate];
    self.mapView.delegate = self;
    [self startLocationManager];
    
    self.scrollView.delegate = self;
    self.scrollView.contentSize = CGSizeMake(self.view.bounds.size.width, self.view.bounds.size.height);
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self
                                                                          action:@selector(dismissKeyboard)];
    
    [self.view addGestureRecognizer:tap];

}


-(void)dismissKeyboard {
    [self.emailBox resignFirstResponder];
    [self.phoneBox resignFirstResponder];
}


/* MANAGES LOCATION OF THE PERSON*/
- (void)startLocationManager
{
    self.locationManager = [[CLLocationManager alloc] init];
    self.locationManager.delegate = self;
    self.locationManager.distanceFilter = kCLDistanceFilterNone; //whenever we move
    self.locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    
    [self.locationManager startUpdatingLocation];
    [self.locationManager requestWhenInUseAuthorization]; // Add This Line
    
    
}

-(void)mapView:(MKMapView *)mapView didUpdateUserLocation:(MKUserLocation *)userLocation
{
    MKCoordinateRegion mapRegion;
    mapRegion.center = self.mapView.userLocation.coordinate;
    mapRegion.span = MKCoordinateSpanMake(0.05, 0.05);
    [self.mapView setRegion:mapRegion animated: YES];
}

- (IBAction)submit:(id)sender {
    NSURL *url = [NSURL URLWithString:@"austick.auspollster.xyz/api/submit"];
    NSURLSessionConfiguration *config = [NSURLSessionConfiguration defaultSessionConfiguration];
    NSURLSession *session = [NSURLSession sessionWithConfiguration:config];
    
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:url];
    request.HTTPMethod = @"POST";
    
    NSDictionary *dictionary = @{@"email": _emailBox.text, @"phone": _phoneBox.text, @"symptom" : _symptomBox.text, @"date" : _datePicker.date, @"lat" : [[NSNumber alloc] initWithDouble:self.lat], @"lon": [[NSNumber alloc] initWithDouble:self.lon]};
    NSError *error = nil;
    NSData *data = [NSJSONSerialization dataWithJSONObject:dictionary
                                                   options:kNilOptions error:&error];
    
    if (!error) {
        NSURLSessionUploadTask *uploadTask = [session uploadTaskWithRequest:request
                                                                   fromData:data completionHandler:^(NSData *data,NSURLResponse *response,NSError *error) {
                                                                       // Handle response here
                                                                   }];
        [uploadTask resume];
        
    }

}

- (IBAction)cancel:(id)sender {
}


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
