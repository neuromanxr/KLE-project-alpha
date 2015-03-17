//
//  KLEUtility.m
//  KLE-GymBro
//
//  Created by Kelvin Lee on 3/16/15.
//  Copyright (c) 2015 Kelvin. All rights reserved.
//

#import "KLEUtility.h"

@implementation KLEUtility

+ (UIFont *)getFontFromFontFamilyWithSize:(CGFloat)fontSize
{
    NSArray *fontFamily = [UIFont fontNamesForFamilyName:@"Heiti TC"];
    UIFont *font = [UIFont fontWithName:[fontFamily firstObject] size:fontSize];
    
    return font;
}

@end
