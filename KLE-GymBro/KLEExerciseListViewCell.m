//
//  KLEExerciseListViewCell.m
//  KLE-GymBro
//
//  Created by Kelvin Lee on 9/11/14.
//  Copyright (c) 2014 Kelvin. All rights reserved.
//

#import "KLEUtility.h"
#import "KLEExerciseListViewCell.h"

@implementation KLEExerciseListViewCell

- (void)awakeFromNib
{
    [super awakeFromNib];
    // Initialization code
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
    
    if (self.selected) {
        [_exerciseLabel setTextColor:[UIColor whiteColor]];
        
    }
    else
    {
        [_exerciseLabel setTextColor:[UIColor kPrimaryColor]];
        
    }
}

@end
