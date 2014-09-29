//
//  KLEHeaderView.h
//  KLE-GymBro
//
//  Created by Kelvin Lee on 9/23/14.
//  Copyright (c) 2014 Kelvin. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface KLEHeaderView : UIView

@property (weak, nonatomic) IBOutlet UILabel *selectedExerciseLabel;
@property (weak, nonatomic) IBOutlet UILabel *setsLabel;
@property (weak, nonatomic) IBOutlet UILabel *repsLabel;
@property (weak, nonatomic) IBOutlet UILabel *weightLabel;

@end
