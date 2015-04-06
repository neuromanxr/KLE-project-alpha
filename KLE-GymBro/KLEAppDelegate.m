//
//  KLEAppDelegate.m
//  KLE-GymBro
//
//  Created by Kelvin Lee on 9/1/14.
//  Copyright (c) 2014 Kelvin. All rights reserved.
//
#import "KLEUtility.h"
#import "KLEExercise.h"

#import "KLEHistoryViewController.h"

#import "KLERoutineViewController.h"
#import "KLEDailyViewController.h"
#import "KLEAppDelegate.h"

@implementation KLEAppDelegate

#define debug 1

//- (void)demo
//{
//    if (debug == 1) {
//        NSLog(@"Running %@ '%@'", self.class, NSStringFromSelector(_cmd));
//    }
//}

- (CoreDataHelper*)cdh
{
//    if (debug==1) {
//        NSLog(@"Running %@ '%@'", self.class, NSStringFromSelector(_cmd));
//    }
//    // thread safe method
//    if (!_coreDataHelper) {
//        static dispatch_once_t predicate;
//        dispatch_once(&predicate, ^{
//            _coreDataHelper = [CoreDataHelper new];
//        });
//        [_coreDataHelper setupCoreData];
//    }
    return [CoreDataHelper sharedCoreDataHelper];
}

/*
- (UISplitViewController *)splitviewController
{
    KLERoutineViewController *rvc = [KLERoutineViewController new];
    UINavigationController *rootNav = [[UINavigationController alloc] initWithRootViewController:rvc];
    
    KLERoutineExercisesViewController *revc = [KLERoutineExercisesViewController new];
    UINavigationController *detailNav = [[UINavigationController alloc] initWithRootViewController:revc];
    
    // for routine selection delegate
//    rvc.delegate = revc;
    
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
*/
- (void)setupNavigationBarWithTitle:(NSString *)titleName forViewController:(UIViewController *)viewController
{
    // custom title for navigation title
    NSAttributedString *attribString = [[NSAttributedString alloc] initWithString:titleName attributes:@{ NSFontAttributeName : [KLEUtility getFontFromFontFamilyWithSize:18.0], NSUnderlineStyleAttributeName : @0, NSBackgroundColorAttributeName : [UIColor clearColor] }];
    // custom title for navigation title
    UILabel *title = [[UILabel alloc] initWithFrame:CGRectZero];
    title.backgroundColor = [UIColor clearColor];
    title.textColor = [UIColor whiteColor];
    title.numberOfLines = 0;
    title.attributedText = attribString;
    [title sizeToFit];
    
    //    UIImageView *logo = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 40, 40)];
    //    logo.contentMode = UIViewContentModeScaleAspectFit;
    //    UIImage *logoImage = [UIImage imageNamed:@""];
    //    [logo setImage:logoImage];
    //    self.navigationItem.titleView = logo;
    
    [viewController.navigationController.navigationBar setBarStyle:UIBarStyleBlack];
    [viewController.navigationController.navigationBar setTintColor:[UIColor orangeColor]];
    [viewController.navigationItem setTitleView:title];
}

- (BOOL)application:(UIApplication *)application willFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    // settings default
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSLog(@"USER DEFAULTS %@", [userDefaults objectForKey:kUnitWeightKey]);
    if ([userDefaults objectForKey:kUnitWeightKey] == NULL) {
        NSDictionary *initialDefaults = @{kUnitWeightKey:kUnitPounds};
        [[NSUserDefaults standardUserDefaults] registerDefaults:initialDefaults];
        NSLog(@"** DEFAULT SET TO LBS");
    }
    
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    
    // daily view
    KLEDailyViewController *dailyView = [KLEDailyViewController new];
    UINavigationController *dailyViewNav = [[UINavigationController alloc] initWithRootViewController:dailyView];
    // daily view tab bar stuff in daily view controller
    [self setupNavigationBarWithTitle:@"Barbell Bro" forViewController:dailyView];
    // restoration identifier
    dailyViewNav.restorationIdentifier = NSStringFromClass([dailyViewNav class]);
    
    // routine view
    KLERoutineViewController *routineView = [KLERoutineViewController new];
    UINavigationController *routineViewNav = [[UINavigationController alloc] initWithRootViewController:routineView];
    [self setupNavigationBarWithTitle:@"Routines" forViewController:routineView];
    // restoration identifier
    routineViewNav.restorationIdentifier = NSStringFromClass([routineViewNav class]);
    
    UIImage *routineTabBarImage = [UIImage imageNamed:@"TabBarRoutines"];
    UITabBarItem *routineTabItem = [[UITabBarItem alloc] initWithTitle:nil image:routineTabBarImage tag:1];
    routineView.tabBarItem = routineTabItem;
    
    // history view
    KLEHistoryViewController *historyView = [KLEHistoryViewController new];
    UINavigationController *historyViewNav = [[UINavigationController alloc] initWithRootViewController:historyView];
    [self setupNavigationBarWithTitle:@"History" forViewController:historyView];
    // restoration identifier
    historyViewNav.restorationIdentifier = NSStringFromClass([historyViewNav class]);
    
    UIImage *historyTabBarImage = [UIImage imageNamed:@"TabBarHistory"];
    UITabBarItem *historyTabItem = [[UITabBarItem alloc] initWithTitle:nil image:historyTabBarImage tag:2];
    historyView.tabBarItem = historyTabItem;
    
    UITabBarController *threeTabBar = [UITabBarController new];
    threeTabBar.viewControllers = @[dailyViewNav, routineViewNav, historyViewNav];
    [threeTabBar.tabBar setBarStyle:UIBarStyleBlack];
    [threeTabBar.tabBar setTintColor:[UIColor orangeColor]];
    
    // restoration identifier for tab bar
    threeTabBar.restorationIdentifier = NSStringFromClass([threeTabBar class]);
//    threeTabBar.restorationClass = [self class];
    
    self.window.rootViewController = threeTabBar;
    
    
    
    
    return YES;
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
//    if (debug==1)
//    {
//        NSLog(@"Running %@ '%@'", self.class, NSStringFromSelector(_cmd));
//    }

    
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
    
    [self.window makeKeyAndVisible];
    
    return YES;
}

//- (UIViewController *)application:(UIApplication *)application viewControllerWithRestorationIdentifierPath:(NSArray *)identifierComponents coder:(NSCoder *)coder
//{
//    UIViewController *vc = [[UINavigationController alloc] init];
//    vc.restorationIdentifier = [identifierComponents firstObject];
//    NSLog(@"VC RESTORATION ID %@", vc.restorationIdentifier);
//    
//    return vc;
//}

- (BOOL)application:(UIApplication *)application shouldSaveApplicationState:(NSCoder *)coder
{
    return YES;
}

- (BOOL)application:(UIApplication *)application shouldRestoreApplicationState:(NSCoder *)coder
{
    return YES;
}

- (void)application:(UIApplication *)application handleWatchKitExtensionRequest:(NSDictionary *)userInfo reply:(void (^)(NSDictionary *))reply
{
    
    // check the request from watch kit ext.
    NSString *request = [userInfo objectForKey:@"request"];
    if ([request isEqualToString:@"refreshData"]) {
        //
    }
}

- (void)applicationWillResignActive:(UIApplication *)application
{
//    if (debug==1)
//    {
//        NSLog(@"Running %@ '%@'", self.class, NSStringFromSelector(_cmd));
//    }
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
//    if (debug==1)
//    {
//        NSLog(@"Running %@ '%@'", self.class, NSStringFromSelector(_cmd));
//    }
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    [[self cdh] saveContext];
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
//    if (debug==1)
//    {
//        NSLog(@"Running %@ '%@'", self.class, NSStringFromSelector(_cmd));
//    }
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
//    if (debug==1)
//    {
//        NSLog(@"Running %@ '%@'", self.class, NSStringFromSelector(_cmd));
//    }
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    [self cdh];
//    [self demo];
}

- (void)applicationWillTerminate:(UIApplication *)application
{
//    if (debug==1)
//    {
//        NSLog(@"Running %@ '%@'", self.class, NSStringFromSelector(_cmd));
//    }
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    [[self cdh] saveContext];
}

@end
