//
//  SignInViewController.h
//  AusTick
//
//  Created by Jeremy Siao Him Fa on 15/10/2016.
//  Copyright © 2016 MurdochUniversity. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UpdateViewController.h"
@import MapKit;

@interface SignInViewController : UIViewController
@property (weak, nonatomic) IBOutlet UITextField *txt_id;
@property (weak, nonatomic) IBOutlet UITextField *txt_passcode;
- (IBAction)signIn:(id)sender;

@end
