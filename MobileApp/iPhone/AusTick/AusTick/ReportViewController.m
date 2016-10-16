//
//  ReportViewController.m
//  AusTick
//
//  Created by Jeremy Siao Him Fa on 15/10/2016.
//  Copyright © 2016 MurdochUniversity. All rights reserved.
//

#import "ReportViewController.h"

@interface ReportViewController ()

@property (nonatomic) float lat;
@property (nonatomic) float lon;
@property (nonatomic) BOOL first;

@end

@implementation ReportViewController

- (void)viewWillAppear:(BOOL)animated {
    [self.symptomBox setText:@"Enter your symptoms."];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.first = YES;
    NSDate *currentDate = [NSDate date];
    [_datePicker setDate:currentDate];
    
    self.mapView.delegate = self;
    [self startLocationManager];
    
    self.scrollView.delegate = self;
    self.scrollView.contentSize = CGSizeMake(self.view.bounds.size.width, self.view.bounds.size.height);
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self
                                                                          action:@selector(dismissKeyboard)];
    
    [self.view addGestureRecognizer:tap];
    
    
    UILongPressGestureRecognizer *lpgr = [[UILongPressGestureRecognizer alloc]
                                          initWithTarget:self action:@selector(handleLongPress:)];
    lpgr.minimumPressDuration = 1.5; //user needs to press for 2 seconds
    [self.mapView addGestureRecognizer:lpgr];
}

- (void)handleLongPress:(UIGestureRecognizer *)gestureRecognizer
{
    if (gestureRecognizer.state != UIGestureRecognizerStateBegan)
        return;
    
    CGPoint touchPoint = [gestureRecognizer locationInView:self.mapView];
    CLLocationCoordinate2D touchMapCoordinate =
    [self.mapView convertPoint:touchPoint toCoordinateFromView:self.mapView];
    
    TickAnnotation *annot = [[TickAnnotation alloc] init];
    annot.coordinate = touchMapCoordinate;
    
    [self.mapView removeAnnotations:_mapView.annotations];
    [self.mapView addAnnotation:annot];
    self.lat = annot.coordinate.latitude;
    self.lon = annot.coordinate.longitude;
}

-(void)dismissKeyboard {
    [self.emailText resignFirstResponder];
    [self.phoneText resignFirstResponder];
}


- (void)startLocationManager
{
    self.locationManager = [[CLLocationManager alloc] init];
    self.locationManager.delegate = self;
    self.locationManager.distanceFilter = kCLDistanceFilterNone;
    self.locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    
    [self.locationManager startUpdatingLocation];
    [self.locationManager requestWhenInUseAuthorization];
}

-(void)mapView:(MKMapView *)mapView didUpdateUserLocation:(MKUserLocation *)userLocation
{
    MKCoordinateRegion mapRegion;
    mapRegion.center = self.mapView.userLocation.coordinate;
    mapRegion.span = MKCoordinateSpanMake(0.005, 0.005);
    [self.mapView setRegion:mapRegion animated: YES];
    
    if (self.first == TRUE) {
        TickAnnotation *annot = [[TickAnnotation alloc] init];
        annot.coordinate = self.mapView.userLocation.coordinate;
        
        [self.mapView addAnnotation:annot];
        self.lat = annot.coordinate.latitude;
        self.lon = annot.coordinate.longitude;
        self.first = FALSE;
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)submit:(id)sender {
    NSURL *url = [NSURL URLWithString:@"austick.auspollster.xyz/api/submit"];
    NSURLSessionConfiguration *config = [NSURLSessionConfiguration defaultSessionConfiguration];
    NSURLSession *session = [NSURLSession sessionWithConfiguration:config];
    
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:url];
    request.HTTPMethod = @"POST";
    
    NSDictionary *dictionary = @{@"email": _emailText.text, @"phone": _phoneText.text, @"symptom" : _symptomBox.text, @"date" : _datePicker.date, @"lat" : [[NSNumber alloc] initWithDouble:self.lat], @"lon": [[NSNumber alloc] initWithDouble:self.lon]};
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



/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
 
 austick.auspollster.xyz/api/submit
*/
@end
