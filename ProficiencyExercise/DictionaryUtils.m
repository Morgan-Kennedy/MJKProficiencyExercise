//
//  DictionaryUtils.m
//  ProficiencyExercise
//
//  Created by Morgan Kennedy on 19/01/2015.
//  Copyright (c) 2015 MorganKennedy. All rights reserved.
//

#import "DictionaryUtils.h"

@implementation DictionaryUtils

#pragma mark -
#pragma mark - Public Class Methods
+ (NSString *)stringFromDictionary:(NSDictionary *)dictionary withKey:(NSString *)key
{
    id result = dictionary[key] == [NSNull null] ? nil : dictionary[key];
    if ([result isKindOfClass:[NSString class]])
    {
        return result;
    }
    NSLog(@"Dictionary object for Key: %@ is not a string", key);
    return nil;
}

@end
