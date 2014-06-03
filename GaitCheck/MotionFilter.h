//
//  MotionFilter.h
//  GaitCheck
//
//  Created by Jesse Clayburgh on 6/2/14.
//  Copyright (c) 2014 Jesse Clayburgh. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreMotion/CoreMotion.h>

@interface MotionFilter : NSObject
{
	BOOL adaptive;
    double x, y, z;
}

// Add a UIAcceleration to the filter.
-(void)addAcceleration:(CMAccelerometerData *)accel;

@property(nonatomic) double x;
@property(nonatomic) double y;
@property(nonatomic) double z;

@property(nonatomic, getter=isAdaptive) BOOL adaptive;
@property(nonatomic, readonly) NSString *name;

@end

// A filter class to represent a lowpass filter
@interface LowpassFilter : MotionFilter
{
	double filterConstant;
    double lastX, lastY, lastZ;
}

-(id)initWithSampleRate:(double)rate cutoffFrequency:(double)freq;

@end

// A filter class to represent a highpass filter.
@interface HighpassFilter : MotionFilter
{
	double filterConstant;
	double lastX, lastY, lastZ;
}

-(id)initWithSampleRate:(double)rate cutoffFrequency:(double)freq;

@end
