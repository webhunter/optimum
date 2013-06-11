//
//  HelloWorldLayer.h
//  optimum
//
//  Created by REY Morgan on 28/04/13.
//  Copyright __MyCompanyName__ 2013. All rights reserved.
//


#import <GameKit/GameKit.h>

// When you import this file, you import all the cocos2d classes
#import "cocos2d.h"
#import "PlayLayer.h"
#import "HostLayer.h"
#import "JoinLayer.h"
#import "GameLayer.h"
#import "CreditLayer.h"
#import "RegleLayer.h"


// HelloWorldLayer
@interface HelloWorldLayer : CCLayer<HostViewDelegate, JoinViewDelegate, GameViewDelegate>{
    
    
}

// returns a CCScene that contains the HelloWorldLayer as the only child
+(CCScene *) scene;

@end
