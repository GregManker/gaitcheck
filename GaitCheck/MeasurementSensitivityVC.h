//
//  MeasurementSensitivityVC.h
//  GaitCheck
//
//  Created by Jesse Clayburgh on 5/28/14.
//  Copyright (c) 2014 Jesse Clayburgh. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DKCircularSlider.h"
#import "UserPreferencesKeys.h"
#import "UserDefaultsHelper.h"

@interface MeasurementSensitivityVC : UIViewController

@property (nonatomic,retain) DKCircularSlider *guidedCSlider;

@end
