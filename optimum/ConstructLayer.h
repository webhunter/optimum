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
#import "UnitBuilt.h"
#import "Packet.h"

enum
{
	chaudronTag = 9999,
    unitToiPad = 9998,
    unitBuiltTag = 4666,
    
    ressourceRedTag = 8001,
    ressourceGreenTag = 8002,
    ressourceGrayTag = 8003,
};

@interface ConstructLayer : CCLayer<GameDelegate> {
    Game *gameElement;
    NSCountedSet *cauldronContent;
    BOOL shake_once;

    NSCountedSet *unitLevelOneRecipe;
    NSCountedSet *unitLevelTwoRecipe;
    NSCountedSet *unitLevelThreeRecipe;
    NSCountedSet *unitLevelFourRecipe;
    NSCountedSet *unitLevelFiveRecipe;
    
    int redResourceInCauldron, redResource;
    int grayResourceInCauldron, grayResource;
    int greenResourceInCauldron, greenResource;
    
    CCLabelAtlas *redResourceInCauldronLabel, *redResourceLabel;
    CCLabelAtlas *grayResourceInCauldronLabel, *grayResourceLabel;
    CCLabelAtlas *greenResourceInCauldronLabel, *greenResourceLabel;
    
    BOOL team;
    int megaTag;
}

+ (CCScene *) scene;
+ (CCScene *) sceneWithGameObject:(Game*)gameObject;
- (id) initWithGameObject:(Game*)gameObject;

+ (CCScene *) scene2;
+ (CCScene *) sceneWithGameObject2:(Game*)gameObject;
- (id) initWithGameObject2:(Game*)gameObject;


@end
