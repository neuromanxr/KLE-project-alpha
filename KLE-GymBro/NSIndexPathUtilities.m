//
//  NSIndexPathUtilities.m
//  KLE-GymBro
//
//  Created by Kelvin Lee on 10/23/14.
//  Copyright (c) 2014 Kelvin. All rights reserved.
//

#import "NSIndexPathUtilities.h"

@implementation NSIndexPath (adjustments)

- (NSIndexPath *)next
{
    return INDEXPATH(self.section, self.row + 1);
}

- (NSIndexPath *)previous
{
    return INDEXPATH(self.section, MAX(0, self.row - 1));
}

- (BOOL)before:(NSIndexPath *)path
{
    if (self.section < path.section) return YES;
    if (self.section > path.section) return NO;
    return (self.row < path.row);
}

@end
