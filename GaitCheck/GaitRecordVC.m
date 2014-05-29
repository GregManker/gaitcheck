//
//  GaitRecordVC.m
//  GaitCheck
//
//  Created by Jesse Clayburgh on 5/28/14.
//  Copyright (c) 2014 Jesse Clayburgh. All rights reserved.
//

#import "GaitRecordVC.h"
#import <CoreMotion/CoreMotion.h>

#define mainAsyncQ dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)

@interface GaitRecordVC () <UIAccelerometerDelegate>
@property (weak, nonatomic) IBOutlet UILabel *xLabel;
@property (weak, nonatomic) IBOutlet UILabel *yLabel;
@property (weak, nonatomic) IBOutlet UILabel *zLabel;

@property (strong, nonatomic) CMMotionManager *mainManager;

@end

@implementation GaitRecordVC

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.mainManager = [[CMMotionManager alloc] init];
    [self.mainManager setAccelerometerUpdateInterval:.2];
    NSOperationQueue *queue = [NSOperationQueue currentQueue];
//    [self.mainManager startAccelerometerUpdatesToQueue:queue withHandler:^(CMAccelerometerData *accelerometerData, NSError *error) {
//        if (error) {
//            NSLog(@"accelerometer error: %@", error);
//        } else {
//            NSLog(@"executing");
//            NSLog(@"X: %f", accelerometerData.acceleration.x);
//            self.xLabel.text = [NSString stringWithFormat:@"X: %f", accelerometerData.acceleration.x];
//            dispatch_async(dispatch_get_main_queue(), ^{
//                self.xLabel.text = [NSString stringWithFormat:@"X: %f", accelerometerData.acceleration.x];
//                self.yLabel.text = [NSString stringWithFormat:@"Y: %f", accelerometerData.acceleration.y];
//                self.zLabel.text = [NSString stringWithFormat:@"Z: %f", accelerometerData.acceleration.z];
//            });
//        }
//    }];
}

@end