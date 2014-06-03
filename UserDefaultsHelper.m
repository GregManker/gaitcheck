//
//  UserDefaultsHelper.m
//  GaitCheck
//
//  Created by Jesse Clayburgh on 5/28/14.
//  Copyright (c) 2014 Jesse Clayburgh. All rights reserved.
//

#import "UserDefaultsHelper.h"
#import "UserPreferencesKeys.h"


@implementation UserDefaultsHelper

#define DEFAULT_LIFTOFF_SENSITIVITY @"4.0"
#define DEFAULT_CONTACT_SENSITIVITY @"4.0"

+ (void)setContactSensitivity:(NSString *)sensitivity
{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults setValue:sensitivity forKey:CONTACT_SENSITIVITY];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

+ (float)contactSensitivity
{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    if ( ![userDefaults valueForKey:CONTACT_SENSITIVITY] ) {
        [userDefaults setValue:DEFAULT_CONTACT_SENSITIVITY forKey:CONTACT_SENSITIVITY];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
    NSLog(@"float val: %f",[[userDefaults valueForKey:CONTACT_SENSITIVITY] floatValue]);
    NSLog(@"string val: %@",[userDefaults valueForKey:CONTACT_SENSITIVITY]);
    return [[userDefaults valueForKey:CONTACT_SENSITIVITY] floatValue];
}

+ (void)setLiftoffSensitivity:(NSString *)sensitivity
{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults setValue:sensitivity forKey:LIFTOFF_SENSITIVITY];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

+ (float)liftoffSensitivity
{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    if ( ![userDefaults valueForKey:LIFTOFF_SENSITIVITY] ) {
        [userDefaults setValue:DEFAULT_LIFTOFF_SENSITIVITY forKey:LIFTOFF_SENSITIVITY];
    }
    return [[userDefaults valueForKey:LIFTOFF_SENSITIVITY] floatValue];
}

+ (void)setSoundPair:(NSArray *)pairArray
{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    if ( (![userDefaults valueForKey:SELECTED_SOUND_PAIR]) || ([userDefaults valueForKey:SELECTED_SOUND_PAIR] != pairArray )) {
        [userDefaults setObject:pairArray forKey:SELECTED_SOUND_PAIR];
    }
    
}

+ (NSArray *)soundPair
{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    if (![userDefaults valueForKey:SELECTED_SOUND_PAIR]) {
        // this is kind of crappy lazy instantiation...not sure how to make better atm
        NSURL *tone1 = [NSURL URLWithString:@"System/Library/Audio/UISounds/short_double_low.caf"];
        NSURL *tone2 = [NSURL URLWithString:@"System/Library/Audio/UISounds/short_double_high.caf"];
        NSArray *tones = [[NSArray alloc] initWithObjects: [tone1 absoluteString], [tone2 absoluteString], nil];
        [UserDefaultsHelper setSoundPair:tones];
    }
    return [userDefaults objectForKey:SELECTED_SOUND_PAIR];
}

+ (int)selectedSoundIndex
{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    if ( (![userDefaults valueForKey:SELECTED_SOUND_INDEX]) ) {
        [userDefaults setObject:@"0" forKey:SELECTED_SOUND_INDEX];
    }
    return [[userDefaults valueForKey:SELECTED_SOUND_INDEX] intValue];
}

+ (void)setSoundIndex:(int)selectedIndex
{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults setObject:[NSString stringWithFormat:@"%d", selectedIndex] forKey:SELECTED_SOUND_INDEX];
}
        
@end
