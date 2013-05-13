//
//  TeamLayer.h
//  optimum
//
//  Created by REY Morgan on 13/05/13.
//  Copyright 2013 __MyCompanyName__. All rights reserved.
//

@class GameView;

@protocol GameViewDelegate <NSObject>

@end

#import <Foundation/Foundation.h>
#import "cocos2d.h"
#import "Game.h"
#import "GameLayer.h"


@interface TeamLayer : CCLayer <GameDelegate> {
    
}

@property (nonatomic, weak) id <GameViewDelegate> delegate;
@property (nonatomic, strong) Game *game;

+(CCScene *) scene;

@end