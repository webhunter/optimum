//
//  UnitSprite.m
//  Optimum-maquette
//
//  Created by Jean-Louis Danielo on 27/04/13.
//  Copyright 2013 __MyCompanyName__. All rights reserved.
//

#import "UnitSprite.h"


@implementation UnitSprite


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

//-(void) registerWithTouchDispatcher {
//    [[[CCDirector sharedDirector] touchDispatcher] addTargetedDelegate:self priority:20 swallowsTouches:YES];
//}


-(id) initWithTexture:(CCTexture2D*)texture rect:(CGRect)rect
{
	return [self initWithTexture:texture rect:rect rotated:NO];
}

- (id) initWithUnitType:(int)unitType atPosition:(CGPoint)position withUnits:(int)numberUnits{
    
    CCSpriteFrameCache* frameCache = [CCSpriteFrameCache sharedSpriteFrameCache];
    [frameCache addSpriteFramesWithFile:@"sprites-interface.plist"];
    
    NSArray *unitsTypeArray = [[NSArray alloc] initWithObjects:
                               //niveau 1
                               @"unit-1-ville-color.png",
                               @"unit-1-nature-color.png",
                               //niveau 2
                               @"unit-2-ville-color.png",
                               @"unit-2-nature-color.png",
                               //niveau 3
                               @"unit-3-ville-color.png",
                               @"unit-3-nature-color.png",
                               //niveau 4
                               @"unit-4-ville-color.png",
                               @"unit-4-nature-color.png",
                               //niveau 5
                               @"unit-5-ville-color.png",
                               @"unit-5-nature-color.png",
                               nil];
    if (unitType > [unitsTypeArray count])
    {
        unitType = [unitsTypeArray count] - 1;
    }
    
    self = [super initWithSpriteFrameName:[unitsTypeArray objectAtIndex:unitType]];
//    self.scale = CC_CONTENT_SCALE_FACTOR();
    CCLOG(@"unit : %@", CGSizeCreateDictionaryRepresentation(self.boundingBox.size));
    self.anchorPoint = ccp(.5, .5);
    self.tag = arc4random() % 10000;
    self.level = unitType + 1;
    
    //Team gauche
    if (unitType % 2 == 0)
    {
        self.team = YES;
    }else{
        self.team = NO;
    }
    
    self.position = self.initPosition = ccp(position.x, position.y);
    
    hasUnits = YES;
    self.touchEnabled = YES;
    self.units = numberUnits; //On met une valeur par défaut
    unitTypeBW = unitType;
    
    [self schedule: @selector(hasUnits:) interval:0.5];
    
    return self;
}

//Vérifie que l'Optimum est toujours visible à l'écran
- (void) hasUnits: (ccTime) dt
{
    NSArray *unitsTypeArrayBW = [[NSArray alloc] initWithObjects:
                               //niveau 1
                               @"unit-1-ville-nb.png",
                               @"unit-1-nature-nb.png",
                               //niveau 2
                               @"unit-2-ville-nb.png",
                               @"unit-2-nb-color.png",
                               //niveau 3
                               @"unit-3-ville-nb.png",
                               @"unit-3-nature-nb.png",
                               //niveau 4
                               @"unit-4-ville-nb.png",
                               @"unit-4-nature-nb.png",
                               //niveau 5
                               @"unit-5-ville-nb.png",
                               @"unit-5-nature-nb.png",
                               nil];
    CCSprite *bw = [CCSprite spriteWithSpriteFrameName:[unitsTypeArrayBW objectAtIndex:unitTypeBW]];
    bw.anchorPoint = ccp(0, 0);
    if (self.units <= 0)
    {
        hasUnits = NO;
        [self addChild:bw];
    }else{
        hasUnits = YES;
        [self removeChild:bw cleanup:YES];
    }
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
    // Contient la position du doigt
//	CGPoint touchPoint = [touch locationInView:[touch view]]; 
//	touchPoint = [[CCDirector sharedDirector] convertToGL:touchPoint];
    
    //Gère le déplacement au toucher de l'unité
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
     postNotificationName:@"unitPositionMove"
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
                                  [NSNumber numberWithBool:self.team],
                                  nil];
    
    NSArray *keysProperties = [[NSArray alloc] initWithObjects:@"initPosition", @"tag", @"touchLocation", @"team", nil];
    
    NSDictionary *optimumRessourceExtraProperties = [[NSDictionary alloc]
                                                     initWithObjects:objectsProperties
                                                     forKeys:keysProperties];
	[[NSNotificationCenter defaultCenter]
        postNotificationName:@"unitPositionEnd"
        object:optimumRessourceExtraProperties];
}

- (BOOL) isTouchOnSprite:(CGPoint)touch
{
	if(CGRectContainsPoint(CGRectMake(self.position.x - ((self.contentSize.width/2) * self.scale), self.position.y - ((self.contentSize.height/2) * self.scale), self.contentSize.width * self.scale, self.contentSize.height * self.scale), touch))
		return YES;
	else return NO;
}

- (int) level{
    return level;
}

- (void) setLevel:(int)niveau{
   level = niveau;
}

- (CGPoint) initPosition{
    return initPosition;
}
- (void) setInitPosition:(CGPoint)position{
    initPosition = position;
}

- (void) setTeamy:(BOOL) equipe{
    teamy = equipe;
}

- (BOOL) teamy{
    return teamy;
}

- (int) units{
    return units;
}

- (void) setUnits:(int)unit{
    units = unit;
}

- (BOOL) touchEnabled{
    return touchEnabled;
}

- (void) setTouchEnabled:(BOOL)_touchEnabled{
    touchEnabled = _touchEnabled;
}

@end