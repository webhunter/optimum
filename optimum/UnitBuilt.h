//
//  UnitBuilt.h
//  optimum
//
//  Created by Jean-Louis Danielo on 03/06/13.
//  Copyright 2013 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"

@interface UnitBuilt : CCSprite <CCTargetedTouchDelegate>
{
    int level; //Permet de savoir quel type d'optimum a été lâché dans le chaudron, suit l'index du NSArray contenu dans le init
    BOOL isDrag;
	CGPoint touchLocation;
    CGPoint initPosition;
}

- (id) initWithUnitLevel:(int)unitLevel atPosition:(CGPoint)position ofTeam:(BOOL)team;

- (CGPoint) initPosition;
- (void) setInitPosition:(CGPoint)position;

- (int) level;

@end
