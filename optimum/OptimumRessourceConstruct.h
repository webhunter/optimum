//
//  OptimumRessourceConstruct.h
//  optimum
//
//  Created by Jean-Louis Danielo on 01/06/13.
//  Copyright 2013 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"

@interface OptimumRessourceConstruct : CCSprite <CCTargetedTouchDelegate>
{
    BOOL isDrag;
	CGPoint touchLocation;
    CGPoint initPosition;
    int units; //Se charge de savoir s'il reste encore des unités
    BOOL hasUnits;
    BOOL touchEnabled; //Permet d'activer le touch
    CCSprite *ressource; // Sprite contenant la ressource
    int _type; //Permet de savoir quel type d'optimum a été lâché dans le chaudron, suit l'index du NSArray contenu dans le init
}

- (id) initWithRessourceType:(int)ressourceType atPosition:(CGPoint)position;

- (CGPoint) initPosition;
- (void) setInitPosition:(CGPoint)position;

- (BOOL) touchEnabled;
- (void) setTouchEnabled:(BOOL)_touchEnabled;

- (int) units;
- (void) setUnits:(int)unit;

- (int) _type;

@end
