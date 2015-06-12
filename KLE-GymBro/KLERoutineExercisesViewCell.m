//
//  KLERoutineExercisesViewCell.m
//  KLE-GymBro
//
//  Created by Kelvin Lee on 9/15/14.
//  Copyright (c) 2014 Kelvin. All rights reserved.
//

#import "KLEUtility.h"
#import "KLERoutineExercisesViewCell.h"

@implementation KLERoutineExercisesViewCell

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
    
    if (self.selected) {
        [_exerciseNameLabel setTextColor:[UIColor whiteColor]];
        [_setsLabel setTextColor:[UIColor whiteColor]];
        [_repsLabel setTextColor:[UIColor whiteColor]];
        [_weightLabel setTextColor:[UIColor whiteColor]];
        
    }
    else
    {
        [_exerciseNameLabel setTextColor:[UIColor kPrimaryColor]];
        [_setsLabel setTextColor:[UIColor kPrimaryColor]];
        [_repsLabel setTextColor:[UIColor kPrimaryColor]];
        [_weightLabel setTextColor:[UIColor kPrimaryColor]];
        
    }
}

@end
