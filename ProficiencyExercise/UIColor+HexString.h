//
//  UIColor+HexString.h
//  ProficiencyExercise
//
//  Created by Morgan Kennedy on 19/01/2015.
//  Copyright (c) 2015 MorganKennedy. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIColor (HexString)

+ (UIColor *)colorWithHexString:(NSString *)hexString withAlpha:(CGFloat)givenAlpha;

@end
