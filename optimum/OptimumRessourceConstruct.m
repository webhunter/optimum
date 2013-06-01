//
//  OptimumRessourceConstruct.m
//  optimum
//
//  Created by Jean-Louis Danielo on 01/06/13.
//  Copyright 2013 __MyCompanyName__. All rights reserved.
//

#import "OptimumRessourceConstruct.h"


@implementation OptimumRessourceConstruct


- (void)onEnter
{
	[[[CCDirector sharedDirector] touchDispatcher] addTargetedDelegate:self priority:10000 swallowsTouches:YES];
	[super onEnter];
}

- (void)onExit
{
	[[[CCDirector sharedDirector] touchDispatcher] removeDelegate:self];
	[super onExit];
}

-(id) initWithTexture:(CCTexture2D*)texture rect:(CGRect)rect
{
	return [self initWithTexture:texture rect:rect rotated:NO];
}

- (id) initWithRessourceType:(int)ressourceType atPosition:(CGPoint)position
{
    if (self = [super init])
    {
        CCSpriteFrameCache* frameCache = [CCSpriteFrameCache sharedSpriteFrameCache];
        [frameCache addSpriteFramesWithFile:@"ConstructLayer.plist"];
        
        NSArray *ressourcesTypeArray = [[NSArray alloc] initWithObjects:
                                   @"ressource_vert.png",
                                   @"ressource_gris.png",
                                   @"ressource_rouge.png",
                                   nil];
        
        self = [super initWithSpriteFrameName:[ressourcesTypeArray objectAtIndex:ressourceType]];
     
        
        _type = ressourceType;
        self.tag = (42 * ressourceType) + (arc4random() % 100);
        CCLOG(@"tag : %i", self.tag);
        self.position = self.initPosition = ccp(position.x, position.y);
        hasUnits = YES;
        self.touchEnabled = YES;
    }
    
    return self;
}

- (BOOL)ccTouchBegan:(UITouch *)touch withEvent:(UIEvent *)event
{
    
    CGPoint touchPoint = [touch locationInView:[touch view]];
	touchPoint = [[CCDirector sharedDirector] convertToGL:touchPoint];
    
    if (hasUnits && self.touchEnabled == YES)
    {
        if([self isTouchOnSprite:touchPoint])
        {
            touchLocation = ccpSub(self.position, touchPoint);
            return YES;
        }
    }
	
	return NO;
}

- (CGPoint) locationFromTouch:(UITouch*)touch
{
	CGPoint touchPlace = [touch locationInView: [touch view]];
	return [[CCDirector sharedDirector] convertToGL:touchPlace];
}

- (void)ccTouchMoved:(UITouch *)touch withEvent:(UIEvent *)event
{
    CGPoint touchPoint = [self locationFromTouch:touch];
	self.position = ccpAdd(touchPoint, touchLocation);
    
    NSArray *objectsProperties = [[NSArray alloc] initWithObjects:
                                  [NSNumber numberWithInt:self.tag],
                                  [NSValue valueWithCGPoint:touchPoint],
                                  [NSValue valueWithCGPoint:self.initPosition],
                                  nil];
    
    NSArray *keysProperties = [[NSArray alloc] initWithObjects:@"tag", @"touchLocation", @"initPosition", nil];
    
    NSDictionary *optimumRessourceExtraProperties = [[NSDictionary alloc]
                                                     initWithObjects:objectsProperties
                                                     forKeys:keysProperties];
	[[NSNotificationCenter defaultCenter]
     postNotificationName:@"optimumRessourceConstructMove"
     object:optimumRessourceExtraProperties];
}

- (void)ccTouchEnded:(UITouch *)touch withEvent:(UIEvent *)event
{
    // Contient la position du doigt
	CGPoint touchPoint = [touch locationInView:[touch view]];
	touchPoint = [[CCDirector sharedDirector] convertToGL:touchPoint];
    
    NSArray *objectsProperties = [[NSArray alloc] initWithObjects:
                                  [NSValue valueWithCGPoint:self.initPosition],
                                  [NSNumber numberWithInt:self.tag],
                                  [NSValue valueWithCGPoint:touchPoint],
                                  [NSNumber numberWithInt:_type],
                                  nil];
    
    NSArray *keysProperties = [[NSArray alloc] initWithObjects:@"initPosition", @"tag", @"touchLocation", @"type", nil];
    
    NSDictionary *optimumRessourceExtraProperties = [[NSDictionary alloc]
                                                     initWithObjects:objectsProperties
                                                     forKeys:keysProperties];
	[[NSNotificationCenter defaultCenter]
     postNotificationName:@"optimumRessourceConstructEnd"
     object:optimumRessourceExtraProperties];
}

- (BOOL) isTouchOnSprite:(CGPoint)touch
{
	if(CGRectContainsPoint(CGRectMake(self.position.x - ((self.contentSize.width/2) * self.scale), self.position.y - ((self.contentSize.height/2) * self.scale), self.contentSize.width * self.scale, self.contentSize.height * self.scale), touch))
		return YES;
	else return NO;
}

- (CGPoint) initPosition{
    return initPosition;
}

- (void) setInitPosition:(CGPoint)position{
    initPosition = position;
}

- (BOOL) touchEnabled{
    return touchEnabled;
}

- (void) setTouchEnabled:(BOOL)_touchEnabled{
    touchEnabled = _touchEnabled;
}

@end
