//
//  KLETableHeaderView.m
//  KLE-GymBro
//
//  Created by Kelvin Lee on 11/29/14.
//  Copyright (c) 2014 Kelvin. All rights reserved.
//

#import "KLETableHeaderView.h"

@implementation KLETableHeaderView

+ (instancetype)routineExercisesTableHeaderView
{
    KLETableHeaderView *tableHeaderView = [[[NSBundle mainBundle] loadNibNamed:@"KLETableHeaderView" owner:self options:nil] lastObject];
    
    if ([tableHeaderView isKindOfClass:[KLETableHeaderView class]]) {
        return tableHeaderView;
    } else {
        return nil;
    }
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
