//
//  NSIndexPathUtilities.h
//  KLE-GymBro
//
//  Created by Kelvin Lee on 10/23/14.
//  Copyright (c) 2014 Kelvin. All rights reserved.
//

#import <Foundation/Foundation.h>

#define INDEXPATH(SECTION, ROW) [NSIndexPath indexPathForRow:ROW inSection:SECTION]

@interface NSIndexPath (adjustments)

// Is this index path before the other
- (BOOL)before:(NSIndexPath *)path;

@property (nonatomic, readonly) NSIndexPath *next;
@property (nonatomic, readonly) NSIndexPath *previous;

@end

