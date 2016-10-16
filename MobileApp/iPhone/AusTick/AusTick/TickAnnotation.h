//
//  TickAnnotation.h
//  AusTick
//
//  Created by Jeremy Siao Him Fa on 15/10/2016.
//  Copyright © 2016 MurdochUniversity. All rights reserved.
//

#import <Foundation/Foundation.h>
@import MapKit;

static NSString *tickAnnotationIdentifier = @"tickAnnotationIdentifier";


@interface TickAnnotation : NSObject <MKAnnotation>

@property (copy, nonatomic) NSString *title;
@property (copy, nonatomic) NSString *subtitle;
@property (nonatomic) CLLocationCoordinate2D coordinate;


- (id)initWithTitle:(NSString *)newTitle subtitle:(NSString *)newSubtitle location:(CLLocationCoordinate2D)location;
- (MKAnnotationView *)annotationView;

@end
