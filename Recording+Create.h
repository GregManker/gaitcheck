//
//  Recording+Create.h
//  GaitCheck
//
//  Created by Jesse Clayburgh on 5/31/14.
//  Copyright (c) 2014 Jesse Clayburgh. All rights reserved.
//

#import "Recording.h"

@interface Recording (Create)

+ (void)saveNewRecording:(NSString *)data withDetails:(NSString *)details createdAtDate:(NSDate *)date inManagedObjectContext:(NSManagedObjectContext *)context;

@end
