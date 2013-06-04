//
//  Map.h
//  Optimum-maquette
//
//  Created by Jean-Louis Danielo on 25/04/13.
//  Copyright 2013 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"

#import "CCUIViewWrapper.h"
#import "OptimumRessource.h"
#import "UnitSprite.h"

#import "FreezeScreen.h"

#import "NSString+TimeFormatted.h"
#import "UIColor+RVB255.h"
#import "Meteor.h"

#import "Mapquake.h"
#import "Game.h"

enum
{
	TileMapTag = 9999,
    MeteorTag = 9998,
    
    // "Ville" Chiffres impairs
    unitOddLevelOne = 10000,
    unitOddLevelTwo = 10001,
    unitOddLevelThree = 10002,
    unitOddLevelFour = 10003,
    unitOddLevelFive = 10004,
    
    // "Nature" Chiffres pairs
    unitEvenLevelOne = 10005,
    unitEvenLevelTwo = 10006,
    unitEvenLevelThree = 10007,
    unitEvenLevelFour = 10008,
    unitEvenLevelFive = 10009,
};


@interface Map : CCLayer  <GameDelegate>
{
    Game *gameElement;
    CCSprite *rightStack;
    CCSprite *leftStack;
    
    NSMutableArray *stackElementLeft;
    NSMutableArray *stackElementRight;
    CCLabelTTF *countdownLabel; //Texte contenant décompte du chronomètre
    int countdown; //Chronomètre
    NSString *archipelago; //Archipel sélectionné, cela influe sur la map et les unités
    
    //Variables de test
    CCLabelTTF *scoreLabelLeft;
    CCLabelTTF *scoreLabelRight;
    CCSprite *rightStackBar;
    CCSprite *leftStackBar;
    
    CCLabelTTF *numberOfUnitLeftLabel;
    CCLabelTTF *numberOfUnitRightLabel;
    
    int numberOfUnitLeft;
    int numberOfUnitRight;
    
    int timeElapse, nbrGame;
    
    //Gestion des unités
    int level1UnitLeft, level2UnitLeft, level3UnitLeft, level4UnitLeft, level5UnitLeft;
    
    CCLabelAtlas *level1UnitLeftLabel, *level2UnitLeftLabel, *level3UnitLeftLabel, *level4UnitLeftLabel, *level5UnitLeftLabel;
    
    int level1UnitRight;
    int level2UnitRight;
    int level3UnitRight;
    int level4UnitRight;
    int level5UnitRight;
    
    CCLabelAtlas *level1UnitRightLabel, *level2UnitRightLabel, *level3UnitRightLabel, *level4UnitRightLabel, *level5UnitRightLabel;
    
    int unitLeftDestroyed;
    int unitRightDestroyed;
    
    //Système de pause
    BOOL gameIsPause;
    
    
    //Gestion de l'écran
    CGSize size;
    
    CCLabelAtlas *label1;
}

+ (CCScene *) scene;
+ (CCScene *) sceneWithParameters:(NSDictionary*)parameters;

@end