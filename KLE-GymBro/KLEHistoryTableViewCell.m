//
//  KLEHistoryTableViewCell.m
//  KLE-GymBro
//
//  Created by Kelvin Lee on 1/27/15.
//  Copyright (c) 2015 Kelvin. All rights reserved.
//

#import "KLEUtility.h"
#import "KLEHistoryTableViewCell.h"

@interface KLEHistoryTableViewCell ()

@end

@implementation KLEHistoryTableViewCell

- (void)awakeFromNib
{
    [super awakeFromNib];
    // Initialization code
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
    
    if (self.selected) {
        [_exerciseLabel setTextColor:[UIColor whiteColor]];
        [_setsLabel setTextColor:[UIColor whiteColor]];
        [_prLabel setTextColor:[UIColor whiteColor]];
        [_routineName setTextColor:[UIColor whiteColor]];
        
    }
    else
    {
        [_exerciseLabel setTextColor:[UIColor kPrimaryColor]];
        [_setsLabel setTextColor:[UIColor kPrimaryColor]];
        [_prLabel setTextColor:[UIColor kPrimaryColor]];
        [_routineName setTextColor:[UIColor kPrimaryColor]];
        
    }
}


@end
