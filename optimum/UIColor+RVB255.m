//
//  UIColor+RVB255.m
//  photoquai
//
//  Created by Jean-Louis Danielo on 17/01/13.
//  Copyright (c) 2013 Groupe 5 PHQ Gobelins CDNL. All rights reserved.
//

#import "UIColor+RVB255.h"

@implementation UIColor (RVB255)

+ (UIColor *)r:(CGFloat)red g:(CGFloat)green b:(CGFloat)blue alpha:(CGFloat)alpha{
    
    float rouge = 0, vert = 0, bleu = 0;
    rouge = red/255;
    vert = green/255;
    bleu = blue/255;
    
    return [UIColor colorWithRed:rouge green:vert blue:bleu alpha:alpha];
}


@end
