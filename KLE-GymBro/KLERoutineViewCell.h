//
//  KLERoutineViewCell.h
//  KLE-GymBro
//
//  Created by Kelvin Lee on 9/8/14.
//  Copyright (c) 2014 Kelvin. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface KLERoutineViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *weightLabel;
@property (weak, nonatomic) IBOutlet UILabel *setsLabel;
@property (weak, nonatomic) IBOutlet UILabel *repsLabel;
//@property (weak, nonatomic) IBOutlet UITextField *routineNameField;
@property (strong, nonatomic) IBOutlet UILabel *nameLabel;

@end
