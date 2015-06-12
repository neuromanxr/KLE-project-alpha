//
//  KLEManagedIDSelectionDelegate.h
//  KLE-GymBro
//
//  Created by Kelvin Lee on 1/14/15.
//  Copyright (c) 2015 Kelvin. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol KLEManagedIDSelectionDelegate <NSObject>
@required

- (void)selectedRoutineID:(id)objectID;

@end
