//
//  TeamLayer.m
//  optimum
//
//  Created by REY Morgan on 13/05/13.
//  Copyright 2013 __MyCompanyName__. All rights reserved.
//

#import "TeamLayer.h"
#import "CCSlider.h"
#import "Map.h"
#import "Tips.h"
#import "Player.h"
#import "Archipelago.h"


@implementation TeamLayer{}

+(CCScene *) scene
{
	// 'scene' is an autorelease object.
	CCScene *scene = [CCScene node];
	
	// 'layer' is an autorelease object.
	TeamLayer *layer = [TeamLayer node];
	
	// add layer as a child to scene
	[scene addChild: layer];
	
	// return the scene
	return scene;
}

// On surchage CCScene en lui indiquant les paramètres à passer
+ (CCScene *) sceneWithGameObject:(Game*)gameObject
{
    // 'scene' is an autorelease object.
	CCScene *scene = [CCScene node];
	
	// On indique quel node (initialiseur) à utiliser
    // en lui passant les paramètres les mêmes que dans scene
	TeamLayer *layer = [TeamLayer nodeWithGameObject:gameObject];
	
	// add layer as a child to scene
	[scene addChild: layer];
	
	// return the scene
	return scene;
}

// le node indique quel initialisateur est à utiliser
+ (id) nodeWithGameObject:(Game*)gameObject
{
    return [[self alloc] initWithGameObject:(Game*)gameObject];
}

- (id) initWithGameObject:(Game*)gameObject
{
    
    if( (self=[super init]) ) {
        gameElement = gameObject;
        if( UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone )
        {
            if ([UIScreen instancesRespondToSelector:@selector(scale)])
            {
                CGFloat scale = [[UIScreen mainScreen] scale];
                if (scale > 1.0)
                {
                    if ([[UIScreen mainScreen] bounds].size.height == 568)
                    {
                        // IPHONE 5
                        CGSize size = [[CCDirector sharedDirector] winSize];
                        
                        // BackGround
                        CCSprite *background = [CCSprite spriteWithFile:@"fondVille.png"];
                        [background setPosition:ccp(size.width/2, size.height/2)];
                        
                        [self addChild:background];
                        
                        
                        // Logo Ville
                        CCSprite *ville = [CCSprite spriteWithFile:@"ville.png"];
                        [ville setPosition:ccp(size.width/2, size.height/2)];
                        
                        [self addChild:ville];
                        
                    }
                    else
                    {
                        // IPHONE RETINA SCREEN
                        CGSize size = [[CCDirector sharedDirector] winSize];
                        
                        // BackGround
                        CCSprite *background = [CCSprite spriteWithFile:@"fondVille.png"];
                        [background setPosition:ccp(size.width/2, size.height/2)];
                        
                        [self addChild:background];
                        
                        
                        // Logo Ville
                        CCSprite *ville = [CCSprite spriteWithFile:@"ville.png"];
                        [ville setPosition:ccp(size.width/2, size.height/2)];
                        
                        [self addChild:ville];
                    }
                }
            }
            else
            {
                // IPHONE SCREEN
                
            }
        }
		else
        {
            CGFloat scale = [[UIScreen mainScreen] scale];
            if (scale > 1.0)
            {
                // IPAD RETINA SCREEN
                // ask director for the window size
                CGSize size = [[CCDirector sharedDirector] winSize];
                
                // BackGround
                CCSprite *background = [CCSprite spriteWithFile:@"bg.jpg"];
                [background setPosition:ccp(size.width/2, size.height/2)];
                
                [self addChild:background];
                
                // Bouton back
                CCMenuItemImage *button_back = [CCMenuItemImage itemWithNormalImage:@"button_back.png" selectedImage:@"button_back.png" target:self selector:@selector(buttonPressedBack:)];
                
                CCMenu *menu_back = [CCMenu menuWithItems:button_back, nil];
                [menu_back setPosition:ccp( size.width/2 - 450, size.height/2 + 300)];
                
                [self addChild:menu_back];
                
                // Bouton Next
                CCMenuItemFont *buttonNext = [CCMenuItemFont itemWithString:@"NEXT" target:self selector:@selector(onNewGame:)];
                buttonNext.color = ccYELLOW;
                
                CCMenu *menu_next = [CCMenu menuWithItems:buttonNext, nil];
                [menu_next setPosition:ccp( size.width/2, size.height/2 - 300)];
                
                [self addChild:menu_next];
                
                
                //Team
                CCSprite *ville = [CCSprite spriteWithFile:@"ville.png"];
                [ville setPosition:ccp( size.width/2 - 300, size.height/2)];
                
                [self addChild:ville];
                
                CCSprite *nature = [CCSprite spriteWithFile:@"nature.png"];
                [nature setPosition:ccp( size.width/2 + 300, size.height/2)];
                
                [self addChild:nature];
            }
            else
            {
                // IPAD SCREEN
                // ask director for the window size
                CGSize size = [[CCDirector sharedDirector] winSize];
                
                // BackGround
                CCSprite *background = [CCSprite spriteWithFile:@"bg.jpg"];
                [background setPosition:ccp(size.width/2, size.height/2)];
                
                [self addChild:background];
            
                // Bouton back
                CCMenuItemImage *button_back = [CCMenuItemImage itemWithNormalImage:@"button_back.png" selectedImage:@"button_back.png" target:self selector:@selector(buttonPressedBack:)];
                
                CCMenu *menu_back = [CCMenu menuWithItems:button_back, nil];
                [menu_back setPosition:ccp( size.width/2 - 450, size.height/2 + 300)];
                
                [self addChild:menu_back];
                
                // Bouton Next
                CCMenuItemFont *buttonNext = [CCMenuItemFont itemWithString:@"NEXT" target:self selector:@selector(onNewGame:)];
                buttonNext.color = ccYELLOW;
                
                CCMenu *menu_next = [CCMenu menuWithItems:buttonNext, nil];
                [menu_next setPosition:ccp( size.width/2, size.height/2 - 300)];
                
                [self addChild:menu_next];

                
                //Team
                CCSprite *ville = [CCSprite spriteWithFile:@"ville.png"];
                [ville setPosition:ccp( size.width/2 - 300, size.height/2)];
                
                [self addChild:ville];
                
                CCSprite *nature = [CCSprite spriteWithFile:@"nature.png"];
                [nature setPosition:ccp( size.width/2 + 300, size.height/2)];
                
                [self addChild:nature];
            }
        }
    }
	return self;
}


- (void) onNewGame: (CCMenuItem  *) menuItem
{
    // affichage de l'écran de Archipelago
    NSUserDefaults *archipelagosGameSave = [NSUserDefaults standardUserDefaults];
    [[CCDirector sharedDirector] pushScene:[Archipelago sceneWithParameters:[archipelagosGameSave objectForKey:@"cityNature"] andUniverse:@"cityNature" andGameObject:gameElement]];
}

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

// on "dealloc" you need to release all your retained objects
- (void) dealloc
{
    // Called right after a node’s init method is called.
    // If using a CCTransitionScene: called when the transition begins.
    [super onEnter];
}

@end

