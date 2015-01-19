//
//  KLEDailyViewController.h
//  KLE-GymBro
//
//  Created by Kelvin Lee on 9/6/14.
//  Copyright (c) 2014 Kelvin. All rights reserved.
//
#import "KLEManagedIDSelectionDelegate.h"
#import "CoreDataTableViewController.h"
#import <UIKit/UIKit.h>

@interface KLEDailyViewController : UITableViewController

@property (nonatomic, assign) id<KLEManagedIDSelectionDelegate> delegate;

@end
