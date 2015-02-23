//
//  KLERepsButton.h
//  KLE-GymBro
//
//  Created by Kelvin Lee on 2/18/15.
//  Copyright (c) 2015 Kelvin. All rights reserved.
//

#import <UIKit/UIKit.h>

IB_DESIGNABLE

@protocol KLERepsButtonDelegate <NSObject>

@optional

- (void)changeRepsValue:(BOOL)buttonSwitch;

@end

@interface KLERepsButton : UIButton

@property (nonatomic, weak) id<KLERepsButtonDelegate> delegate;

@end
