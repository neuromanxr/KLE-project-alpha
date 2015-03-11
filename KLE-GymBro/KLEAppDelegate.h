//
//  KLEAppDelegate.h
//  KLE-GymBro
//
//  Created by Kelvin Lee on 9/1/14.
//  Copyright (c) 2014 Kelvin. All rights reserved.
//

#import "CoreDataHelper.h"
#import <UIKit/UIKit.h>
#import "KLERoutineExercisesViewController.h"

@interface KLEAppDelegate : UIResponder <UIApplicationDelegate, UISplitViewControllerDelegate>

@property (strong, nonatomic) UIWindow *window;
@property (nonatomic, strong, readonly) CoreDataHelper *coreDataHelper;

// need access from split view
@property (nonatomic, strong) KLERoutineExercisesViewController *routineExercisesViewController;

- (CoreDataHelper*)cdh;

@end
