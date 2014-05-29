//
//  ContactSettingsVC.m
//  GaitCheck
//
//  Created by Jesse Clayburgh on 5/28/14.
//  Copyright (c) 2014 Jesse Clayburgh. All rights reserved.
//

#import "ContactSettingsVC.h"

@interface ContactSettingsVC ()

@end

@implementation ContactSettingsVC

- (void)viewDidLoad
{
    [super viewDidLoad];
//    NSLog(@"Contact Sensitivity: %f", [self userDefaultsValue]);
    NSLog(@"%f", [UserDefaultsHelper contactSensitivity]);
    [self.guidedCSlider movehandleToValue:[UserDefaultsHelper contactSensitivity]];
    // Do any additional setup after loading the view.
}

-(void)sliderChange:(DKCircularSlider *)sender
{
    if (![[sender getTextValue] isEqual: @""]) {
        [UserDefaultsHelper setContactSensitivity:[sender getTextValue]];
    }
}

@end
