//
//  Tips.m
//  optimum
//
//  Created by Jean-Louis Danielo on 17/05/13.
//  Copyright 2013 __MyCompanyName__. All rights reserved.
//

#import "Tips.h"


//Scenes qui peuvent être chargées
#import "Map.h"
#import "Archipelago.h"

//Permet de créer des faux écrans de chargement

@implementation Tips

+ (CCScene *) scene
{
	// 'scene' is an autorelease object.
	CCScene *scene = [CCScene node];
	
	// 'layer' is an autorelease object.
	Tips *layer = [Tips node];
	
	// add layer as a child to scene
	[scene addChild: layer];
	
	// return the scene
	return scene;
}

+ (CCScene *) sceneWithNextScene:(NSDictionary*)nextScene{
    // 'scene' is an autorelease object.
	CCScene *scene = [CCScene node];
	
	// 'layer' is an autorelease object.
	Tips *layer = [Tips nodeWithParameters:nextScene];
	
	// add layer as a child to scene
	[scene addChild: layer];
	
	// return the scene
	return scene;
}

+ (id) nodeWithParameters:(NSDictionary*)parameters{
    return [[self alloc] initWithParameters:parameters];
}

- (id) initWithParameters:(NSDictionary*)parameters{
    
    if( self=[super init] )
    {
        nextScene = [parameters objectForKey:@"NextScene"];
        NSArray *loadingScreenMessages = [[NSArray alloc] initWithObjects:
                                          @"Les lois de Murphy maîtres de notre monde"
                                          , nil];
        
        CCLabelTTF* label = [CCLabelTTF labelWithString:[loadingScreenMessages objectAtIndex:0] fontName:@"Marker Felt" fontSize:24];
        CGSize size = [CCDirector sharedDirector].winSize;
        label.position = CGPointMake(size.width / 2, size.height / 2);
        [self addChild:label];
        
        [self scheduleOnce:@selector(loadScene:) delay:2.0f];
    }
    
    return self;
}

-(void) loadScene:(ccTime)delta
{
	// Decide which scene to load based on the TargetScenes enum.
	// You could also use TargetScene to load the same with using a variety of transitions.
    
    
    if ([nextScene isEqual: @"Map"]) {
        [[CCDirector sharedDirector] replaceScene:[Map scene]];
    }else if ([nextScene isEqual: @"Archipelago"]){
        [[CCDirector sharedDirector] replaceScene:[Archipelago sceneWithParameters:nil]];
    }else{
        CCLOG(@"Coucou");
    }
    
}

@end
