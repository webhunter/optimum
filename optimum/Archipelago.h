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

@interface Archipelago : CCLayer {
    
    BOOL canPlayFirstGame;
    BOOL canPlaySecondGame;
    BOOL canPlayThirdGame;
    
    int nbrGame;
}

+ (CCScene *) sceneWithParameters:(NSDictionary*)parameters;
- (id) initWithParameters:(NSDictionary*)parameters;
+ (id) nodeWithParameters:(NSDictionary*)parameters;

@end
