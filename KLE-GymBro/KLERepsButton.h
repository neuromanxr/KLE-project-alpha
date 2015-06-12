//
//  KLERepsButton.h
//  KLE-GymBro
//
//  Created by Kelvin Lee on 2/18/15.
//  Copyright (c) 2015 Kelvin. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol KLERepsButtonDelegate <NSObject>

@optional

- (void)changeRepsValue:(BOOL)buttonSwitch;

@end

IB_DESIGNABLE

@interface KLERepsButton : UIControl

@property (nonatomic, strong) UILabel *repsLabel;
@property (nonatomic, strong) UILabel *minusLabel;
@property (nonatomic, strong) UILabel *plusLabel;

@property (nonatomic, weak) id<KLERepsButtonDelegate> delegate;

@end
