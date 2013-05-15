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
#import "CCTMXLayer+TileLifeLayer.h"

#import "Mapquake.h"
#import "Meteor.h"

enum
{
	TileMapTag = 9999,
    MeteorTag = 9998,
};

@interface Map : CCLayer {
    CCSprite *rightStack;
    CCSprite *leftStack;
    
    NSMutableArray *stackElementLeft;
    NSMutableArray *stackElementRight;
    CCLabelTTF *countdownLabel; //Texte contenant décompte du chronomètre
    int countdown; //Chronomètre
    
    //Variables de test
    CCLabelTTF *scoreLabelLeft;
    CCLabelTTF *scoreLabelRight;
    CCSprite *rightStackBar;
    CCSprite *leftStackBar;
    
    CCLabelTTF *numberOfUnitLeftLabel;
    CCLabelTTF *numberOfUnitRightLabel;
    
    int numberOfUnitLeft;
    int numberOfUnitRight;
    
    
    //Gestion des unités
    int level1UnitLeft;
    int level2UnitLeft;
    int level3UnitLeft;
    int level4UnitLeft;
    int level5UnitLeft;
    
    CCLabelTTF *level1UnitLeftLabel;
    CCLabelTTF *level2UnitLeftLabel;
    CCLabelTTF *level3UnitLeftLabel;
    CCLabelTTF *level4UnitLeftLabel;
    CCLabelTTF *level5UnitLeftLabel;
    
    int level1UnitRight;
    int level2UnitRight;
    int level3UnitRight;
    int level4UnitRight;
    int level5UnitRight;
    
    CCLabelTTF *level1UnitRightLabel;
    CCLabelTTF *level2UnitRightLabel;
    CCLabelTTF *level3UnitRightLabel;
    CCLabelTTF *level4UnitRightLabel;
    CCLabelTTF *level5UnitRightLabel;
    
}

+ (CCScene *) scene;
+ (CCScene *) sceneWithParameters:(BOOL)parameter;

@end
