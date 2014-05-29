//
//  RootVC.m
//  GaitCheck
//
//  Created by Jesse Clayburgh on 5/28/14.
//  Copyright (c) 2014 Jesse Clayburgh. All rights reserved.
//

#import "RootVC.h"
#import "MenuVC.h"

@interface RootVC ()

@end

@implementation RootVC

- (void)awakeFromNib
{
    self.menuPreferredStatusBarStyle = UIStatusBarStyleLightContent;
    self.contentViewShadowColor = [UIColor blackColor];
    self.contentViewShadowOffset = CGSizeMake(0, 0);
    self.contentViewShadowOpacity = 0.6;
    self.contentViewShadowRadius = 12;
    self.contentViewShadowEnabled = YES;
    
    self.contentViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"gaitRecordContentVC"];
    self.leftMenuViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"menuVC"];
    self.backgroundImage = [UIImage imageNamed:@"Stars"];
    self.delegate = self;
}

@end
