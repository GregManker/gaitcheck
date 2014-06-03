//
//  GaitRecordVC.m
//  GaitCheck
//
//  Created by Jesse Clayburgh on 5/28/14.
//  Copyright (c) 2014 Jesse Clayburgh. All rights reserved.
//

#import "GaitRecordVC.h"
#import <CoreMotion/CoreMotion.h>
#import "RecordingDatabaseAvailability.h"
#import "Recording+Create.h"
#import "MotionFilter.h"
#import "UserDefaultsHelper.h"
#import <AudioToolbox/AudioToolbox.h>

#define mainAsyncQ dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)

@interface GaitRecordVC () <UIAccelerometerDelegate, UIAlertViewDelegate>
@property (weak, nonatomic) IBOutlet UILabel *accelXLabel;
@property (weak, nonatomic) IBOutlet UILabel *accelYLabel;
@property (weak, nonatomic) IBOutlet UILabel *accelZLabel;
@property (weak, nonatomic) IBOutlet UILabel *gyroXLabel;
@property (weak, nonatomic) IBOutlet UILabel *gyroYLabel;
@property (weak, nonatomic) IBOutlet UILabel *gyroZLabel;
@property (weak, nonatomic) IBOutlet UISwitch *startStopSwitch;
@property (strong, nonatomic) NSTimer *timer;
@property (strong) NSString *csv;
@property float elapsedRecordingTime;
@property (strong, nonatomic) CMMotionManager *mainManager;
@property (strong, nonatomic) LowpassFilter *lowpassFilter;
@property BOOL footIsDown;
@property float contactSensitivity;
@property float liftoffSensitivity;
@property CMAttitude *footDownAttitude;
@property CMAttitude *attitudeChange;
@property  __block BOOL activeThread;

@end

@implementation GaitRecordVC

#define UPDATE_INTERVAL .1

- (void)awakeFromNib
{
    [[NSNotificationCenter defaultCenter] addObserverForName:RecordingDatabaseAvailabilityNotification
                                                      object:nil
                                                       queue:nil
                                                  usingBlock:^(NSNotification *note) {
                                                      self.managedObjectContext = note.userInfo[RecordingDatabaseAvailabilityContext];
                                                  }];
}

#define kUpdateFrequency	60.0

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.mainManager = [[CMMotionManager alloc] init];
    [self.mainManager setAccelerometerUpdateInterval:UPDATE_INTERVAL];
    [self.mainManager setDeviceMotionUpdateInterval:UPDATE_INTERVAL];
    [self.mainManager setGyroUpdateInterval:UPDATE_INTERVAL];
    
    
}

- (void)viewWillAppear:(BOOL)animated
{
    self.contactSensitivity = [UserDefaultsHelper contactSensitivity];
    self.liftoffSensitivity = [UserDefaultsHelper liftoffSensitivity];
    self.footIsDown = NO;
    
    self.lowpassFilter = [[LowpassFilter alloc] initWithSampleRate:5.1 cutoffFrequency:self.contactSensitivity];
    self.lowpassFilter.adaptive = YES;
    self.activeThread = false;
}

- (IBAction)startStopSwitch:(id)sender {
    if (self.startStopSwitch.selected) {
        [self.mainManager stopAccelerometerUpdates];
        [self.mainManager stopGyroUpdates];
        [self.mainManager stopDeviceMotionUpdates];
        [self endRecording];
        self.startStopSwitch.selected = NO;
    } else {
        [self.mainManager startAccelerometerUpdates];
        [self.mainManager startGyroUpdates];
        [self.mainManager startDeviceMotionUpdates];
        [self beginRecording];
        self.startStopSwitch.selected = YES;
    }
}

- (void)beginRecording
{
    [self initializeCSV];
    self.timer = [NSTimer scheduledTimerWithTimeInterval:UPDATE_INTERVAL target:self selector:@selector(updateCSV) userInfo:nil repeats:YES];
}

- (void)endRecording
{
    [self.timer invalidate];
    self.timer = nil;
    self.elapsedRecordingTime = 0;
    [self showAlertView];
    self.activeThread = false;
    self.footIsDown = NO;
}

- (void)initializeCSV
{
    self.csv = @"elapsedtime,xaccel,yaccel,zaccel,xgyro,ygyro,zgyro\n";
}

- (void)finalizeCSVWithDetails:(NSString *)details
{
    NSString *title = [NSString stringWithFormat:@"Patient Name, Date:\n%@,%@\n", details, [[NSDate date] description]];
    self.csv = [title stringByAppendingString:self.csv];
}

- (void)updateScreen
{
    self.gyroXLabel.text = [NSString stringWithFormat:@"X: %f", self.mainManager.gyroData.rotationRate.x];
    self.gyroYLabel.text = [NSString stringWithFormat:@"Y: %f", self.mainManager.gyroData.rotationRate.y];
    self.gyroZLabel.text = [NSString stringWithFormat:@"Z: %f", self.mainManager.gyroData.rotationRate.z];
    self.accelXLabel.text = [NSString stringWithFormat:@"X: %f", self.mainManager.accelerometerData.acceleration.x];
    self.accelYLabel.text = [NSString stringWithFormat:@"Y: %f", self.mainManager.accelerometerData.acceleration.y];
    self.accelZLabel.text = [NSString stringWithFormat:@"Z: %f", self.mainManager.accelerometerData.acceleration.z];
    
}

- (void)updateCSV
{
    self.csv = [self.csv stringByAppendingString:[NSString stringWithFormat:@"%f,%f,%f,%f,%f,%f,%f\n",
                                                  self.elapsedRecordingTime,
                                                  self.mainManager.accelerometerData.acceleration.x,
                                                  self.mainManager.accelerometerData.acceleration.y,
                                                  self.mainManager.accelerometerData.acceleration.z,
                                                  self.mainManager.gyroData.rotationRate.x,
                                                  self.mainManager.gyroData.rotationRate.y,
                                                  self.mainManager.gyroData.rotationRate.z]];
    
    self.elapsedRecordingTime = self.elapsedRecordingTime + ceil(UPDATE_INTERVAL);
    [self filterAccelerometerAndGyroAndPlaySounds:self.mainManager.accelerometerData motion:self.mainManager.deviceMotion];
}

#pragma mark - Alert View Delegate Methods

- (void)showAlertView
{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Save Gait Recording"
                                                    message:nil
                                                   delegate:self
                                          cancelButtonTitle:@"Delete"
                                          otherButtonTitles:@"Save", nil];
    alert.alertViewStyle = UIAlertViewStylePlainTextInput;
    [alert textFieldAtIndex:0].placeholder = @"Patient Name, Recording #";
    [alert show];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 0) {
        self.csv = nil;
    }
    
    if (buttonIndex == 1) {
        NSString *recordingDetails = [alertView textFieldAtIndex:0].text;
        [self finalizeCSVWithDetails:recordingDetails];
        [Recording saveNewRecording:self.csv withDetails:[alertView textFieldAtIndex:0].text createdAtDate:[NSDate date] inManagedObjectContext:self.managedObjectContext];
        self.csv = nil;
    }
}

#pragma mark - Filter Methods


#define SENSITIVITY_SCALING 4.6
#define ATTITUTE_LIMIT_IN_RADIANS .261

- (void)filterAccelerometerAndGyroAndPlaySounds:(CMAccelerometerData *)acceleration motion:(CMDeviceMotion *)motion
{

    [self.lowpassFilter addAcceleration:acceleration];
    NSLog(@"Contact cutoff: %f", self.contactSensitivity);
    NSLog(@"Y value: %f", fabsf(self.lowpassFilter.y));
        //Play tone if acceleration is greater than cutoff value and sound is turned on
        //More complete step detection will be added here later
            //Check for footstrike
//            [NSThread sleepForTimeInterval:.3];
            if (fabsf(self.lowpassFilter.y) > (self.contactSensitivity / SENSITIVITY_SCALING) && !self.footIsDown && !self.activeThread) {
                
                //play sound
                [self playSound:([NSURL URLWithString:[UserDefaultsHelper soundPair][0]])];
                //Foot is now down
                self.footIsDown = YES;
                self.footDownAttitude = self.mainManager.deviceMotion.attitude;
                self.attitudeChange = self.footDownAttitude;
                dispatch_async(mainAsyncQ, ^{
                    self.activeThread = true;
                    while (fabsf(self.attitudeChange.yaw) < ATTITUTE_LIMIT_IN_RADIANS) {
                        NSLog(@"in thread! %f", self.attitudeChange.yaw);
                        self.attitudeChange = self.mainManager.deviceMotion.attitude;
                        [self.attitudeChange multiplyByInverseOfAttitude:self.footDownAttitude];
//                        [NSThread sleepForTimeInterval:.5];
                    }
                    
                    dispatch_async(dispatch_get_main_queue(), ^{
                        // foot is now up
                        self.footIsDown = NO;
                        [self playSound:([NSURL URLWithString:[UserDefaultsHelper soundPair][1]])];
                        self.activeThread = false;
                    });
                });
            }

}

- (void)playSound:(NSURL *)url
{
    SystemSoundID soundID;
    AudioServicesCreateSystemSoundID((__bridge_retained CFURLRef)url,&soundID);
    AudioServicesPlaySystemSound(soundID);
}

@end

