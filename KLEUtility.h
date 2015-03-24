//
//  KLEUtility.h
//  KLE-GymBro
//
//  Created by Kelvin Lee on 3/16/15.
//  Copyright (c) 2015 Kelvin. All rights reserved.
//

#import <Foundation/Foundation.h>

// formulas
#define SK_DEGREES_TO_RADIANS(__ANGLE__) ((__ANGLE__) * 0.0174532952f) // PI / 180
#define SK_RADIANS_TO_DEGREES(__ANGLE__) ((__ANGLE__) * 57.29577951f) // PI * 180


// colors
#define kPrimaryColor colorWithRed:197.0/255.0 green:45.0/255.0 blue:19.0/255.0 alpha:1.0
#define kSecondaryColor colorWithRed:255.0/255.0 green:128.0/255.0 blue:0.0/255.0 alpha:1.0
#define kTextColor colorWithRed:255.0/255.0 green:255.0/255.0 blue:255.0/255.0 alpha:1.0
#define kNavigationBarIconColor colorWithRed:255.0/255.0 green:128.0/255.0 blue:0.0/255.0 alpha:1.0
#define kTabBarSelectedIconColor colorWithRed:255.0/255.0 green:128.0/255.0 blue:0.0/255.0 alpha:1.0

#define BUTTONCOLOR [UIColor orangeColor]
#define BUTTONTWOTONECOLOR [UIColor colorWithRed:255.f green:204.f blue:102.f alpha:1.0]
#define BUTTONSELECTCOLOR [UIColor redColor]

// graph
#define kGraphPrimaryColor colorWithRed:197.0/255.0 green:45.0/255.0 blue:19.0/255.0 alpha:1.0
#define kGraphSecondaryColor colorWithRed:255.0/255.0 green:128.0/255.0 blue:0.0/255.0 alpha:1.0
#define kGraphPrimaryLineColor whiteColor
#define kGraphSecondaryLineColor colorWithRed:255.0/255.0 green:128.0/255.0 blue:0.0/255.0 alpha:1.0
#define kGraphTouchLineColor whiteColor
#define kGraphAxisLabelColor whiteColor
// notification
#define kExerciseGoalChangedNote @"ExerciseGoalChanged"
#define kWeightUnitChangedNote @"WeightUnitChanged"
// units
#define kUnitPounds @"lb"
#define kUnitKilograms @"kg"

// encoder keys - routine exercises screen
#define kSelectedRoutineIDKey @"selectedRoutineIDKey"
#define kCurrentModeKey @"currentModeKey"

// encoder keys - exercise detail screen
#define kSelectedExerciseDetailIDKey @"selectedExerciseDetailIDKey"

#define kWeightTextExerciseDetailKey @"weightTextExerciseDetailKey"
#define kWeightSliderValueExerciseDetailKey @"weightSliderValueExerciseDetailKey"
#define kWeightSliderLabelTextExerciseDetailKey @"weightSliderLabelTextExerciseDetailKey"

#define kSetsSliderValueExerciseDetailKey @"setsSliderValueExerciseDetailKey"
#define kRepsSliderValueExerciseDetailKey @"repsSliderValueExerciseDetailKey"
#define kSetsSliderLabelTextExerciseDetailKey @"setsSliderLabelTextExerciseDetailKey"
#define kRepsSliderLabelTextExerciseDetailKey @"repsSliderLabelTextExerciseDetailKey"

#define kSetsSegmentControlIndexExerciseDetailKey @"setsSegmentControlIndexExerciseDetailKey"
#define kRepsSegmentControlIndexExerciseDetailKey @"repsSegmentControlIndexExerciseDetailKey"

// encoder keys - history detail screen
#define kSelectedExerciseCompletedKey @"selectedExerciseCompletedKey"

// encoder keys - workout screen
#define kSelectedExerciseIDKey @"selectedExerciseIDKey"

#define kCurrentSetInWorkoutViewKey @"currentSetInWorkoutViewKey"
#define kCurrentSetInWorkoutButtonKey @"currentSetInWorkoutButtonKey"

#define kCurrentRepsWeightArrayKey @"currentRepsWeightArrayKey"
#define kWorkoutFeedTextKey @"workoutFeedTextKey"
#define kWeightTextKey @"weightTextKey"
#define kWeightSliderValueKey @"weightSliderValueKey"
#define kWeightSliderLabelTextKey @"weightSliderLabelTextKey"

#define kRepsValueKey @"repsValueKey"
#define kSetsProgressRingAngle @"setsProgressRingAngle"
#define kSetsForAngle @"setsForAngle"
#define kSetsButtonTitle @"setsButtonTitle"
// sets button states
#define kSetsButtonEnabledBoolKey @"setsButtonEnabledBoolKey"
#define kSetsButtonAlphaKey @"setsButtonAlphaKey"
// reps button states
#define kRepsButtonEnabledBoolKey @"repsButtonEnabledBoolKey"
#define kRepsButtonAlphaKey @"repsButtonAlphaKey"
// finish button states
#define kFinishButtonEnabledBoolKey @"finishButtonEnabledBoolKey"
#define kFinishButtonAlphaKey @"finishButtonAlphaKey"

typedef NS_ENUM(NSInteger, KLEDateRangeMode)
{
//    KLEDateRangeModeOneWeek,
//    KLEDateRangeModeTwoWeeks,
    KLEDateRangeModeThreeWeeks,
    KLEDateRangeModeThreeMonths,
    KLEDateRangeModeSixMonths,
//    KLEDateRangeModeNineMonths,
    KLEDateRangeModeOneYear,
    KLEDateRangeModeAll
};

@interface KLEUtility : NSObject

extern NSString *const kUnitWeightKey;

@property (nonatomic, assign) NSString *unitWeight;

+ (NSString *)weightUnitType;

+ (NSString *)changeWeightUnits;

+ (CGFloat)convertWeightUnits:(CGFloat)amount;

+ (UIFont *)getFontFromFontFamilyWithSize:(CGFloat)fontSize;

@end
