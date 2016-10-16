//
//  MainViewController.m
//  AusTick
//
//  Created by Jeremy Siao Him Fa on 15/10/2016.
//  Copyright © 2016 MurdochUniversity. All rights reserved.
//

#import "MainViewController.h"

@interface MainViewController ()

@end

@implementation MainViewController

- (void)viewWillAppear:(BOOL)animated {
    int radius = 10;
    self.btnReport.layer.cornerRadius = radius;
    self.btnReport.clipsToBounds = YES;
    
    self.btnViewMap.layer.cornerRadius = radius;
    self.btnViewMap.clipsToBounds = YES;
    
    self.viewCentres.layer.cornerRadius = radius;
    self.viewCentres.clipsToBounds = YES;
    
    self.update.layer.cornerRadius = radius;
    self.update.clipsToBounds = YES;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
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

@end
