//
//  KLEAppDelegate.m
//  KLE-GymBro
//
//  Created by Kelvin Lee on 9/1/14.
//  Copyright (c) 2014 Kelvin. All rights reserved.
//
#import "KLEExercise.h"

#import "KLERoutineViewController.h"
#import "KLEDailyViewController.h"
#import "KLEAppDelegate.h"

@implementation KLEAppDelegate

#define debug 1

- (void)demo
{
    if (debug == 1) {
        NSLog(@"Running %@ '%@'", self.class, NSStringFromSelector(_cmd));
    }
//    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"KLEExercise"];
    
//    NSArray *fetchedObjects = [_coreDataHelper.context executeFetchRequest:request error:nil];
    
//    NSArray *newExercises = [NSArray arrayWithObjects:@"Bench Press", @"Squats", @"Arm Curls", nil];
//    NSLog(@"newExercises array count %lu", [newExercises count]);
//    
//    for (NSString *newExerciseName in newExercises) {
//        KLEExercise *newExercise = [NSEntityDescription insertNewObjectForEntityForName:@"KLEExercise" inManagedObjectContext:_coreDataHelper.context];
//        newExercise.exerciseName = newExerciseName;
//        NSLog(@"Inserted New Managed Object for '%@'", newExercise.exerciseName);
//    }
    
//    for (KLEExercise *exercise in fetchedObjects) {
//        NSLog(@"Fetched Object = %@", exercise.exerciseName);
//    }
//    NSArray *exerciseArray = [NSArray arrayWithArray:fetchedObjects];
//    NSLog(@"exerciseArray in AppDelegate %@", exerciseArray);
    
//    for (KLEExercise *exercise in fetchedObjects) {
//        NSLog(@"Deleting Object '%@'", exercise.exerciseName);
//        [_coreDataHelper.context deleteObject:exercise];
//    }
//    for (int i = 1; i < 100; i++) {
//        KLESta *stat = [NSEntityDescription insertNewObjectForEntityForName:@"KLESta" inManagedObjectContext:_coreDataHelper.context];
//        stat.sets = [NSNumber numberWithInt:i];
//        NSLog(@"Inserted %@", stat.sets);
//    }
//    [_coreDataHelper saveContext];
}

- (CoreDataHelper*)cdh
{
    if (debug==1) {
        NSLog(@"Running %@ '%@'", self.class, NSStringFromSelector(_cmd));
    }
    // thread safe method
    if (!_coreDataHelper) {
        static dispatch_once_t predicate;
        dispatch_once(&predicate, ^{
            _coreDataHelper = [CoreDataHelper new];
        });
        [_coreDataHelper setupCoreData];
    }
    return _coreDataHelper;
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    if (debug==1)
    {
        NSLog(@"Running %@ '%@'", self.class, NSStringFromSelector(_cmd));
    }
    
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    // Override point for customization after application launch.
    
    KLEDailyViewController *dvc = [[KLEDailyViewController alloc] init];
    
//    KLERoutineViewController *rvc = [[KLERoutineViewController alloc] init];
    
    UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController:dvc];
    
    self.window.rootViewController = navController;
    
    [self.window makeKeyAndVisible];
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    if (debug==1)
    {
        NSLog(@"Running %@ '%@'", self.class, NSStringFromSelector(_cmd));
    }
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    if (debug==1)
    {
        NSLog(@"Running %@ '%@'", self.class, NSStringFromSelector(_cmd));
    }
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    [[self cdh] saveContext];
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    if (debug==1)
    {
        NSLog(@"Running %@ '%@'", self.class, NSStringFromSelector(_cmd));
    }
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    if (debug==1)
    {
        NSLog(@"Running %@ '%@'", self.class, NSStringFromSelector(_cmd));
    }
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    [self cdh];
    [self demo];
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    if (debug==1)
    {
        NSLog(@"Running %@ '%@'", self.class, NSStringFromSelector(_cmd));
    }
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    [[self cdh] saveContext];
}

@end
