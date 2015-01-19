//
//  FactNode.m
//  ProficiencyExercise
//
//  Created by Morgan Kennedy on 19/01/2015.
//  Copyright (c) 2015 MorganKennedy. All rights reserved.
//

#import "FactNode.h"
#import <AsyncDisplayKit/ASDisplayNode+Subclasses.h>
#import "Fact.h"
#import "SQLayout.h"
#import "UIColor+HexString.h"
#import "Constants.h"

#define outerPadding 15.0f
#define innerPadding 10.0f
#define imageWidth 100.0f
#define imageHeight 60.0f

@interface FactNode ()

@property (nonatomic, strong) Fact *fact;

@property (nonatomic, strong) ASNetworkImageNode *imageNode;
@property (nonatomic, strong) ASTextNode *titleNode;
@property (nonatomic, strong) ASTextNode *descriptionNode;

- (NSDictionary *)titleStyle;
- (NSDictionary *)descriptionStyleCentered:(BOOL)isCentered;

@end

@implementation FactNode

#pragma mark -
#pragma mark - Lifecycle Methods
- (instancetype)initWithFact:(Fact *)fact isOddCell:(BOOL)isOddCell;
{
    self = [super init];
    
    if (self)
    {
        if (isOddCell)
        {
            self.backgroundColor = [UIColor colorWithHexString:BackgroundColor withAlpha:1.0f];
        }
        else
        {
            self.backgroundColor = [UIColor colorWithHexString:BackgroundCounterColor withAlpha:1.0f];
        }
        
        _titleNode = [[ASTextNode alloc] init];
        _titleNode.attributedString = [[NSAttributedString alloc] initWithString:fact.title
                                                                      attributes:[self titleStyle]];
        [self addSubnode:_titleNode];
        
        _descriptionNode = [[ASTextNode alloc] init];
        _descriptionNode.attributedString = [[NSAttributedString alloc] initWithString:fact.factDescription
                                                                            attributes:[self descriptionStyleCentered:NO]];
        [self addSubnode:_descriptionNode];
        
        _imageNode = [[ASNetworkImageNode alloc] init];
        _imageNode.contentMode = UIViewContentModeScaleAspectFit;
        _imageNode.URL = fact.imageURL;
        [self addSubnode:_imageNode];
        
        _fact = fact;
    }
    
    return self;
}

- (CGSize)calculateSizeThatFits:(CGSize)constrainedSize
{
    CGSize titleSize = [self.titleNode measure:CGSizeMake(constrainedSize.width - (2 * outerPadding), constrainedSize.height - (2 * outerPadding))];
    
    NSString *imageURLString = self.fact.imageURL.absoluteString;
    if (self.fact.factDescription.length && imageURLString.length) // Has both description and image
    {
        CGSize imageSize = CGSizeMake(imageWidth, imageHeight);
        
        CGSize descriptionSize = [self.descriptionNode measure:CGSizeMake(constrainedSize.width - (2 * outerPadding) - innerPadding - imageSize.width, constrainedSize.height)];
        
        CGFloat requiredHeight = imageHeight;
        if (descriptionSize.height > imageHeight)
        {
            requiredHeight = descriptionSize.height;
        }
        
        CGSize size = CGSizeMake(constrainedSize.width, requiredHeight + titleSize.height + innerPadding + (2 * outerPadding));
        return size;
    }
    else if (self.fact.factDescription.length) // Has only description (Note: Hockey Night and Space Program have busted Image URLs)
    {
        self.descriptionNode.attributedString = [[NSAttributedString alloc] initWithString:self.fact.factDescription
                                                                                attributes:[self descriptionStyleCentered:YES]];
        
        CGSize descriptionSize = [self.descriptionNode measure:CGSizeMake(constrainedSize.width - (2 * outerPadding), constrainedSize.height)];
        
        CGSize size = CGSizeMake(constrainedSize.width, descriptionSize.height + titleSize.height + innerPadding + (2 * outerPadding));
        return size;
    }
    else if (imageURLString.length) // Has only Image (Note: the Flag is supposed to be like this, but the Image URL is broken)
    {
        CGSize size = CGSizeMake(constrainedSize.width, imageHeight + titleSize.height + innerPadding + (2 * outerPadding));
        return size;
    }
    else // No description or image, return zero height (the odd even background colors will be off, but the model should prevent it from getting here)
    {
        return CGSizeMake(constrainedSize.width, 0.0f);
    }
}

- (void)layout
{
    CGSize titleSize = self.titleNode.calculatedSize;
    [SQLayout layoutNode:self.titleNode
          relativeToNode:self
               placement:SQPlaceWithin
               alignment:SQAlignHCenter | SQAlignTop
                withSize:titleSize
             withPadding:[SQLayout SQPaddingMakeTop:outerPadding
                                             Bottom:0
                                               Left:0
                                              Right:0]];
    
    NSString *imageURLString = self.fact.imageURL.absoluteString;
    if (self.fact.factDescription.length && imageURLString.length) // Has both description and image
    {
        CGSize descriptionSize = self.descriptionNode.calculatedSize;
        [SQLayout layoutNode:self.descriptionNode
              relativeToNode:self
                   placement:SQPlaceWithin
                   alignment:SQAlignTop | SQAlignLeft
                    withSize:descriptionSize
                 withPadding:[SQLayout SQPaddingMakeTop:outerPadding + self.titleNode.calculatedSize.height + innerPadding
                                                 Bottom:0
                                                   Left:outerPadding
                                                  Right:0]];
        
        [SQLayout layoutNode:self.imageNode
              relativeToNode:self
                   placement:SQPlaceWithin
                   alignment:SQAlignTop | SQAlignRight
                   withWidth:imageWidth
                  withHeight:imageHeight
                 withPadding:[SQLayout SQPaddingMakeTop:outerPadding + self.titleNode.calculatedSize.height + innerPadding
                                                 Bottom:0
                                                   Left:0
                                                  Right:outerPadding]];
    }
    else if (self.fact.factDescription.length) // Has only description
    {
        CGSize descriptionSize = self.descriptionNode.calculatedSize;
        [SQLayout layoutNode:self.descriptionNode
              relativeToNode:self
                   placement:SQPlaceWithin
                   alignment:SQAlignTop | SQAlignHCenter
                    withSize:descriptionSize
                 withPadding:[SQLayout SQPaddingMakeTop:outerPadding + self.titleNode.calculatedSize.height + innerPadding
                                                 Bottom:0
                                                   Left:0
                                                  Right:0]];
    }
    else if (imageURLString.length) // Has only Image (Note: the Flag is supposed to be like this, but the Image URL is broken)
    {
        [SQLayout layoutNode:self.imageNode
              relativeToNode:self
                   placement:SQPlaceWithin
                   alignment:SQAlignTop | SQAlignHCenter
                   withWidth:imageWidth
                  withHeight:imageHeight
                 withPadding:[SQLayout SQPaddingMakeTop:outerPadding + self.titleNode.calculatedSize.height + innerPadding
                                                 Bottom:0
                                                   Left:0
                                                  Right:0]];
    }
}

#pragma mark - 
#pragma mark - Private Methods
- (NSDictionary *)titleStyle
{
    UIFont *font = [UIFont fontWithName:@"HelveticaNeue-Bold" size:16.0f];
    
    NSMutableParagraphStyle *style = [[NSParagraphStyle defaultParagraphStyle] mutableCopy];
    style.paragraphSpacing = 0.5 * font.lineHeight;
    
    NSMutableParagraphStyle *paragraphStyle = NSMutableParagraphStyle.new;
    paragraphStyle.alignment = NSTextAlignmentCenter;
    
    return @{ NSFontAttributeName: font,
              NSParagraphStyleAttributeName: style,
              NSForegroundColorAttributeName: [UIColor colorWithHexString:TitleColor withAlpha:1.0f],
              NSParagraphStyleAttributeName: paragraphStyle };
}

- (NSDictionary *)descriptionStyleCentered:(BOOL)isCentered
{
    UIFont *font = [UIFont fontWithName:@"HelveticaNeue" size:12.0f];
    
    NSMutableParagraphStyle *style = [[NSParagraphStyle defaultParagraphStyle] mutableCopy];
    style.paragraphSpacing = 0.5 * font.lineHeight;
    
    if (isCentered)
    {
        return @{ NSFontAttributeName: font,
                  NSParagraphStyleAttributeName: style,
                  NSForegroundColorAttributeName: [UIColor colorWithHexString:TextColor withAlpha:1.0f] };
    }
    else
    {
        NSMutableParagraphStyle *paragraphStyle = NSMutableParagraphStyle.new;
        paragraphStyle.alignment = NSTextAlignmentCenter;
        
        return @{ NSFontAttributeName: font,
                  NSParagraphStyleAttributeName: style,
                  NSForegroundColorAttributeName: [UIColor colorWithHexString:TextColor withAlpha:1.0f],
                  NSParagraphStyleAttributeName: paragraphStyle };
    }
}

@end
