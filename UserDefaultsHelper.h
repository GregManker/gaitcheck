//
//  UserDefaultsHelper.h
//  GaitCheck
//
//  Created by Jesse Clayburgh on 5/28/14.
//  Copyright (c) 2014 Jesse Clayburgh. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UserDefaultsHelper : NSObject

+ (void)setContactSensitivity:(NSString *)sensitivity;
+ (float)contactSensitivity;

+ (void)setLiftoffSensitivity:(NSString *)sensitivity;
+ (float)liftoffSensitivity;

+ (void)setSoundPair:(NSArray *)pairArray;
+ (NSArray *)soundPair;

+ (int)selectedSoundIndex;
+ (void)setSoundIndex:(int)selectedIndex;
@end
