//
//  Custom.m
//  Lesson6
//
//  Created by Azat Almeev on 04.11.15.
//  Copyright © 2015 Azat Almeev. All rights reserved.
//

#import "NSData+Custom.h"

@implementation NSData (Custom)

- (NSString *)description {
    return [NSString stringWithFormat:@"<Data with length: %lu>", (unsigned long)self.length];
}

@end
