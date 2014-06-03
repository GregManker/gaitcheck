//
//  Recording.h
//  GaitCheck
//
//  Created by Jesse Clayburgh on 5/31/14.
//  Copyright (c) 2014 Jesse Clayburgh. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface Recording : NSManagedObject

@property (nonatomic, retain) NSString * details;
@property (nonatomic, retain) NSString * data;
@property (nonatomic, retain) NSDate * createdAt;

@end
