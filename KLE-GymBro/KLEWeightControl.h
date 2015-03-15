//
//  KLEWeightControl.h
//  KLE-GymBro
//
//  Created by Kelvin Lee on 3/15/15.
//  Copyright (c) 2015 Kelvin. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface KLEWeightControl : UIControl <UITextFieldDelegate>

@property (strong, nonatomic) IBOutlet UISlider *weightIncrementSlider;
@property (strong, nonatomic) IBOutlet UITextField *weightTextField;
@property (strong, nonatomic) IBOutlet UILabel *weightIncrementLabel;

@end
