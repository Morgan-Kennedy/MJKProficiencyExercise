//
//  APIManager.h
//  ProficiencyExercise
//
//  Created by Morgan Kennedy on 19/01/2015.
//  Copyright (c) 2015 MorganKennedy. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void (^APIGetFactsCompletionBlock)(NSString *title, NSArray *facts, BOOL success, NSError *error);

@interface APIManager : NSObject

+ (APIManager *)sharedAPIManager;

- (void)getFactsWithCompletion:(APIGetFactsCompletionBlock)completion;

@end
