//
//  KLERoutineExercisesViewController.h
//  KLE-GymBro
//
//  Created by Kelvin Lee on 9/15/14.
//  Copyright (c) 2014 Kelvin. All rights reserved.
//
#import "KLETableHeaderView.h"
#import "KLEManagedIDSelectionDelegate.h"
#import "CoreDataTableViewController.h"
#import <UIKit/UIKit.h>

@interface KLERoutineExercisesViewController : CoreDataTableViewController <KLEManagedIDSelectionDelegate, UISplitViewControllerDelegate>

@property (nonatomic, strong) NSManagedObjectID *selectedRoutineID;
// stores the selected stat stores created by routines store in routine view controller
//@property (nonatomic, strong) KLEStatStore *statStore;

@end
