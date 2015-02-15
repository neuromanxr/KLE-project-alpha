//
//  KLEDailyViewController.h
//  KLE-GymBro
//
//  Created by Kelvin Lee on 9/6/14.
//  Copyright (c) 2014 Kelvin. All rights reserved.
//
#import "KLEWorkoutButtonDelegate.h"
#import "KLEManagedIDSelectionDelegate.h"
#import "CoreDataTableViewController.h"
#import <UIKit/UIKit.h>

@interface KLEDailyViewController : UITableViewController

@property (nonatomic, weak) id<KLEManagedIDSelectionDelegate> delegate;
@property (nonatomic, weak) id<KLEWorkoutButtonDelegate>workoutButtonDelegate;

@end
