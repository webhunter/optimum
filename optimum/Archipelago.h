//
//  Archipelago.h
//  optimum
//
//  Created by Jean-Louis Danielo on 19/05/13.
//  Copyright 2013 __MyCompanyName__. All rights reserved.
//
//  Affichage de l'archipel d'une galaxie

#import <Foundation/Foundation.h>
#import "cocos2d.h"
#import "Game.h"

@interface Archipelago : CCLayer {
    
    BOOL canPlayFirstGame;
    BOOL canPlaySecondGame;
    BOOL canPlayThirdGame;
    
    int nbrGame;
    NSString *archipelago;
}

+ (CCScene *) scene;
+ (CCScene *) sceneWithGameObject:(Game*)gameObject;

+ (CCScene *) sceneWithParameters:(NSDictionary*)parameters andUniverse:(NSString*)universe;
+ (CCScene *) sceneWithParameters:(NSDictionary*)parameters andUniverse:(NSString*)universe andGameObject:(Game*)gameObject;

- (id) initWithParameters:(NSDictionary*)parameters andUniverse:(NSString*)universe;
+ (id) nodeWithParameters:(NSDictionary*)parameters andUniverse:(NSString*)universe;

- (id) initWithGameObject:(Game*)gameObject;


@end
