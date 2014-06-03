//
//  GaitCheckAppDelegate.m
//  GaitCheck
//
//  Created by Jesse Clayburgh on 5/26/14.
//  Copyright (c) 2014 Jesse Clayburgh. All rights reserved.
//

#import "GaitCheckAppDelegate.h"
#import "UserPreferencesKeys.h"
#import "RecordingDatabaseAvailability.h"

@interface GaitCheckAppDelegate()

@property (strong, nonatomic) UIManagedDocument *recordingDatabase;
@property (strong, nonatomic) NSManagedObjectContext *recordingDatabaseContext;

@end

@implementation GaitCheckAppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    //    [NSThread sleepForTimeInterval:1.5];
    self.recordingDatabase = [self createManagedDocument];
    
    BOOL fileExists = [[NSFileManager defaultManager] fileExistsAtPath:[[self mainManagedDocumentLocation] path]];
    
    if (fileExists) {
        [self.recordingDatabase openWithCompletionHandler:^(BOOL success) {
            if (!success) NSLog(@"File exists but couldn’t open document at %@",[self mainManagedDocumentLocation]);
        }];
    } else {
        [self.recordingDatabase saveToURL:[self mainManagedDocumentLocation] forSaveOperation:UIDocumentSaveForCreating completionHandler:^(BOOL success) {
            if (!success) NSLog(@"File does not exist and tried to create but couldn’t open document at %@",[self mainManagedDocumentLocation]);
        }];
    }
    
    self.recordingDatabaseContext = self.recordingDatabase.managedObjectContext;
    
    return YES;
}
							
- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

- (void)setRecordingDatabaseContext:(NSManagedObjectContext *)recordingDatabaseContext
{
    _recordingDatabaseContext = recordingDatabaseContext;
    
    // let everyone who might be interested know this context is available
    // this happens very early in the running of our application
    // it would make NO SENSE to listen to this radio station in a View Controller that was segued to, for example
    // (but that's okay because a segued-to View Controller would presumably be "prepared" by being given a context to work in)
    NSDictionary *userInfo = self.recordingDatabaseContext ? @{ RecordingDatabaseAvailabilityContext : self.recordingDatabaseContext } : nil;
    [[NSNotificationCenter defaultCenter] postNotificationName:RecordingDatabaseAvailabilityNotification
                                                        object:self
                                                      userInfo:userInfo];
    
}

- (UIManagedDocument *)createManagedDocument
{
    UIManagedDocument *mainDocument = [[UIManagedDocument alloc] initWithFileURL:[self mainManagedDocumentLocation]];
    return mainDocument;
}

- (NSURL *)mainManagedDocumentLocation
{
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSURL *documentsDirectory = [[fileManager URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] firstObject];
    NSString *documentName = @"GaitCheckMainDocument";
    NSURL *url = [documentsDirectory URLByAppendingPathComponent:documentName];
    return url;
}

@end
