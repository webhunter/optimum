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

#import "FreezeMap.h"
#import "FreezeScreen.h"

#import "NSString+TimeFormatted.h"
#import "UIColor+RVB255.h"
#import "Meteor.h"
//#import "CCTMXLayer+TileLifeLayer.h"

#import "Mapquake.h"

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
    CCSprite *hitbox;
    
    //Variables de test
    CCLabelTTF *scoreLabelLeft;
    CCLabelTTF *scoreLabelRight;
    CCSprite *rightStackBar;
    CCSprite *leftStackBar;
    
    CCLabelTTF *numberOfUnitLeftLabel;
    CCLabelTTF *numberOfUnitRightLabel;
    
    int numberOfUnitLeft;
    int numberOfUnitRight;
    
}

+ (CCScene *) scene;
+ (CCScene *) sceneWithParameters:(BOOL)parameter;

@end
