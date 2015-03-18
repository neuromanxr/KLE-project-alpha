//
//  KLEUtility.h
//  KLE-GymBro
//
//  Created by Kelvin Lee on 3/16/15.
//  Copyright (c) 2015 Kelvin. All rights reserved.
//

#import <Foundation/Foundation.h>

#define kPrimaryColor colorWithRed:197.0/255.0 green:45.0/255.0 blue:19.0/255.0 alpha:1.0
#define kSecondaryColor colorWithRed:255.0/255.0 green:128.0/255.0 blue:0.0/255.0 alpha:1.0
#define kTextColor colorWithRed:255.0/255.0 green:255.0/255.0 blue:255.0/255.0 alpha:1.0
#define kNavigationBarIconColor colorWithRed:255.0/255.0 green:128.0/255.0 blue:0.0/255.0 alpha:1.0
#define kTabBarSelectedIconColor colorWithRed:255.0/255.0 green:128.0/255.0 blue:0.0/255.0 alpha:1.0

#define kGraphPrimaryColor colorWithRed:197.0/255.0 green:45.0/255.0 blue:19.0/255.0 alpha:1.0
#define kGraphSecondaryColor colorWithRed:255.0/255.0 green:128.0/255.0 blue:0.0/255.0 alpha:1.0
#define kGraphPrimaryLineColor whiteColor
#define kGraphSecondaryLineColor colorWithRed:255.0/255.0 green:128.0/255.0 blue:0.0/255.0 alpha:1.0
#define kGraphTouchLineColor whiteColor
#define kGraphAxisLabelColor whiteColor


#define kExerciseGoalChangedNote @"ExerciseGoalChanged"

typedef NS_ENUM(NSInteger, KLEDateRangeMode)
{
//    KLEDateRangeModeOneWeek,
//    KLEDateRangeModeTwoWeeks,
//    KLEDateRangeModeThreeWeeks,
    KLEDateRangeModeThreeMonths,
    KLEDateRangeModeSixMonths,
    KLEDateRangeModeNineMonths,
    KLEDateRangeModeOneYear,
    KLEDateRangeModeAll
};

@interface KLEUtility : NSObject

+ (UIFont *)getFontFromFontFamilyWithSize:(CGFloat)fontSize;

@end
