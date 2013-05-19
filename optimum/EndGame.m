//
//  EndGame.m
//  optimum
//
//  Created by Jean-Louis Danielo on 19/05/13.
//  Copyright 2013 __MyCompanyName__. All rights reserved.
//

#import "EndGame.h"

#import "Map.h"


@implementation EndGame

+ (CCScene *) sceneWithParameters:(NSDictionary*)parameters
{
	// 'scene' is an autorelease object.
	CCScene *scene = [CCScene node];
    
	// 'layer' is an autorelease object.
	EndGame *layer = [EndGame nodeWithParameters:parameters];
	
	// add layer as a child to scene
	[scene addChild: layer];
    
    //	CCLOG(@"parameter : %i", parameter);
	// return the scene
	return scene;
}

+ (id) nodeWithParameters:(NSDictionary*)parameters{
    return [[self alloc] initWithParameters:parameters];
}

- (id) initWithParameters:(NSDictionary*)parameters{
    
    if( (self=[super init]) )
    {
        CGSize size = [[CCDirector sharedDirector] winSize];
        
        CCMenuItemFont *buttonOne = [CCMenuItemFont itemWithString:@"Manche suivante"
                                                    target:self
                                                    selector:@selector(nextGame:)];
        buttonOne.color = ccRED;
        
        CCMenu *menu_back = [CCMenu menuWithItems: buttonOne, nil];
        [menu_back setPosition:ccp( size.width/2 - 450, size.height/2 + 300)];
        
        [self addChild:menu_back];
    }
    
    return self;
}

- (void) nextGame: (id) sender
{
    [[CCDirector sharedDirector]
     replaceScene:[CCTransitionFade transitionWithDuration:0.5f
                                    scene:[Map sceneWithParameters:nil]
                   ]];
}



//A RAJOUTER SUR TOUTES LES SCENES
-(void) onEnter
{
    // Called right after a node’s init method is called.
    // If using a CCTransitionScene: called when the transition begins.
    [super onEnter];
}

-(void) onEnterTransitionDidFinish
{
    // Called right after onEnter.
    // If using a CCTransitionScene: called when the transition has ended.
    [super onEnterTransitionDidFinish];
}

-(void) onExit
{
    // Called right before node’s dealloc method is called.
    // If using a CCTransitionScene: called when the transition has ended.
    [super onExit];
}

@end
