//
//  KLERoutineViewController.h
//  KLE-GymBro
//
//  Created by Kelvin Lee on 9/8/14.
//  Copyright (c) 2014 Kelvin. All rights reserved.
//

#import "CoreDataTableViewController.h"
#import <UIKit/UIKit.h>
#import "KLEManagedIDSelectionDelegate.h"

@interface KLERoutineViewController : CoreDataTableViewController // <UISplitViewControllerDelegate>

//@property (nonatomic, weak) id<KLEManagedIDSelectionDelegate> delegate;

@property (nonatomic) NSUInteger dayTag;

@property (nonatomic, strong) NSNumber *dayNumber;

@end
