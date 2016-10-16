//
//  SignInViewController.m
//  AusTick
//
//  Created by Jeremy Siao Him Fa on 15/10/2016.
//  Copyright © 2016 MurdochUniversity. All rights reserved.
//

#import "SignInViewController.h"

@interface SignInViewController ()

@property(nonatomic) double lat;
@property(nonatomic) double lon;
@property(nonatomic) NSString *email;
@property(nonatomic) NSString *phone;
@property(nonatomic) NSString *symptom;
@property(nonatomic) NSString *date;

@end

@implementation SignInViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self
                                                                          action:@selector(dismissKeyboard)];
    
    [self.view addGestureRecognizer:tap];
}

-(void)dismissKeyboard {
    [self.txt_id resignFirstResponder];
    [self.txt_passcode resignFirstResponder];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

/* 
 SENDS INFO TO NEXT CONTROLLER TO DISPLAY
 */
-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if([segue.identifier isEqualToString:@"goToUpdate"]){
        UpdateViewController *controller = (UpdateViewController *)segue.destinationViewController;
        controller.lat = self.lat;
        controller.lon = self.lon;
        controller.email = self.email;
        controller.phone = self.phone;
        controller.symptom = self.symptom;
        controller.date = self.date;
    }
}

- (IBAction)signIn:(id)sender {
    
    //REMOVE THIS LINE
    [self performSegueWithIdentifier:@"goToUpdate" sender:self];
    
    NSURL *url = [NSURL URLWithString:@"austick.auspollster.xyz/api/login"];
    NSURLSessionConfiguration *config = [NSURLSessionConfiguration defaultSessionConfiguration];
    NSURLSession *session = [NSURLSession sessionWithConfiguration:config];
    
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:url];
    request.HTTPMethod = @"POST";
    
    NSDictionary *dictionary = @{@"id": _txt_id.text, @"passcode": _txt_passcode.text};
    NSError *error = nil;
    NSData *data = [NSJSONSerialization dataWithJSONObject:dictionary
                                                   options:kNilOptions error:&error];
    
    if (!error) {
        NSURLSessionUploadTask *uploadTask = [session uploadTaskWithRequest:request
                                                                   fromData:data completionHandler:^(NSData *data,NSURLResponse *response,NSError *error) {
                                                                       NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *) response;
                                                                       long statusCode = (long)([httpResponse statusCode]);
                                                                       if (statusCode == 200) {
                                                                           NSDictionary *results = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
                                                                           NSDictionary *resultsDictionary = [[results objectForKey:@"results"] objectAtIndex:0];
                                                                           if (resultsDictionary[@"results"] == @"true") {
                                                                               
                                                                               
                                                                               /*
                                                                                PARSE RECEIVED JSON
                                                                                
                                                                                @property(nonatomic) double *lat;
                                                                               @property(nonatomic) double *lon;
                                                                               @property(nonatomic) NSString *email;
                                                                               @property(nonatomic) NSString *phone;
                                                                               @property(nonatomic) NSString *symptom;
                                                                               @property(nonatomic) NSString *date;
                                                                                */
                                                                               
                                                                               [self performSegueWithIdentifier:@"goToUpdate" sender:self];
                                                                           }
                                                                    
                                                                       }
                                                                       
                                                                   }];
        [uploadTask resume];
        
    }
}
@end
