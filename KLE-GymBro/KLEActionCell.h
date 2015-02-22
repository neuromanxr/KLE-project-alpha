//
//  KLEActionCell.h
//  KLE-GymBro
//
//  Created by Kelvin Lee on 10/22/14.
//  Copyright (c) 2014 Kelvin. All rights reserved.
//

#import "KLEWorkoutButton.h"
#import <Foundation/Foundation.h>

IB_DESIGNABLE

@interface KLEActionCell : UITableViewCell

@property (strong, nonatomic) IBOutlet UIButton *finishWorkoutButton;
@property (strong, nonatomic) IBOutlet KLEWorkoutButton *workoutButton;
@property (strong, nonatomic) IBOutlet KLEWorkoutButton *repsWorkoutButton;
@property (strong, nonatomic) IBOutlet UILabel *exerciseNameLabel;
@property (strong, nonatomic) IBOutlet UILabel *weightLabel;
@property (strong, nonatomic) IBOutlet UILabel *repsLabel;

@end
