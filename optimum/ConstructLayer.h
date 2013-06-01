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

@interface ConstructLayer : CCLayer<GameDelegate> {
    Game *gameElement;
}

+(CCScene *) scene;
+ (CCScene *) sceneWithGameObject:(Game*)gameObject;
- (id) initWithGameObject:(Game*)gameObject;

@end
