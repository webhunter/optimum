//
//  GameLayer.h
//  optimum
//
//  Created by REY Morgan on 01/05/13.
//  Copyright 2013 __MyCompanyName__. All rights reserved.
//

@class GameView;

@protocol GameViewDelegate <NSObject>

- (void)gameViewController:(GameView *)controller didQuitWithReason:(QuitReason)reason;

@end

#import <Foundation/Foundation.h>
#import "cocos2d.h"
#import "Game.h"
#import "JoinLayer.h"


@interface GameLayer : CCLayer <UIAlertViewDelegate, GameDelegate> {
    
}

@property (nonatomic, weak) id <GameViewDelegate> delegate;
@property (nonatomic, strong) Game *game;
@property (nonatomic, weak) CCLabelTTF *message;

+(CCScene *) scene;

@end


