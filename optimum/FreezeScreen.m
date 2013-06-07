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
        
        CCSpriteFrameCache* frameCache = [CCSpriteFrameCache sharedSpriteFrameCache];
        [frameCache addSpriteFramesWithFile:@"Freezescreen.plist"];
        
        CCSprite *winter01 = [CCSprite spriteWithSpriteFrameName:@"winter01.png"];
        winter01.tag = 1;
        winter01.anchorPoint = ccp(0, 0);
        winter01.position = [[CCDirector sharedDirector] convertToGL: ccp(395, 488)];
        [self addChild:winter01];
 
        CCSprite *winter02 = [CCSprite spriteWithSpriteFrameName:@"winter02.png"];
        winter02.tag = 2;
        winter02.anchorPoint = ccp(0, 0);
        winter02.position = [[CCDirector sharedDirector] convertToGL: ccp(160, 503)];
        [self addChild:winter02];

        CCSprite *winter03 = [CCSprite spriteWithSpriteFrameName:@"winter03.png"];
        winter03.tag = 3;
        winter03.anchorPoint = ccp(0, 0);
        winter03.position = [[CCDirector sharedDirector] convertToGL: ccp(196, 765)];
        [self addChild:winter03];

        CCSprite *winter04 = [CCSprite spriteWithSpriteFrameName:@"winter04.png"];
        winter04.tag = 4;
        winter04.anchorPoint = ccp(0, 0);
        winter04.position = [[CCDirector sharedDirector] convertToGL: ccp(306, 637)];
        [self addChild:winter04];
        
        CCSprite *winter05 = [CCSprite spriteWithSpriteFrameName:@"winter05.png"];
        winter05.tag = 5;
        winter05.anchorPoint = ccp(0, 0);
        winter05.position = [[CCDirector sharedDirector] convertToGL: ccp(528, 414)];
        [self addChild:winter05];

        CCSprite *winter06 = [CCSprite spriteWithSpriteFrameName:@"winter06.png"];
        winter06.tag = 6;
        winter06.anchorPoint = ccp(0, 0);
        winter06.position = [[CCDirector sharedDirector] convertToGL: ccp(538, 696)];
        [self addChild:winter06];
        
        CCSprite *winter07 = [CCSprite spriteWithSpriteFrameName:@"winter07.png"];
        winter07.tag = 7;
        winter07.anchorPoint = ccp(0, 0);
        winter07.position = [[CCDirector sharedDirector] convertToGL: ccp(669, 320)];
        [self addChild:winter07];
        
        CCSprite *winter08 = [CCSprite spriteWithSpriteFrameName:@"winter08.png"];
        winter08.tag = 8;
        winter08.anchorPoint = ccp(0, 0);
        winter08.position = [[CCDirector sharedDirector] convertToGL: ccp(653, 644)];
        [self addChild:winter08];
        
        CCSprite *winter09 = [CCSprite spriteWithSpriteFrameName:@"winter09.png"];
        winter09.tag = 9;
        winter09.anchorPoint = ccp(0, 0);
        winter09.position = [[CCDirector sharedDirector] convertToGL: ccp(594, 768)];
        [self addChild:winter09];
        
        CCSprite *winter10 = [CCSprite spriteWithSpriteFrameName:@"winter10.png"];
        winter10.tag = 10;
        winter10.anchorPoint = ccp(0, 0);
        winter10.position = [[CCDirector sharedDirector] convertToGL: ccp(300, 768)];
        [self addChild:winter10];
        
        CCSprite *winter11 = [CCSprite spriteWithSpriteFrameName:@"winter11.png"];
        winter11.tag = 11;
        winter11.anchorPoint = ccp(5, 0);
        winter11.position = [[CCDirector sharedDirector] convertToGL: ccp(183.5, 601.5)];
        [self addChild:winter11];
        
        CCSprite *winter12 = [CCSprite spriteWithSpriteFrameName:@"winter12.png"];
        winter12.tag = 12;
        winter12.anchorPoint = ccp(0, 13);
        winter12.position = [[CCDirector sharedDirector] convertToGL: ccp(0, 489)];
        [self addChild:winter12];
        
        CCSprite *winter13 = [CCSprite spriteWithSpriteFrameName:@"winter13.png"];
        winter13.tag = 13;
        winter13.anchorPoint = ccp(0, 0);
        winter13.position = [[CCDirector sharedDirector] convertToGL: ccp(0, 328)];
        [self addChild:winter13];
        
        CCSprite *winter14 = [CCSprite spriteWithSpriteFrameName:@"winter14.png"];
        winter14.tag = 14;
        winter14.anchorPoint = ccp(0, 0);
        winter14.position = [[CCDirector sharedDirector] convertToGL: ccp(330, 308)];
        [self addChild:winter14];
    }
    
    [self setPosition:ccp(15, 15)];
//    [self schedule: @selector(removeFreeze:) interval:10];
    
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

- (void)onExit
{
	[[[CCDirector sharedDirector] touchDispatcher] removeDelegate:self];
	[super onExit];
}

@end
