//
//  FreezeScreen.m
//  Optimum-maquette
//
//  Created by Jean-Louis Danielo on 01/05/13.
//  Copyright 2013 __MyCompanyName__. All rights reserved.
//

#import "FreezeScreen.h"


@implementation FreezeScreen

-(id) initWithTexture:(CCTexture2D*)texture rect:(CGRect)rect WithUnitType:(int)unitType
{
	return [self initWithTexture:texture rect:rect rotated:NO];
}

- (id) init
{
    if ((self = [super initWithFile:@"ice-pattern.png"]))
    {
        int tag = 0;
        
        for (int i = 0; i < 21; i++) {
            for (int j = 0; j < 16; j++) {
                CCSprite *sprite = [[CCSprite alloc] initWithFile:@"ice-pattern.png"];
                sprite.anchorPoint = ccp(1, 0);
                sprite.position = ccp(63 + i * 50, j * 50);
                sprite.scale = CC_CONTENT_SCALE_FACTOR();
                
                [self addChild:sprite z:0 tag:tag];
                tag++;
            }
        }
    }
    
    [self schedule: @selector(removeFreeze:) interval:10];
    
    return self;
}

- (void) removeFreeze: (ccTime) dt
{
    [self removeFromParentAndCleanup:YES];
}

- (BOOL)ccTouchBegan:(UITouch *)touch withEvent:(UIEvent *)event
{
    CGPoint touchLocation = [touch locationInView: [touch view]];
	touchLocation = [[CCDirector sharedDirector] convertToGL: touchLocation];
    
    CCNode *child;
    CCARRAY_FOREACH(self.children, child)
    {
        CCNode* node = [self getChildByTag:child.tag];
        CCSprite* spriteTouched = (CCSprite*)node;
        
        if(CGRectContainsPoint(spriteTouched.boundingBox, touchLocation)){
            return YES;
            
        }
        
    }
	return NO;
}

- (void)ccTouchEnded:(UITouch *)touch withEvent:(UIEvent *)event
{
    CGPoint touchLocation = [touch locationInView: [touch view]];
	touchLocation = [[CCDirector sharedDirector] convertToGL: touchLocation];
    
    CCNode *child;
    CCARRAY_FOREACH(self.children, child)
    {
        CCNode* node = [self getChildByTag:child.tag];
        CCSprite* spriteTouched = (CCSprite*)node;
        //CCLOG(@"%@, %i", CGRectCreateDictionaryRepresentation(spriteTouched.boundingBox), spriteTouched.tag);
        if(CGRectContainsPoint(spriteTouched.boundingBox, touchLocation)){
            [spriteTouched removeFromParentAndCleanup: YES];
            
        }
        
    }
}

- (void)onEnter
{
	[[[CCDirector sharedDirector] touchDispatcher] addTargetedDelegate:self priority:1 swallowsTouches:YES];
	[super onEnter];
}

//-(void) registerWithTouchDispatcher {
//    [[[CCDirector sharedDirector] touchDispatcher] addTargetedDelegate:self priority:0 swallowsTouches:YES];
//}


- (void)onExit
{
	[[[CCDirector sharedDirector] touchDispatcher] removeDelegate:self];
	[super onExit];
}

@end
