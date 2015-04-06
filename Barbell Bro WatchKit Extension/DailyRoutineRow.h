//
//  DailyRoutineRow.h
//  Barbell Bro
//
//  Created by Kelvin Lee on 4/5/15.
//  Copyright (c) 2015 Kelvin. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <WatchKit/WatchKit.h>

@interface DailyRoutineRow : NSObject

@property (weak, nonatomic) IBOutlet WKInterfaceButton *routineButton;
@property (weak, nonatomic) IBOutlet WKInterfaceLabel *dayLabel;
@end
