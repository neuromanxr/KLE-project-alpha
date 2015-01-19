//
//  KLERoutineExerciseDetailViewController.m
//  KLE-GymBro
//
//  Created by Kelvin Lee on 1/16/15.
//  Copyright (c) 2015 Kelvin. All rights reserved.
//

#import "KLERoutineExerciseDetailViewController.h"
#import "KLEExerciseGoal.h"
#import "KLEExercise.h"

@interface KLERoutineExerciseDetailViewController ()

@end

@implementation KLERoutineExerciseDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
//    self.exerciseNameTitle.text = self.selectedRoutineExercise.exercise.exercisename;
    self.selectedRoutineExercise.sets = [NSNumber numberWithInt:10];
    self.setsAmount.text = [NSString stringWithFormat:@"%@", self.selectedRoutineExercise.sets];
    self.repsAmount.text = [NSString stringWithFormat:@"%@", self.selectedRoutineExercise.reps];
    self.weightAmount.text = [NSString stringWithFormat:@"%@", self.selectedRoutineExercise.weight];
    
    self.navigationItem.title = self.selectedRoutineExercise.exercise.exercisename;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
