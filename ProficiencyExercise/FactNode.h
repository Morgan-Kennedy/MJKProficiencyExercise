//
//  FactNode.h
//  ProficiencyExercise
//
//  Created by Morgan Kennedy on 19/01/2015.
//  Copyright (c) 2015 MorganKennedy. All rights reserved.
//

#import <AsyncDisplayKit/AsyncDisplayKit.h>

@class Fact;

@interface FactNode : ASCellNode

- (instancetype)initWithFact:(Fact *)fact isOddCell:(BOOL)isOddCell;

@end
