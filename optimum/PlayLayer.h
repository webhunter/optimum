//
//  PlayLayer.h
//  optimum
//
//  Created by REY Morgan on 29/04/13.
//  Copyright 2013 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"
#import "HostLayer.h"
#import "JoinLayer.h"
#import "HelloWorldLayer.h"


@interface PlayLayer : CCLayer {
    
}

// returns a CCScene that contains the HelloWorldLayer as the only child
+(CCScene *) scene;

@end
