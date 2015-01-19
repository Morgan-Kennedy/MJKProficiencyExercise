//
//  Fact.m
//  ProficiencyExercise
//
//  Created by Morgan Kennedy on 19/01/2015.
//  Copyright (c) 2015 MorganKennedy. All rights reserved.
//

#import "Fact.h"
#import "DictionaryUtils.h"

@implementation Fact

#pragma mark -
#pragma mark - Lifecycle Methods
- (id)initWithDictionary:(NSDictionary *)factDictionary
{
    self = [super init];
    
    BOOL allNullValues = YES;
    
    if (self)
    {
        NSString *titleString = [DictionaryUtils stringFromDictionary:factDictionary withKey:@"title"];
        if (!titleString)
        {
            titleString = @"";
        }
        _title = titleString;
        
        NSString *descriptionString = [DictionaryUtils stringFromDictionary:factDictionary withKey:@"description"];
        if (!descriptionString)
        {
            descriptionString = @"";
        }
        else
        {
            allNullValues = NO;
        }
        _factDescription = descriptionString;
        
        NSString *imageURLString = [DictionaryUtils stringFromDictionary:factDictionary withKey:@"imageHref"];
        if (!imageURLString)
        {
            imageURLString = @"";
        }
        else
        {
            allNullValues = NO;
        }
        _imageURL = [NSURL URLWithString:imageURLString];
    }
    
    if (allNullValues)
    {
        return nil;
    }
    
    return self;
}

@end
