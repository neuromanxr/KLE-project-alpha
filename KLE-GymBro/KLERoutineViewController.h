//
//  KLERoutineViewController.h
//  KLE-GymBro
//
//  Created by Kelvin Lee on 9/8/14.
//  Copyright (c) 2014 Kelvin. All rights reserved.
//

#import "KLERoutines.h"
#import "CoreDataTableViewController.h"
#import <UIKit/UIKit.h>

@interface KLERoutineViewController : CoreDataTableViewController

@property (nonatomic) NSUInteger dayTag;
@property (nonatomic, strong) NSManagedObjectID *routinesID;
@property (nonatomic, strong) NSManagedObjectID *dayID;

@end
