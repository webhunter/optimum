//
//  UnitSprite.h
//  Optimum-maquette
//
//  Created by Jean-Louis Danielo on 27/04/13.
//  Copyright 2013 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"

@interface UnitSprite : CCSprite <CCTargetedTouchDelegate> {
    BOOL isDrag;
	CGPoint touchLocation;
    int level;
    CGPoint initPosition;
    BOOL teamy; // 0 : left | 1 = right
    int units; //Se charge de savoir s'il reste encore des unités
    BOOL hasUnits;
    int unitTypeBW; //Conserve le type d'unité pour le mode noir/blanc
}

- (BOOL) isTouchOnSprite:(CGPoint)touch;

- (int) level;
- (void) setLevel:(int)niveau;

- (CGPoint) initPosition;
- (id) initWithUnitType:(int)unitType atPosition:(CGPoint)position withUnits:(int)numberUnits;

- (BOOL) teamy;
- (void) setTeamy:(BOOL)equipe;

- (int) units;
- (void) setUnits:(int)unit;

@end
