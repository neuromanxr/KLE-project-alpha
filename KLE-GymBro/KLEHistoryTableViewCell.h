//
//  KLEHistoryTableViewCell.h
//  KLE-GymBro
//
//  Created by Kelvin Lee on 1/27/15.
//  Copyright (c) 2015 Kelvin. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface KLEHistoryTableViewCell : UITableViewCell

@property (strong, nonatomic) IBOutlet UILabel *routineName;
@property (strong, nonatomic) IBOutlet UILabel *exerciseLabel;

@property (strong, nonatomic) IBOutlet UILabel *setsLabel;
@property (strong, nonatomic) IBOutlet UILabel *repsLabel;
@property (strong, nonatomic) IBOutlet UILabel *prLabel;

@property (nonatomic, assign) NSUInteger setsCompleted;
//@property (nonatomic, assign) NSUInteger repsWeightCompleted;


@end
