//
//  KLERoutineViewCell.m
//  KLE-GymBro
//
//  Created by Kelvin Lee on 9/8/14.
//  Copyright (c) 2014 Kelvin. All rights reserved.
//

#import "KLEUtility.h"
#import "KLERoutineViewCell.h"

@implementation KLERoutineViewCell

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
    
    if (self.selected) {
        [_nameLabel setTextColor:[UIColor whiteColor]];
        [_routineDetailButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        
    }
    else
    {
        [_nameLabel setTextColor:[UIColor kPrimaryColor]];
        [_routineDetailButton setTitleColor:[UIColor kPrimaryColor] forState:UIControlStateNormal];
        
    }
}

@end
