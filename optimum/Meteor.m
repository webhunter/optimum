//
//  Meteor.m
//  Optimum-maquette
//
//  Created by Jean-Louis Danielo on 04/05/13.
//  Copyright 2013 __MyCompanyName__. All rights reserved.
//

#import "Meteor.h"

#define ARC4RANDOM_MAX      0x100000000

@implementation Meteor

-(id) init
{

//    self = [CCParticleMeteor node];
//    self.scale = 5;
//    self.position = ccp(0, 768);
//    [system runAction:emitMove];
    
	return [self initWithTotalParticles:250];
}

-(id) initWithTotalParticles:(NSUInteger)numParticles
{
	self = [super initWithTotalParticles:numParticles];
	if (self)
	{
        CGSize size = [[CCDirector sharedDirector] winSize];
        int randNumber = arc4random() % 5;
        int randNumber2 = arc4random() % 15;
        
        // color of particles
        
        double val = (double)rand() / RAND_MAX;
        
        startColor.r = val;
        startColor.g = val;
        startColor.b = val;
        startColor.a = val;
        startColorVar.r = val;
        
        startColorVar.g = val;
        startColorVar.b = val;
        startColorVar.a = val;
        endColor.r = val;
        endColor.g = val;
        endColor.b = val;
        endColor.a = val;
        endColorVar.r = val;
        endColorVar.g = val;
        endColorVar.b = val;
        endColorVar.a = val;
        
		CCParticleMeteor *emitter2 = [[CCParticleMeteor alloc] initWithTotalParticles:150];
        
        emitter2.texture = [[CCTextureCache sharedTextureCache] addImage:@"fire.png"];
        
        emitter2.life = 0.5;
        emitter2.scale = randNumber;
        emitter2.duration = 2;
        emitter2.position = ccp(0, 70 * randNumber2);
        emitter2.speed = 0;
        
        emitter2.endColorVar = endColorVar;
        emitter2.endColor = endColor;
        emitter2.startColorVar = startColorVar;
        emitter2.startColor = startColor;
        
        id emitMove = [CCMoveTo actionWithDuration:1.5 position:ccp(size.width / 2, size.height / 2)];
        [emitter2 runAction:emitMove];
//        emitter2.autoRemoveOnFinish = YES;
        CCLOG(@"%@", CGPointCreateDictionaryRepresentation(emitter2.position));
        
        [self addChild:emitter2 z:1];
	}
	
	return self;
}

@end
