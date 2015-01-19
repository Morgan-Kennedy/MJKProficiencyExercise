//
//  APIManager.m
//  ProficiencyExercise
//
//  Created by Morgan Kennedy on 19/01/2015.
//  Copyright (c) 2015 MorganKennedy. All rights reserved.
//

#import "APIManager.h"
#import <AFNetworking.h>
#import "Fact.h"

#define APIBaseURL @"https://dl.dropboxusercontent.com/u/746330/"
#define APIBody @"facts.json"

@interface APIManager ()

@property (nonatomic, strong) AFHTTPRequestOperationManager *requestOperationManager;

@end

@implementation APIManager

#pragma mark -
#pragma mark - Lifecycle Methods
+ (APIManager *)sharedAPIManager
{
    static APIManager *sharedAPIManager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedAPIManager = [[APIManager alloc] init];
    });
    return sharedAPIManager;
}

- (id)init
{
    self = [super init];
    
    if (self)
    {
        _requestOperationManager = [[AFHTTPRequestOperationManager alloc] initWithBaseURL:[NSURL URLWithString:APIBaseURL]];
        _requestOperationManager.responseSerializer = [AFJSONResponseSerializer serializer];
        _requestOperationManager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/plain"];
    }
    
    return self;
}

#pragma mark -
#pragma mark - Public Methods
- (void)getFactsWithCompletion:(APIGetFactsCompletionBlock)completion
{
    NSString *stringURL = [NSString stringWithFormat:@"%@%@", APIBaseURL, APIBody];
    
    [self.requestOperationManager GET:stringURL
                           parameters:nil
                              success:^(AFHTTPRequestOperation *operation, id responseObject) {
                                  NSString *title = [responseObject objectForKey:@"title"];
                                  
                                  NSArray *factDictionaries = [responseObject objectForKey:@"rows"];
                                  NSMutableArray *facts = @[].mutableCopy;
                                  
                                  for (NSDictionary *factDictionary in factDictionaries)
                                  {
                                      Fact *fact = [[Fact alloc] initWithDictionary:factDictionary];
                                      if (fact)
                                      {
                                          [facts addObject:fact];
                                      }
                                  }
                                  
                                  if (completion)
                                  {
                                      completion(title, facts, YES, nil);
                                  }
                              }
                              failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                                  if (completion)
                                  {
                                      completion(nil, nil, NO, error);
                                  }
                                  else
                                  {
                                      NSLog(@"getFacts Failed: %@", error.localizedDescription);
                                  }
                              }];
}

@end
