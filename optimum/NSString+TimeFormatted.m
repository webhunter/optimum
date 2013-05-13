//
//  NSString+TimeFormatted.m
//  Optimum-maquette
//
//  Created by Jean-Louis Danielo on 27/04/13.
//
//

#import "NSString+TimeFormatted.h"

@implementation NSString (TimeFormatted)

- (NSString *)timeFormatted:(int)totalSeconds
{
    int seconds = totalSeconds % 60;
    int minutes = (totalSeconds / 60) % 60;
    
    return [NSString stringWithFormat:@"%02d:%02d", minutes, seconds];
}

@end
