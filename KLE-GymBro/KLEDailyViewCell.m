//
//  KLEDailyViewCell.m
//  KLE-GymBro
//
//  Created by Kelvin Lee on 9/7/14.
//  Copyright (c) 2014 Kelvin. All rights reserved.
//

#import "KLEUtility.h"
#import "KLEDailyViewCell.h"

@implementation KLEDailyViewCell

- (void)setSelectedBackgroundView:(UIView *)selectedBackgroundView
{
    [super setSelectedBackgroundView:selectedBackgroundView];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
    
    if (self.selected) {
        [_routineNameLabel setTextColor:[UIColor whiteColor]];
        [UIView animateWithDuration:0.2 delay:0 options:UIViewAnimationOptionCurveEaseIn animations:^{
            _routineNameLabel.transform = CGAffineTransformMakeScale(1.10f, 1.10f);
        } completion:nil];
        
        [_startWorkoutButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [UIView animateWithDuration:0.2 delay:0 options:UIViewAnimationOptionCurveEaseIn animations:^{
            _startWorkoutButton.transform = CGAffineTransformMakeScale(1.25f, 1.25f);
        } completion:^(BOOL finished) {
//            _startWorkoutButton.transform = CGAffineTransformMakeScale(1.0f, 1.0f);
        }];
    }
    else
    {
        [_routineNameLabel setTextColor:[UIColor kPrimaryColor]];
        [UIView animateWithDuration:0.2 delay:0 options:UIViewAnimationOptionCurveEaseIn animations:^{
            _routineNameLabel.transform = CGAffineTransformMakeScale(1.0f, 1.0f);
        } completion:nil];
        
        [_startWorkoutButton setTitleColor:[UIColor kPrimaryColor] forState:UIControlStateNormal];
        [UIView animateWithDuration:0.2 delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
            _startWorkoutButton.transform = CGAffineTransformMakeScale(1.0f, 1.0f);
        } completion:^(BOOL finished) {
//            _startWorkoutButton.transform = CGAffineTransformMakeScale(1.0f, 1.0f);
        }];
    }
}

@end
