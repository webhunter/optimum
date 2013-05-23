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
    NSString *archipelago; //Archipel sélectionné, cela influe sur la map et les unités
    
    //Variables de test
    CCLabelTTF *scoreLabelLeft;
    CCLabelTTF *scoreLabelRight;
    CCSprite *rightStackBar;
    CCSprite *leftStackBar;
    
    int timeElapse;
    
    BOOL trux;
    
<<<<<<< HEAD
    int timeElapse, nbrGame;
    
    //Gestion des unités
    int level1UnitLeft, level2UnitLeft, level3UnitLeft, level4UnitLeft, level5UnitLeft;
    
    CCLabelTTF *level1UnitLeftLabel, *level2UnitLeftLabel, *level3UnitLeftLabel, *level4UnitLeftLabel, *level5UnitLeftLabel;
=======
    
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
>>>>>>> 79336757177b42f2cdbe07cc8151a89ce0d63ae5
    
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
<<<<<<< HEAD
    
    int unitLeftDestroyed;
    int unitRightDestroyed;
}

+ (CCScene *) scene;
+ (CCScene *) sceneWithParameters:(NSDictionary*)parameters;
=======
}

+ (CCScene *) scene;
+ (CCScene *) sceneWithParameters:(NSString*)parameter;
>>>>>>> 79336757177b42f2cdbe07cc8151a89ce0d63ae5

@end
