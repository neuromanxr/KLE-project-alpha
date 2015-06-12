//
//  KLEUtility.m
//  KLE-GymBro
//
//  Created by Kelvin Lee on 3/16/15.
//  Copyright (c) 2015 Kelvin. All rights reserved.
//

#import "KLEUtility.h"

#define kUnitConvertToKg 0.453592
#define kUnitConvertToLb 2.20462

@implementation KLEUtility

NSString *const kUnitWeightKey = @"unitWeightKey";

+ (UIFont *)getFontFromFontFamilyWithSize:(CGFloat)fontSize
{
    NSArray *fontFamily = [UIFont fontNamesForFamilyName:@"Heiti TC"];
    UIFont *font = [UIFont fontWithName:[fontFamily firstObject] size:fontSize];
    
    return font;
}

+ (NSString *)weightUnitType
{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSString *unitWeightType = [userDefaults stringForKey:kUnitWeightKey];
    
    if ([unitWeightType isEqualToString:kUnitPounds]) {
        return kUnitPounds;
    }
    return kUnitKilograms;
}

+ (CGFloat)convertWeightUnits:(CGFloat)amount
{
    CGFloat newAmount = amount;
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSString *unitWeightType = [userDefaults stringForKey:kUnitWeightKey];

    if ([unitWeightType isEqualToString:kUnitPounds])
    {
        newAmount = amount * kUnitConvertToLb;
    }
    else if ([unitWeightType isEqualToString:kUnitKilograms])
    {
        newAmount = amount * kUnitConvertToKg;
    }
    
    return newAmount;
}

+ (NSString *)changeWeightUnits
{
    NSString *unitWeight;
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSString *unitWeightType = [userDefaults stringForKey:kUnitWeightKey];
    
    if ([unitWeightType isEqualToString:kUnitPounds])
    {
        unitWeight = kUnitPounds;
    }
    else if ([unitWeightType isEqualToString:kUnitKilograms])
    {
        unitWeight = kUnitKilograms;
    }
    
    return unitWeight;
}

@end
