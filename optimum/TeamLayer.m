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


@implementation TeamLayer{
    CCMenuItemImage *buttonNext;
}

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

+(CCScene *) scene2
{
	// 'scene' is an autorelease object.
	CCScene *scene2 = [CCScene node];
	
	// 'layer' is an autorelease object.
	TeamLayer *layer2 = [TeamLayer node];
	
	// add layer as a child to scene
	[scene2 addChild: layer2];
	
	// return the scene
	return scene2;
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

// On surchage CCScene en lui indiquant les paramètres à passer
+ (CCScene *) sceneWithGameObject2:(Game*)gameObject
{
    // 'scene' is an autorelease object.
	CCScene *scene2 = [CCScene node];
	
	// On indique quel node (initialiseur) à utiliser
    // en lui passant les paramètres les mêmes que dans scene
	TeamLayer *layer2 = [TeamLayer nodeWithGameObject2:gameObject];
	
	// add layer as a child to scene
	[scene2 addChild: layer2];
	
	// return the scene
	return scene2;
}

// le node indique quel initialisateur est à utiliser
+ (id) nodeWithGameObject:(Game*)gameObject
{
    return [[self alloc] initWithGameObject:(Game*)gameObject];
}

// le node indique quel initialisateur est à utiliser
+ (id) nodeWithGameObject2:(Game*)gameObject
{
    return [[self alloc] initWithGameObject2:(Game*)gameObject];
}

- (id) initWithGameObject2:(Game*)gameObject
{
    if( (self=[super init]) ) {
        gameElement = gameObject;
        gameElement.delegate = self;
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
                        CCSprite *background = [CCSprite spriteWithFile:@"equipeIphone_nature-hd.png"];
                        [background setPosition:ccp(size.width/2, size.height/2)];
                        
                        [self addChild:background];
                        
                    }
                    else
                    {
                        // IPHONE RETINA SCREEN
                        CGSize size = [[CCDirector sharedDirector] winSize];
                        
                        // BackGround
                        CCSprite *background = [CCSprite spriteWithFile:@"equipeIphone_nature.png"];
                        [background setPosition:ccp(size.width/2, size.height/2)];
                        
                        [self addChild:background];
                    }
                }
            }
            
        }
    }
    return self;
    
}

- (id) initWithGameObject:(Game*)gameObject
{
    
    if( (self=[super init]) ) {
        gameElement = gameObject;
        gameElement.delegate = self;
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
                        CCSprite *background = [CCSprite spriteWithFile:@"equipeIphone_ville-HD.png"];
                        [background setPosition:ccp(size.width/2, size.height/2)];
                        
                        [self addChild:background];
                        
                    }
                    else
                    {
                        // IPHONE RETINA SCREEN
                        CGSize size = [[CCDirector sharedDirector] winSize];
                        
                        // BackGround
                        CCSprite *background = [CCSprite spriteWithFile:@"equipeIphone_ville.png"];
                        [background setPosition:ccp(size.width/2, size.height/2)];
                        
                        [self addChild:background];
                    }
                }
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
                CCSprite *background = [CCSprite spriteWithFile:@"background-hd.jpg"];
                [background setPosition:ccp(size.width/2, size.height/2)];
                
                [self addChild:background];
                
                //Titre
                CCLabelTTF *titre = [CCLabelTTF labelWithString:@"LES ÉQUIPES" fontName:@"Economica-Bold" fontSize:38];
                titre.position = ccp( size.width/2, size.height/2 + 300);
                
                [self addChild:titre];
                
                // Bouton back
                CCMenuItemImage *button_back = [CCMenuItemImage itemWithNormalImage:@"back_btn-hd.png" selectedImage:@"back_btn-hd.png" target:self selector:@selector(buttonPressedBack:)];
                
                CCMenu *menu_back = [CCMenu menuWithItems:button_back, nil];
                [menu_back setPosition:ccp( size.width/2 - 472, size.height/2 + 345)];
                
                [self addChild:menu_back];
                
                // Bouton Next
                buttonNext = [CCMenuItemImage itemWithNormalImage:@"suivant_btn-hd.png" selectedImage:@"suivant_btn-hd.png" target:self selector:@selector(onNewGame:)];
                
                CCMenu *menu_next = [CCMenu menuWithItems:buttonNext, nil];
                [menu_next setPosition:ccp( size.width/2, size.height/2 - 360)];
                
                [self addChild:menu_next];
                
                
                //Team
                CCSprite *ville = [CCSprite spriteWithFile:@"equipe_ville-hd.png"];
                [ville setPosition:ccp( size.width/2 - 235, size.height/2)];
                
                [self addChild:ville];
                
                CCSprite *nature = [CCSprite spriteWithFile:@"equipe_nature-hd.png"];
                [nature setPosition:ccp( size.width/2 + 235, size.height/2 - 12)];
                
                [self addChild:nature];
            }
            else
            {
                // IPAD SCREEN
                // ask director for the window size
                CGSize size = [[CCDirector sharedDirector] winSize];
                
                // BackGround
                CCSprite *background = [CCSprite spriteWithFile:@"background.jpg"];
                [background setPosition:ccp(size.width/2, size.height/2)];
                
                [self addChild:background];
                
                //Titre
                CCLabelTTF *titre = [CCLabelTTF labelWithString:@"LES ÉQUIPES" fontName:@"Economica-Bold" fontSize:38];
                titre.position = ccp( size.width/2, size.height/2 + 300);
                
                [self addChild:titre];
                
                // Bouton back
                CCMenuItemImage *button_back = [CCMenuItemImage itemWithNormalImage:@"back_btn.png" selectedImage:@"back_btn.png" target:self selector:@selector(buttonPressedBack:)];
                
                CCMenu *menu_back = [CCMenu menuWithItems:button_back, nil];
                [menu_back setPosition:ccp( size.width/2 - 472, size.height/2 + 345)];
                
                [self addChild:menu_back];
                
                // Bouton Next
                buttonNext = [CCMenuItemImage itemWithNormalImage:@"suivant_btn.png" selectedImage:@"suivant_btn.png" target:self selector:@selector(onNewGame:)];
                
                CCMenu *menu_next = [CCMenu menuWithItems:buttonNext, nil];
                [menu_next setPosition:ccp( size.width/2, size.height/2 - 360)];
                
                [self addChild:menu_next];
                
                
                //Team
                CCSprite *ville = [CCSprite spriteWithFile:@"equipe_ville.png"];
                [ville setPosition:ccp( size.width/2 - 235, size.height/2)];
                
                [self addChild:ville];
                
                CCSprite *nature = [CCSprite spriteWithFile:@"equipe_nature.png"];
                [nature setPosition:ccp( size.width/2 + 235, size.height/2 - 12)];
                
                [self addChild:nature];
            }
        }
    }
	return self;
}


- (void) onNewGame: (CCMenuItem  *) menuItem
{
    [buttonNext setVisible:NO];
    if( UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad )
    {
        CGFloat scale = [[UIScreen mainScreen] scale];
        if (scale > 1.0)
        {
            // IPAD RETINA SCREEN
            CGSize size = [[CCDirector sharedDirector] winSize];
            CCSprite *popup = [CCSprite spriteWithFile:@"popup_equipe-hd.png"];
            [popup setPosition:ccp( size.width/2 , size.height/2)];
            
            [self addChild:popup];
            
            // Bouton Next
            CCMenuItemImage *buttonNext = [CCMenuItemImage itemWithNormalImage:@"popup_equipe_check_btn-hd.png" selectedImage:@"popup_equipe_check_btn_vert-hd.png" target:self selector:@selector(onNewGame2:)];
            
            CCMenu *menu_next = [CCMenu menuWithItems:buttonNext, nil];
            [menu_next setPosition:ccp( size.width/2, size.height/2 - 133)];
            
            [self addChild:menu_next];
            
        }
        else
        {
            // IPAD
            CGSize size = [[CCDirector sharedDirector] winSize];
            CCSprite *popup = [CCSprite spriteWithFile:@"popup_equipe.png"];
            [popup setPosition:ccp( size.width/2 , size.height/2)];
            
            [self addChild:popup];
            
            // Bouton Next
            CCMenuItemImage *buttonNext = [CCMenuItemImage itemWithNormalImage:@"popup_equipe_check_btn.png" selectedImage:@"popup_equipe_check_btn_vert.png" target:self selector:@selector(onNewGame2:)];
            
            CCMenu *menu_next = [CCMenu menuWithItems:buttonNext, nil];
            [menu_next setPosition:ccp( size.width/2, size.height/2 - 133 )];
            
            [self addChild:menu_next];
        }
        
        
    }
}

- (void) onNewGame2: (CCMenuItem  *) menuItem
{
    // affichage de l'écran de Archipelago
    NSUserDefaults *archipelagosGameSave = [NSUserDefaults standardUserDefaults];
    
    [[CCDirector sharedDirector] pushScene:[Archipelago sceneWithParameters:[archipelagosGameSave objectForKey:@"cityNature"] andUniverse:@"cityNature" andGameObject:gameElement]];
}

- (void) buttonPressedBack: (id) sender
{
    // envoie données au joueurs
    Packet *packet = [Packet packetWithType:PacketTypeBack];
	[gameElement sendPacketToAllClients:packet];
    [[CCDirector sharedDirector] replaceScene:[GameLayer scene]];
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

