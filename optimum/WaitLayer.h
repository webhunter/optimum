//
//  WaitLayer.h
//  optimum
//
//  Created by REY Morgan on 29/04/13.
//  Copyright 2013 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"
#import "JoinLayer.h"
#import "MatchmakingClient.h"

@interface WaitLayer : CCLayer<MatchmakingClientDelegate> {
    MatchmakingClient *test;
}

+(CCScene *) scene;


@end
