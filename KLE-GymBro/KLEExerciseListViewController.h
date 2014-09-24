//
//  KLEExerciseListViewController.h
//  KLE-GymBro
//
//  Created by Kelvin Lee on 9/11/14.
//  Copyright (c) 2014 Kelvin. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface KLEExerciseListViewController : UITableViewController

- (instancetype)initForNewExercise:(BOOL)isNew;
- (instancetype)initWithStyle:(UITableViewStyle)style;

// stat store from revc will be passed to here
@property (nonatomic, strong) KLEStatStore *statStore;

@property (nonatomic, strong) KLEStat *stat;

@end
