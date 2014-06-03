//
//  MotionFilter.m
//  GaitCheck
//
//  Created by Jesse Clayburgh on 6/2/14.
//  Copyright (c) 2014 Jesse Clayburgh. All rights reserved.
//

#import "MotionFilter.h"

@implementation MotionFilter

@synthesize x, y, z, adaptive;

-(void)addAcceleration:(CMAccelerometerData *)accel
{
    self.x = accel.acceleration.x;
    self.y = accel.acceleration.y;
    self.z = accel.acceleration.z;
}

-(NSString*)name
{
	return @"You should not see this";
}

@end

#define kAccelerometerMinStep				0.02
#define kAccelerometerNoiseAttenuation		3.0

double Norm(double x, double y, double z)
{
	return sqrt(x * x + y * y + z * z);
}

double Clamp(double v, double min, double max)
{
	if(v > max)
		return max;
	else if(v < min)
		return min;
	else
		return v;
}

// See http://en.wikipedia.org/wiki/Low-pass_filter for details low pass filtering
@implementation LowpassFilter

-(id)initWithSampleRate:(double)rate cutoffFrequency:(double)freq
{
	self = [super init];
	if(self != nil)
	{
		double dt = 1.0 / rate;
		double RC = 1.0 / freq;
		filterConstant = dt / (dt + RC);
	}
	return self;
}

-(void)addAcceleration:(CMAccelerometerData *)accel
{
	double alpha = filterConstant;
	
	if(adaptive)
	{
		double d = Clamp(fabs(Norm(x, y, z) - Norm(accel.acceleration.x, accel.acceleration.y, accel.acceleration.z)) / kAccelerometerMinStep - 1.0, 0.0, 1.0);
		alpha = (1.0 - d) * filterConstant / kAccelerometerNoiseAttenuation + d * filterConstant;
	}
	
	self.x = accel.acceleration.x * alpha + self.x * (1.0 - alpha);
	self.y = accel.acceleration.y * alpha + self.y * (1.0 - alpha);
	self.z = accel.acceleration.z * alpha + self.z * (1.0 - alpha);
}

-(NSString*)name
{
	return adaptive ? @"Adaptive Lowpass Filter" : @"Lowpass Filter";
}

@end

// See http://en.wikipedia.org/wiki/High-pass_filter for details on high pass filtering
@implementation HighpassFilter

-(id)initWithSampleRate:(double)rate cutoffFrequency:(double)freq
{
	self = [super init];
	if(self != nil)
	{
		double dt = 1.0 / rate;
		double RC = 1.0 / freq;
		filterConstant = RC / (dt + RC);
	}
	return self;
}

-(void)addAcceleration:(CMAccelerometerData *)accel
{
	double alpha = filterConstant;
	
	if(adaptive)
	{
		double d = Clamp(fabs(Norm(x, y, z) - Norm(accel.acceleration.x, accel.acceleration.y, accel.acceleration.z)) / kAccelerometerMinStep - 1.0, 0.0, 1.0);
		alpha = d * filterConstant / kAccelerometerNoiseAttenuation + (1.0 - d) * filterConstant;
	}
	
	self.x = alpha * (self.x + accel.acceleration.x - self->lastX);
	self.y = alpha * (self.y + accel.acceleration.y - self->lastY);
	self.z = alpha * (self.z + accel.acceleration.z - self->lastZ);
	
	self->lastX = accel.acceleration.x;
	self->lastY = accel.acceleration.y;
	self->lastZ = accel.acceleration.z;
}

-(NSString*)name
{
	return adaptive ? @"Adaptive Highpass Filter" : @"Highpass Filter";
}

@end
