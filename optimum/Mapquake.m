//
//  Mapquake.m
//  Optimum-maquette
//
//  Created by Jean-Louis Danielo on 04/05/13.
//  Copyright 2013 __MyCompanyName__. All rights reserved.
//

#import "Mapquake.h"


@implementation Mapquake


- (id) initWithTMXFile:(NSString *)tmxFile
{
    self = [CCTMXTiledMap tiledMapWithTMXFile:tmxFile];
    self.scale = CC_CONTENT_SCALE_FACTOR();
    
    CCSprite *islandSprite = [CCSprite spriteWithFile:@"island.png"];
    islandSprite.position = ccp(210.2, 15.3);
    islandSprite.anchorPoint = ccp(.5, .5);
    [self addChild:islandSprite];
    
    return self;
    
}

- (void) earthquake{
    
    CCMoveTo* moveForward = [CCMoveTo actionWithDuration:0.15f position:ccp(self.boundingBox.origin.x + 10, self.boundingBox.origin.y)];
    CCMoveTo* moveBackward = [CCMoveTo actionWithDuration:0.15f position:ccp(self.boundingBox.origin.x, self.boundingBox.origin.y)];
    
    CCSequence *pulseSequence = [CCSequence actionOne:moveForward two:moveBackward];
    CCRepeat *repeat = [CCRepeat actionWithAction:pulseSequence times:5];
    [self runAction:repeat];
}

@end
