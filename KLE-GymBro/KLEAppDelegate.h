//
//  KLEAppDelegate.h
//  KLE-GymBro
//
//  Created by Kelvin Lee on 9/1/14.
//  Copyright (c) 2014 Kelvin. All rights reserved.
//

#import "KLEDay.h"
#import "CoreDataHelper.h"
#import <UIKit/UIKit.h>

@interface KLEAppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;
@property (nonatomic, strong, readonly) CoreDataHelper *coreDataHelper;

@property (nonatomic, strong, readonly) KLEDay *dayInstance;

- (KLEDay *)day;
- (CoreDataHelper*)cdh;

@end
