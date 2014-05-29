//
//  MeasurementSensitivityVC.m
//  GaitCheck
//
//  Created by Jesse Clayburgh on 5/28/14.
//  Copyright (c) 2014 Jesse Clayburgh. All rights reserved.
//

#import "MeasurementSensitivityVC.h"

#define COMPONENTRECT CGRectMake(45, 185, DK_SLIDER_SIZE-90, DK_SLIDER_SIZE-90)

@interface MeasurementSensitivityVC ()

@end

@implementation MeasurementSensitivityVC
//@synthesize guidedCSlider;

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    self.guidedCSlider = [[DKCircularSlider alloc] initWithFrame:COMPONENTRECT
                                               withElements:@[@"1",@"2",@"3",@"4",@"5",@"6",@"7"]
                                           withContentImage:nil
                                                  withTitle:@"Sensitivity"
                                                 withTarget:self usingSelector:@selector(sliderChange:)];
    [[self view] addSubview:self.guidedCSlider];
    [[self view] setBackgroundColor:[UIColor grayColor]];
}

-(void)sliderChange:(DKCircularSlider *)sender
{
    NSLog(@"Value Changed (%@)",[sender getTextValue]);
}


@end
