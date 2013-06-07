//
//  GameLayer.m
//  optimum
//
//  Created by REY Morgan on 01/05/13.
//  Copyright 2013 __MyCompanyName__. All rights reserved.
//

#import "GameLayer.h"
#import "TeamLayer.h"
#import "Packet.h"


#import "Archipelago.h"


@implementation GameLayer{
    
}

@synthesize delegate = _delegate;
@synthesize game = _game;
@synthesize message = _message;

+(CCScene *) scene
{
	// 'scene' is an autorelease object.
	CCScene *scene = [CCScene node];
	
	// 'layer' is an autorelease object.
	GameLayer *layer = [GameLayer node];
	
	// add layer as a child to scene
	[scene addChild: layer];
	
	// return the scene
	return scene;
}

-(id) init
{
	// always call "super" init
	// Apple recommends to re-assign "self" with the "super's" return value
	if( (self=[super init]) ) {
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
                        // ask director for the window size
                        CGSize size = [[CCDirector sharedDirector] winSize];
                        
                        _message = [CCLabelTTF labelWithString:@"Waiting for game to start..." fontName:@"Marker Felt" fontSize:24];
                        _message.position = ccp( size.width/2, size.height/2 );
                        
                        [self addChild:_message];
                        
                        // Bouton back
                        CCMenuItemImage *button_back = [CCMenuItemImage itemWithNormalImage:@"button_back.png" selectedImage:@"button_back.png" target:self selector:@selector(buttonPressedBack:)];
                        
                        CCMenu *menu_back = [CCMenu menuWithItems:button_back, nil];
                        //[menu alignItemsHorizontallyWithPadding:-10];
                        [menu_back setPosition:ccp( size.width/2 - 130, size.height/2 + 220)];
                        
                        // Add the menu to the layer
                        [self addChild:menu_back];
                        
                    }
                    else
                    {
                        // IPHONE RETINA SCREEN
                        // ask director for the window size
                        CGSize size = [[CCDirector sharedDirector] winSize];
                        
                        _message = [CCLabelTTF labelWithString:@"Waiting for game to start..." fontName:@"Marker Felt" fontSize:24];
                        _message.position = ccp( size.width/2, size.height/2 );
                        
                        [self addChild:_message];
                        
                        // Bouton back
                        CCMenuItemImage *button_back = [CCMenuItemImage itemWithNormalImage:@"button_back.png" selectedImage:@"button_back.png" target:self selector:@selector(buttonPressedBack:)];
                        
                        CCMenu *menu_back = [CCMenu menuWithItems:button_back, nil];
                        //[menu alignItemsHorizontallyWithPadding:-10];
                        [menu_back setPosition:ccp( size.width/2 - 130, size.height/2 + 190)];
                        
                        // Add the menu to the layer
                        [self addChild:menu_back];
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
                
                _message = [CCLabelTTF labelWithString:@"CHOISIR UN ARCHIPEL" fontName:@"Economica-Bold" fontSize:38];
                _message.position = ccp( size.width/2, size.height/2 + 300 );
                
                [self addChild:_message];
                
                // Bouton back
                CCMenuItemImage *button_back = [CCMenuItemImage itemWithNormalImage:@"back_btn-hd.png" selectedImage:@"back_btn-hd.png" target:self selector:@selector(buttonPressedBack:)];
                
                CCMenu *menu_back = [CCMenu menuWithItems:button_back, nil];
                [menu_back setPosition:ccp( size.width/2 - 472, size.height/2 + 345)];
                
                // Add the menu to the layer
                [self addChild:menu_back];
                
                //Archipels
                CCMenuItemImage *archipel1 = [CCMenuItemImage itemWithNormalImage:@"Archipel_01-hd.png" selectedImage:@"Archipel_01-hd.png" target:self selector:@selector(selectArchipel:)];
                archipel1.tag = 0;
                
                CCMenuItemImage *archipel2 = [CCMenuItemImage itemWithNormalImage:@"Archipel_02-hd.png" selectedImage:@"Archipel_02-hd.png" target:self selector:@selector(selectArchipel:)];
                archipel2.tag = 1;
                
                CCMenuItemImage *archipel3 = [CCMenuItemImage itemWithNormalImage:@"Archipel_03-hd.png" selectedImage:@"Archipel_03-hd.png" target:self selector:@selector(selectArchipel:)];
                archipel3.tag = 2;
                
                CCMenu *menuArchipel = [CCMenu menuWithItems:archipel1, archipel2, archipel3, nil];
                [menuArchipel alignItemsHorizontallyWithPadding:-90];
                [menuArchipel setPosition:ccp( size.width/2, size.height/2)];
                
                [self addChild:menuArchipel];
                
                // 3 petits points
                CCSprite *point1 = [CCSprite spriteWithFile:@"slide_point_01-hd.png"];
                [point1 setPosition:ccp(size.width/2 - 26, size.height/2 -350)];
                
                [self addChild:point1];
                
                CCSprite *point2 = [CCSprite spriteWithFile:@"slide_point_02-hd.png"];
                [point2 setPosition:ccp(size.width/2, size.height/2 - 350)];
                
                [self addChild:point2];
                
                CCSprite *point3 = [CCSprite spriteWithFile:@"slide_point_02-hd.png"];
                [point3 setPosition:ccp(size.width/2 + 26, size.height/2 - 350)];
                
                [self addChild:point3];
                
                
                // Name Archipels
                //archipel 1
                CCSprite *archipel1Name = [CCSprite spriteWithFile:@"Archipel_txt_01-hd.png"];
                archipel1Name.position = ccp( size.width/2 - 316, size.height/2 - 200);
                
                [self addChild:archipel1Name];
                
                //archipel 2
                CCSprite *archipel2Name = [CCSprite spriteWithFile:@"Archipel_txt_02-hd.png"];
                archipel2Name.position = ccp( size.width/2 , size.height/2 - 200 );
                
                [self addChild:archipel2Name];
                
                //archipel 3
                CCSprite *archipel3Name = [CCSprite spriteWithFile:@"Archipel_txt_03-hd.png"];
                archipel3Name.position = ccp( size.width/2 +316, size.height/2 - 200 );
                
                [self addChild:archipel3Name];
                
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
                
                _message = [CCLabelTTF labelWithString:@"CHOISIR UN ARCHIPEL" fontName:@"Economica-Bold" fontSize:38];
                _message.position = ccp( size.width/2, size.height/2 + 300 );
                
                [self addChild:_message];
                
                // Bouton back
                CCMenuItemImage *button_back = [CCMenuItemImage itemWithNormalImage:@"back_btn.png" selectedImage:@"back_btn.png" target:self selector:@selector(buttonPressedBack:)];
                CCMenu *menu_back = [CCMenu menuWithItems:button_back, nil];
                [menu_back setPosition:ccp( size.width/2 - 472, size.height/2 + 345)];
                
                // Add the menu to the layer
                [self addChild:menu_back];
                
                //Archipels
                CCMenuItemImage *archipel1 = [CCMenuItemImage itemWithNormalImage:@"Archipel_01.png" selectedImage:@"Archipel_01.png" target:self selector:@selector(selectArchipel:)];
                archipel1.tag = 0;
                
                CCMenuItemImage *archipel2 = [CCMenuItemImage itemWithNormalImage:@"Archipel_02.png" selectedImage:@"Archipel_02.png" target:self selector:@selector(selectArchipel:)];
                archipel2.tag = 1;
                
                CCMenuItemImage *archipel3 = [CCMenuItemImage itemWithNormalImage:@"Archipel_03.png" selectedImage:@"Archipel_03.png" target:self selector:@selector(selectArchipel:)];
                archipel3.tag = 2;
                
                CCMenu *menuArchipel = [CCMenu menuWithItems:archipel1, archipel2, archipel3, nil];
                [menuArchipel alignItemsHorizontallyWithPadding:-90];
                [menuArchipel setPosition:ccp( size.width/2, size.height/2)];
                
                [self addChild:menuArchipel];
                
                // 3 petits points
                CCSprite *point1 = [CCSprite spriteWithFile:@"slide_point_01.png"];
                [point1 setPosition:ccp(size.width/2 - 26, size.height/2 -350)];
                
                [self addChild:point1];
                
                CCSprite *point2 = [CCSprite spriteWithFile:@"slide_point_02.png"];
                [point2 setPosition:ccp(size.width/2, size.height/2 - 350)];
                
                [self addChild:point2];
                
                CCSprite *point3 = [CCSprite spriteWithFile:@"slide_point_02.png"];
                [point3 setPosition:ccp(size.width/2 + 26, size.height/2 - 350)];
                
                [self addChild:point3];
                
                
                // Name Archipels
                //archipel 1
                CCSprite *archipel1Name = [CCSprite spriteWithFile:@"Archipel_txt_01.png"];
                archipel1Name.position = ccp( size.width/2 - 316, size.height/2 - 200);
                
                [self addChild:archipel1Name];
                
                //archipel 2
                CCSprite *archipel2Name = [CCSprite spriteWithFile:@"Archipel_txt_02.png"];
                archipel2Name.position = ccp( size.width/2 , size.height/2 - 200 );
                
                [self addChild:archipel2Name];
                
                //archipel 3
                CCSprite *archipel3Name = [CCSprite spriteWithFile:@"Archipel_txt_03.png"];
                archipel3Name.position = ccp( size.width/2 +316, size.height/2 - 200 );
                
                [self addChild:archipel3Name];
                
            }
            
        }
    }
	return self;
}

- (void) dealloc
{
    
}

- (void) buttonPressedBack: (id) sender
{
    [self.game quitGameWithReason:QuitReasonUserQuit];
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone )
    {
        [[CCDirector sharedDirector] replaceScene:[JoinLayer node]];
    }
    else
    {
        [[CCDirector sharedDirector] replaceScene:[HostLayer node]];
    }

}


- (void) buttonDidactitielPressed: (id) sender
{
    
}

- (void) selectArchipel: (CCMenu*) sender
{
    switch (sender.tag) {
        case 0:
            //  Didacticiel
            CCLOG(@"Rien pour le moment");
            break;
        
        case 1:
            //  Ville contre nature
            [self buttonVillePressed];
            break;
        
        case 2:
            //  Cowboys vs. Indiens
            CCLOG(@"Rien pour le moment");
            break;
            
        default:
            break;
    }
}


- (void) buttonVillePressed
{
    // envoie données au joueur 1
    Packet *packet = [Packet packetWithType:PacketTypeTeam];
    Player *player = [self.game playerAtPosition:PlayerPositionLeft];
    NSArray *array = [[NSArray alloc] initWithObjects:player.peerID, nil];
	[self.game sendPacketToOneClient:packet andClient:array];
    
    // envoie données au joueur 2
    Packet *packet2 = [Packet packetWithType:PacketTypeTeam2];
    Player *player2 = [self.game playerAtPosition:PlayerPositionRight];
    NSArray *array2 = [[NSArray alloc] initWithObjects:player2.peerID, nil];
	[self.game sendPacketToOneClient:packet2 andClient:array2];

    
    // affichage de l'écran de Team
    [[CCDirector sharedDirector] pushScene:[TeamLayer sceneWithGameObject:self.game]];
}


#pragma mark - GameDelegate

- (void)game:(Game *)game didQuitWithReason:(QuitReason)reason
{
	[self.delegate gameViewController:nil didQuitWithReason:reason];
}

- (void)gameDidBegin:(Game *)game
{
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone) {
        if ([UIScreen instancesRespondToSelector:@selector(scale)])
        {
            CGFloat scale = [[UIScreen mainScreen] scale];
            if (scale > 1.0)
            {
                if ([[UIScreen mainScreen] bounds].size.height == 568)
                {
                    // IPHONE 5
                    // ask director for the window size
                    [_message setVisible:NO];
                    
                    CGSize size = [[CCDirector sharedDirector] winSize];
                    
                    CCLabelTTF *newMessage = [CCLabelTTF labelWithString:@"Waiting for choice of galaxy..." fontName:@"Marker Felt" fontSize:24];
                    newMessage.position = ccp( size.width/2, size.height/2 );
                    
                    [self addChild:newMessage];
                    
                }
                else
                {
                    // IPHONE RETINA SCREEN
                    // ask director for the window size
                    [_message setVisible:NO];
                    
                    CGSize size = [[CCDirector sharedDirector] winSize];
                    
                    CCLabelTTF *newMessage = [CCLabelTTF labelWithString:@"Waiting for choice of galaxy..." fontName:@"Marker Felt" fontSize:24];
                    newMessage.position = ccp( size.width/2, size.height/2 );
                    
                    [self addChild:newMessage];
                }
            }
        }

    }
}


-(void) onEnterTransitionDidFinish
{
    // Called right after onEnter.
    // If using a CCTransitionScene: called when the transition has ended.
    [super onEnterTransitionDidFinish];
}


@end
