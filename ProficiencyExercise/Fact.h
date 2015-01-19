//
//  Fact.h
//  ProficiencyExercise
//
//  Created by Morgan Kennedy on 19/01/2015.
//  Copyright (c) 2015 MorganKennedy. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Fact : NSObject

@property (nonatomic, strong) NSString *title;
@property (nonatomic, strong) NSString *factDescription;
@property (nonatomic, strong) NSURL *imageURL;

/**
 Initialized the model by parsing the standard dictionary. 
 @return nil - If all values of the dictionary are null then 
 the model will return as nil and should be removed from the dataset.
 */
- (id)initWithDictionary:(NSDictionary *)factDictionary;

@end
