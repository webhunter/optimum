//
//  UnitBuilt.m
//  optimum
//
//  Created by Jean-Louis Danielo on 03/06/13.
//  Copyright 2013 __MyCompanyName__. All rights reserved.
//

#import "UnitBuilt.h"


@implementation UnitBuilt

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

- (id) initWithTexture:(CCTexture2D*)texture rect:(CGRect)rect
{
	return [self initWithTexture:texture rect:rect rotated:NO];
}

- (id) initWithUnitLevel:(int)unitLevel atPosition:(CGPoint)position ofTeam:(BOOL)_team
{
    if (self = [super init])
    {
        // Univers impairs (univers à droite)
        if (_team == YES) {
            CCSpriteFrameCache* frameCache = [CCSpriteFrameCache sharedSpriteFrameCache];
            [frameCache addSpriteFramesWithFile:@"Chaudron_nature.plist"];
            
            NSArray *ressourcesTypeArray = [[NSArray alloc] initWithObjects:
                                            @"unit_nature_1.png",
                                            @"unit_nature_2.png",
                                            @"unit_nature_3.png",
                                            @"unit_nature_4.png",
                                            @"unit_nature_5.png",
                                            nil];
            self = [super initWithSpriteFrameName:[ressourcesTypeArray objectAtIndex:unitLevel - 1]];
        }else{
            CCSpriteFrameCache* frameCache = [CCSpriteFrameCache sharedSpriteFrameCache];
            [frameCache addSpriteFramesWithFile:@"Chaudron_ville.plist"];
            
            NSArray *ressourcesTypeArray = [[NSArray alloc] initWithObjects:
                                            @"unit_ville_1.png",
                                            @"unit_ville_2.png",
                                            @"unit_ville_3.png",
                                            @"unit_ville_4.png",
                                            @"unit_ville_5.png",
                                            nil];
            self = [super initWithSpriteFrameName:[ressourcesTypeArray objectAtIndex:unitLevel - 1]];
        }
        
        
        level = unitLevel;
        self.tag = (234 * level);
        
        self.position = self.initPosition = ccp(position.x, position.y);
    }
    
    return self;
}

//+ (id)spriteWithSpriteFrameName:(NSString*)spriteFrameName
//{
//	CCSpriteFrame *frame = [[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:spriteFrameName];
//    
//	NSAssert1(frame!=nil, @"Invalid spriteFrameName: %@", spriteFrameName);
//	return [self spriteWithSpriteFrame:frame];
//}

- (BOOL)ccTouchBegan:(UITouch *)touch withEvent:(UIEvent *)event
{
    
    CGPoint touchPoint = [touch locationInView:[touch view]];
	touchPoint = [[CCDirector sharedDirector] convertToGL:touchPoint];
    
    if([self isTouchOnSprite:touchPoint])
    {
        touchLocation = ccpSub(self.position, touchPoint);
        return YES;
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
                                  [NSNumber numberWithInt:self.level],
                                  nil];
    
    NSArray *keysProperties = [[NSArray alloc] initWithObjects:@"initPosition", @"tag", @"touchLocation", @"level", nil];
    
    NSDictionary *optimumRessourceExtraProperties = [[NSDictionary alloc]
                                                     initWithObjects:objectsProperties
                                                     forKeys:keysProperties];
	[[NSNotificationCenter defaultCenter]
     postNotificationName:@"unitBuiltEnd"
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

- (int) level{
    return level;
}

@end
