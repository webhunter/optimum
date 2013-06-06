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
    
    NSString* file = @"fond-grille.png";

    CCTMXLayer* layer = [self layerNamed:@"Ground"];
    
    CCSprite *mapGrid = [CCSprite spriteWithFile:file];
    mapGrid.anchorPoint = ccp(.5, 0);
    mapGrid.position = ccp((mapGrid.boundingBox.size.width / 2), 0);
    [self addChild:mapGrid z:layer.zOrder];
    
    CCSprite *islandSprite = [CCSprite spriteWithFile:@"pic_socle.png"];
    islandSprite.anchorPoint = ccp(.5, 0);
        
    islandSprite.position = ccp((islandSprite.boundingBox.size.width / 2) - 3, - 118);

    [self addChild:islandSprite z:-1];
    
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
