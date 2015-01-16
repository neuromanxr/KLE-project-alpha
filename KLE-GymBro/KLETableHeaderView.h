//
//  KLETableHeaderView.h
//  KLE-GymBro
//
//  Created by Kelvin Lee on 11/29/14.
//  Copyright (c) 2014 Kelvin. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface KLETableHeaderView : UIView

@property (strong, nonatomic) IBOutlet UITextField *nameTextField;
@property (strong, nonatomic) IBOutlet UILabel *exerciseCountLabel;
@property (strong, nonatomic) IBOutlet UILabel *totalWeightLabel;

+ (id)customView;

@end
