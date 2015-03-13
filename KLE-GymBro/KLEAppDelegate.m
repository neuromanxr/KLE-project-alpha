//
//  KLEAppDelegate.m
//  KLE-GymBro
//
//  Created by Kelvin Lee on 9/1/14.
//  Copyright (c) 2014 Kelvin. All rights reserved.
//

#import "KLEExercise.h"

#import "KLEHistoryViewController.h"

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

- (UISplitViewController *)splitviewController
{
    KLERoutineViewController *rvc = [KLERoutineViewController new];
    UINavigationController *rootNav = [[UINavigationController alloc] initWithRootViewController:rvc];
    
    KLERoutineExercisesViewController *revc = [KLERoutineExercisesViewController new];
    UINavigationController *detailNav = [[UINavigationController alloc] initWithRootViewController:revc];
    
    // for routine selection delegate
    rvc.delegate = revc;
    
    UISplitViewController *svc = [[UISplitViewController alloc] init];
    svc.viewControllers = @[rootNav, detailNav];
    
    // display mode button item
//    _routineExercisesViewController.navigationItem.leftBarButtonItem = [svc displayModeButtonItem];
//    _routineExercisesViewController.navigationItem.leftItemsSupplementBackButton = YES;
//    rvc.navigationItem.rightBarButtonItem = [svc displayModeButtonItem];
    
    svc.delegate = self;
    
    svc.preferredDisplayMode = UISplitViewControllerDisplayModeAllVisible;
    
//    [svc setOverrideTraitCollection: [UITraitCollection traitCollectionWithHorizontalSizeClass:UIUserInterfaceSizeClassRegular] forChildViewController:rootNav];
    
    return svc;
}

- (BOOL)splitViewController:(UISplitViewController *)splitViewController collapseSecondaryViewController:(UIViewController *)secondaryViewController ontoPrimaryViewController:(UIViewController *)primaryViewController
{
    return YES;
}

- (UISplitViewControllerDisplayMode)targetDisplayModeForActionInSplitViewController:(UISplitViewController *)svc
{
    return UISplitViewControllerDisplayModePrimaryHidden;
}

- (void)splitViewController:(UISplitViewController *)svc willChangeToDisplayMode:(UISplitViewControllerDisplayMode)displayMode
{
    if (displayMode != UISplitViewControllerDisplayModeAllVisible) {
        NSLog(@"ALL VISIBLE");
    }
    NSLog(@"DISPLAY MODE CHANGED");
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"DisplayModeChangeNote" object:[NSNumber numberWithInteger:displayMode]];
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    if (debug==1)
    {
        NSLog(@"Running %@ '%@'", self.class, NSStringFromSelector(_cmd));
    }
    
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    // Override point for customization after application launch.
    
    /* for split view, routine view and routine exercise view
     
    KLEContainerViewController *containerView = [KLEContainerViewController new];
    [containerView setEmbeddedViewController:[self splitviewController]];
    [containerView setModalPresentationStyle:UIModalPresentationFormSheet];
    [containerView setModalTransitionStyle:UIModalTransitionStyleCrossDissolve];
     
    UIImage *containerTabBarImage = [UIImage imageNamed:@"dumbbell.png"];
    UITabBarItem *containerTabItem = [[UITabBarItem alloc] initWithTitle:nil image:containerTabBarImage tag:1];
    containerView.tabBarItem = containerTabItem;
    */
    
    // daily view
    KLEDailyViewController *dailyView = [KLEDailyViewController new];
    UINavigationController *dailyViewNav = [[UINavigationController alloc] initWithRootViewController:dailyView];
    // daily view tab bar stuff in daily view controller
    
    // routine view
    KLERoutineViewController *routineView = [KLERoutineViewController new];
    UINavigationController *routineViewNav = [[UINavigationController alloc] initWithRootViewController:routineView];
    
    UIImage *routineTabBarImage = [UIImage imageNamed:@"dumbbell.png"];
    UITabBarItem *routineTabItem = [[UITabBarItem alloc] initWithTitle:nil image:routineTabBarImage tag:1];
    routineView.tabBarItem = routineTabItem;
    
    // history view
    KLEHistoryViewController *historyView = [KLEHistoryViewController new];
    UINavigationController *historyViewNav = [[UINavigationController alloc] initWithRootViewController:historyView];
    
    UIImage *historyTabBarImage = [UIImage imageNamed:@"menu.png"];
    UITabBarItem *historyTabItem = [[UITabBarItem alloc] initWithTitle:nil image:historyTabBarImage tag:2];
    historyView.tabBarItem = historyTabItem;

    UITabBarController *tabBar = [UITabBarController new];
    tabBar.viewControllers = @[dailyViewNav, routineViewNav, historyViewNav];
    
    self.window.rootViewController = tabBar;
    
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
