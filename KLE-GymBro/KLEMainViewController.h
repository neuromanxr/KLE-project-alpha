//
//  KLEMainViewController.h
//  KLE-GymBro
//
//  Created by Kelvin Lee on 9/1/14.
//  Copyright (c) 2014 Kelvin. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface KLEMainViewController : UIViewController <UIPickerViewDataSource, UIPickerViewDelegate>

@property (weak, nonatomic) IBOutlet UILabel *exercise;
@property (weak, nonatomic) IBOutlet UIPickerView *exercisePicker;

@property (strong, nonatomic) NSArray *exerciseArray;

@end
