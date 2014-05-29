//
//  LiftOffVC.m
//  GaitCheck
//
//  Created by Jesse Clayburgh on 5/28/14.
//  Copyright (c) 2014 Jesse Clayburgh. All rights reserved.
//

#import "LiftOffSettingsVC.h"
#import "UserPreferencesKeys.h"

@interface LiftOffSettingsVC ()

@end

@implementation LiftOffSettingsVC

- (void)viewDidLoad
{
    [super viewDidLoad];
    //    NSLog(@"Contact Sensitivity: %f", [self userDefaultsValue]);
    NSLog(@"%f", [UserDefaultsHelper liftoffSensitivity]);
    [self.guidedCSlider movehandleToValue:[UserDefaultsHelper liftoffSensitivity]];
    // Do any additional setup after loading the view.
}

-(void)sliderChange:(DKCircularSlider *)sender
{
    if (![[sender getTextValue] isEqual: @""]) {
        [UserDefaultsHelper setLiftoffSensitivity:[sender getTextValue]];
    }
}

@end
