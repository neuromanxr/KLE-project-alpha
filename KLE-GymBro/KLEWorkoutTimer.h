//
//  KLEWorkoutTimer.h
//  KLE-GymBro
//
//  Created by Kelvin Lee on 3/21/15.
//  Copyright (c) 2015 Kelvin. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface KLEWorkoutTimer : UIControl

@property (strong, nonatomic) IBOutlet UILabel *timer;
@property (strong, nonatomic) IBOutlet UIButton *timerButton;
@property (strong, nonatomic) IBOutlet UIButton *resetTimerButton;

- (IBAction)timerButtonAction:(UIButton *)sender;
- (IBAction)resetTimerButtonAction:(UIButton *)sender;

@end
