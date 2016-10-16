//
//  TickAnnotation.m
//  AusTick
//
//  Created by Jeremy Siao Him Fa on 15/10/2016.
//  Copyright © 2016 MurdochUniversity. All rights reserved.
//

#import "TickAnnotation.h"

@implementation TickAnnotation



- (id)initWithTitle:(NSString *)newTitle subtitle:(NSString *)newSubtitle location:(CLLocationCoordinate2D)location {
    
    self = [super init];
    if (self) {
        self.title = newTitle;
        self.coordinate = location;
        self.subtitle = newSubtitle;
    }
    
    return self;
}

- (MKAnnotationView *)annotationView {
    
    MKAnnotationView *annotationView = [[MKAnnotationView alloc] initWithAnnotation:self reuseIdentifier: tickAnnotationIdentifier];
    annotationView.enabled = YES;
    annotationView.canShowCallout = YES;
    annotationView.rightCalloutAccessoryView = [UIButton buttonWithType:UIButtonTypeDetailDisclosure];
    
    return annotationView;
    
}

@end
