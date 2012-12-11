//
//  UILabelStrikethrough.m
//  liveDeal
//
//  Created by claudio barbera on 25/11/12.
//  Copyright (c) 2012 claudio barbera. All rights reserved.
//

#import "UILabelStrikethrough.h"


@implementation UILabelStrikethrough


- (void)drawTextInRect:(CGRect)rect{
    [super drawTextInRect:rect];
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGSize textSize = [[self text] sizeWithFont:[self font]];
    
    CGFloat strikeWidth = textSize.width;
    CGContextFillRect(context,CGRectMake(0,rect.size.height/2,strikeWidth,1));
    
}

@end
