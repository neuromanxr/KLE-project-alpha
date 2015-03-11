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
#import "KLERoutineViewController.h"

@interface KLEAppDelegate : UIResponder <UIApplicationDelegate, UISplitViewControllerDelegate>

@property (strong, nonatomic) UIWindow *window;
@property (nonatomic, strong, readonly) CoreDataHelper *coreDataHelper;

//@property (nonatomic, strong) KLERoutineViewController *routineViewController;
@property (nonatomic, strong) KLERoutineExercisesViewController *routineExercisesViewController;

- (CoreDataHelper*)cdh;

@end
