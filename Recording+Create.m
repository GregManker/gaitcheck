//
//  Recording+Create.m
//  GaitCheck
//
//  Created by Jesse Clayburgh on 5/31/14.
//  Copyright (c) 2014 Jesse Clayburgh. All rights reserved.
//

#import "Recording+Create.h"

@implementation Recording (Create)

+ (void)saveNewRecording:(NSString *)data withDetails:(NSString *)details createdAtDate:(NSDate *)date inManagedObjectContext:(NSManagedObjectContext *)context
{
    Recording *recording = [NSEntityDescription insertNewObjectForEntityForName:@"Recording"
                                          inManagedObjectContext:context];
    recording.data = data;
    recording.details = details;
    recording.createdAt = date;
}

@end
