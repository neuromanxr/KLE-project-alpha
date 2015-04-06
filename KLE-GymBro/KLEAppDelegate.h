//
//  KLEAppDelegate.h
//  KLE-GymBro
//
//  Created by Kelvin Lee on 9/1/14.
//  Copyright (c) 2014 Kelvin. All rights reserved.
//
#import "CoreDataHelperKit.h"
#import "CoreDataHelper.h"
#import <UIKit/UIKit.h>
#import "KLERoutineExercisesViewController.h"
#import "KLEContainerViewController.h"

@interface KLEAppDelegate : UIResponder <UIApplicationDelegate, UISplitViewControllerDelegate>

@property (strong, nonatomic) UIWindow *window;
@property (nonatomic, strong, readonly) CoreDataHelper *coreDataHelper;

- (CoreDataHelper*)cdh;

@end
