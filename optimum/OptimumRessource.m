//
//  OptimumRessource.m
//  Optimum-maquette
//
//  Created by Jean-Louis Danielo on 25/04/13.
//  Copyright 2013 __MyCompanyName__. All rights reserved.
//

#import "OptimumRessource.h"


#define ARC4RANDOM_MAX      0x100000000


@implementation OptimumRessource


-(id) initWithTexture:(CCTexture2D*)texture rect:(CGRect)rect
{
    if( (self=[super initWithTexture:texture rect:rect]))
    {
        CGSize size = [[CCDirector sharedDirector] winSize];
        
        randNum = rand() % (4000 - 1000) + 1000;
        double delay = arc4random() % 20;
         
        self.position = ccp(120 + arc4random() % ((int)size.width - (120*2)), size.height + 50);
        self.anchorPoint = ccp(.5, .5);
        self.touchEnabled = YES;
        
//        CCParticleSystem* system;
//        system = [CCParticleMeteor node];
//        system.scale = 2;
//        system.position = ccp(0, 768);
//        [self addChild:system z:1 tag:1];
        
        self.tag = randNum;
        self.scale = 1.1;
        
        CCAction* fall = [CCMoveTo actionWithDuration:5 + self.speedFall + (delay/3)
                                   position: ccp(self.position.x, 0)];
        fall.tag = randNum;
        [self runAction:fall];
        
        
        [self schedule: @selector(outOfScreen:) interval:1];
    }
    return self;
}

- (id) init
{
    CCSpriteFrameCache* frameCache = [CCSpriteFrameCache sharedSpriteFrameCache];
    [frameCache addSpriteFramesWithFile:@"Ressources.plist"];
    NSArray *optimumImages = [[NSArray alloc] initWithObjects:@"green.png", @"gray.png", @"red.png", @"mystere.png", nil];
    int category;//= arc4random() % [optimumImages count];
    
    double val = (double)rand() / RAND_MAX;
    
    if (val < 0.75)       //  5% .05
        category = 3;
    else if (val < 0.025)  //  5% + 20% .25
        category = 1;
    else if (val < 0.055)  //  5% + 20% + 30% .055
        category = 2;
    else
        category = 0;
    

    if ((self = [super initWithSpriteFrameName:[optimumImages objectAtIndex:category]]))
    {
        self.optimumType = self.speedFall = category;
    }
    return self;
}

//Récupère le type du l'optimum
- (int) optimumType{
    return optimumType;
}

- (void) setOptimumType:(int)_type{
    optimumType = _type;
}

//Vitesse de chute de l'optimum
- (float) speedFall{
    return speedFall;
}

- (void) setSpeedFall:(float)speed{
    speedFall = speed;
}

//Vérifie que l'Optimum est toujours visible à l'écran
- (void) outOfScreen: (ccTime) dt
{
    if (self.boundingBox.origin.y <= 200)
    {
        [self removeFromParentAndCleanup:YES];
    }
}

- (BOOL)ccTouchBegan:(UITouch *)touch withEvent:(UIEvent *)event
{    
    CGPoint touchPoint = [touch locationInView:[touch view]];
	touchPoint = [[CCDirector sharedDirector] convertToGL:touchPoint];

	if([self isTouchOnSprite:touchPoint] && self.touchEnabled == YES)
    {
        //Lorsque l'on touche le sprite, l'animation s'arrête
        [self stopAllActions];
		touchLocation = ccpSub(self.position, touchPoint);
        
        self.scale = 1.5;
        
		return YES;
	}
	
	return NO;
}

- (void)ccTouchMoved:(UITouch *)touch withEvent:(UIEvent *)event
{
	CGPoint touchPoint = [touch locationInView:[touch view]];
	touchPoint = [[CCDirector sharedDirector] convertToGL:touchPoint];
	
	self.position = ccpAdd(touchPoint, touchLocation);
}

- (BOOL) isTouchOnSprite:(CGPoint)touch
{
	if(CGRectContainsPoint(CGRectMake(self.position.x - ((self.contentSize.width/2) * self.scale), self.position.y - ((self.contentSize.height/2) * self.scale), self.contentSize.width * self.scale, self.contentSize.height * self.scale), touch))
		return YES;
	else return NO;
}

//-(void) registerWithTouchDispatcher
//{
//	[[[CCDirector sharedDirector] touchDispatcher] addTargetedDelegate:self priority:10 swallowsTouches:YES];
//}

- (void)onEnter
{
	[[[CCDirector sharedDirector] touchDispatcher] addTargetedDelegate:self priority:0 swallowsTouches:YES];
	[super onEnter];
}

- (void)onExit
{
	[[[CCDirector sharedDirector] touchDispatcher] removeDelegate:self];
	[super onExit];
}

- (void)ccTouchEnded:(UITouch *)touch withEvent:(UIEvent *)event
{
    self.scale = 1.1;
    NSArray *objectsProperties = [[NSArray alloc] initWithObjects:
                                                    [NSValue valueWithCGRect:self.boundingBox],
                                                    [NSNumber numberWithInt:self.tag],
                                                    nil];
    
    NSArray *keysProperties = [[NSArray alloc] initWithObjects:@"position", @"tag", nil];
    
    NSDictionary *optimumRessourceExtraProperties = [[NSDictionary alloc]
                                                     initWithObjects:objectsProperties
                                                     forKeys:keysProperties];
	[[NSNotificationCenter defaultCenter]
        postNotificationName:@"optimumPosition"
        object:optimumRessourceExtraProperties
     ];
    
    self.scale = 1;
}

- (BOOL) touchEnabled{
    return touchEnabled;
}

- (void) setTouchEnabled:(BOOL)_touchEnabled{
    touchEnabled = _touchEnabled;
}

@end