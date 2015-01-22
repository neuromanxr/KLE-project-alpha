//
//  KLETableHeaderView.h
//  KLE-GymBro
//
//  Created by Kelvin Lee on 11/29/14.
//  Copyright (c) 2014 Kelvin. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface KLETableHeaderView : UIView

+ (id)customView;
@property (strong, nonatomic) IBOutlet UILabel *totalWeight;
@property (strong, nonatomic) IBOutlet UITextField *routineNameTextField;

@end
