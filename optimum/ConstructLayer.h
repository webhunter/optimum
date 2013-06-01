//
//  ConstructLayer.h
//  optimum
//
//  Created by REY Morgan on 01/06/13.
//  Copyright 2013 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"
#import "Game.h"

#import "OptimumRessourceConstruct.h"

enum
{
	chaudronTag = 9999,
    unitToiPad = 9998,
};

@interface ConstructLayer : CCLayer<GameDelegate> {
    Game *gameElement;
    NSMutableSet *cauldronContent;
    BOOL shake_once;

    NSSet *unitLevelOneRecipe;
    NSSet *unitLevelTwoRecipe;
    NSSet *unitLevelThreeRecipe;
    NSSet *unitLevelFourRecipe;
    NSSet *unitLevelFiveRecipe;
}

+ (CCScene *) scene;
+ (CCScene *) sceneWithGameObject:(Game*)gameObject;
- (id) initWithGameObject:(Game*)gameObject;

@end
