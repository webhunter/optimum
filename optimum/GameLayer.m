//
//  GameLayer.m
//  optimum
//
//  Created by REY Morgan on 01/05/13.
//  Copyright 2013 __MyCompanyName__. All rights reserved.
//

#import "GameLayer.h"
#import "TeamLayer.h"

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
                
                _message = [CCLabelTTF labelWithString:@"Select your Galaxy" fontName:@"Marker Felt" fontSize:32];
                _message.position = ccp( size.width/2, size.height/2 + 200 );
                
                [self addChild:_message];
                
                // Bouton back
                CCMenuItemImage *button_back = [CCMenuItemImage itemWithNormalImage:@"button_back.png" selectedImage:@"button_back.png" target:self selector:@selector(buttonPressedBack:)];
                
                CCMenu *menu_back = [CCMenu menuWithItems:button_back, nil];
                //[menu alignItemsHorizontallyWithPadding:-10];
                [menu_back setPosition:ccp( size.width/2 - 450, size.height/2 + 300)];
                
                // Add the menu to the layer
                [self addChild:menu_back];
                
                //Archipels
                CCMenuItemImage *archipel1 = [CCMenuItemImage itemWithNormalImage:@"archipel_1.png" selectedImage:@"archipel_1.png" target:self selector:@selector(archipalgoPressed:)];
                archipel1.tag = 0;
                
                CCMenuItemImage *archipel2 = [CCMenuItemImage itemWithNormalImage:@"archipel_2.png" selectedImage:@"archipel_2.png" target:self selector:@selector(archipalgoPressed:)];
                archipel2.tag = 1;
                
                CCMenuItemImage *archipel3 = [CCMenuItemImage itemWithNormalImage:@"archipel_3.png" selectedImage:@"archipel_3.png" target:self selector:@selector(archipalgoPressed:)];
                archipel3.tag = 2;
                
                CCMenuItemImage *archipel4 = [CCMenuItemImage itemWithNormalImage:@"archipel_4.png" selectedImage:@"archipel_4.png" target:self selector:@selector(archipalgoPressed:)];
                archipel4.tag = 3;
                
                CCMenu *menuArchipel = [CCMenu menuWithItems:archipel1, archipel2, archipel3, archipel4, nil];
                [menuArchipel alignItemsHorizontallyWithPadding:90];
                [menuArchipel setPosition:ccp( size.width/2, size.height/2 - 60)];
                
                
                
                [self addChild:menuArchipel];
                
                // Name Archipels
                //archipel 1
                CCLabelTTF *archipel1Name = [CCLabelTTF labelWithString:@"ARCHIPEL 1" fontName:@"Marker Felt" fontSize:28];
                archipel1Name.position = ccp( size.width/2 - 300, size.height/2 - 160);
                
                [self addChild:archipel1Name];
                
                CCLabelTTF *didactitiel = [CCLabelTTF labelWithString:@"Didacticiel" fontName:@"Marker Felt" fontSize:24];
                didactitiel.position = ccp( size.width/2 - 300, size.height/2 - 200);
                
                [self addChild:didactitiel];
                
                //archipel 2
                CCLabelTTF *archipel2Name = [CCLabelTTF labelWithString:@"ARCHIPEL 2" fontName:@"Marker Felt" fontSize:28];
                archipel2Name.position = ccp( size.width/2 -100, size.height/2 +80 );
                
                [self addChild:archipel2Name];
                
                CCLabelTTF *ville = [CCLabelTTF labelWithString:@"Ville vs. Nature" fontName:@"Marker Felt" fontSize:24];
                ville.position = ccp( size.width/2 - 100, size.height/2 +40);
                
                [self addChild:ville];
                
                //archipel 3
                CCLabelTTF *archipel3Name = [CCLabelTTF labelWithString:@"ARCHIPEL 3" fontName:@"Marker Felt" fontSize:28];
                archipel3Name.position = ccp( size.width/2 +100, size.height/2 -160 );
                
                [self addChild:archipel3Name];
                
                CCLabelTTF *venus = [CCLabelTTF labelWithString:@"Venus vs. Mars" fontName:@"Marker Felt" fontSize:24];
                venus.position = ccp( size.width/2 + 100, size.height/2 -200);
                
                [self addChild:venus];
                
                //archipel 4
                CCLabelTTF *archipel4Name = [CCLabelTTF labelWithString:@"ARCHIPEL 4" fontName:@"Marker Felt" fontSize:28];
                archipel4Name.position = ccp( size.width/2 +300, size.height/2 +80 );
                
                [self addChild:archipel4Name];
                
                CCLabelTTF *humain = [CCLabelTTF labelWithString:@"Humain vs. Zombie" fontName:@"Marker Felt" fontSize:24];
                humain.position = ccp( size.width/2 +300, size.height/2 +40);
                
                [self addChild:humain];
            }
            else
            {
                // IPAD SCREEN
                // ask director for the window size
                CGSize size = [[CCDirector sharedDirector] winSize];
                
                _message = [CCLabelTTF labelWithString:@"Select your Galaxy" fontName:@"Marker Felt" fontSize:32];
                _message.position = ccp( size.width/2, size.height/2 + 200 );
                
                [self addChild:_message];
                
                // Bouton back
                CCMenuItemImage *button_back = [CCMenuItemImage itemWithNormalImage:@"button_back.png" selectedImage:@"button_back.png" target:self selector:@selector(buttonPressedBack:)];
                
                CCMenu *menu_back = [CCMenu menuWithItems:button_back, nil];
                //[menu alignItemsHorizontallyWithPadding:-10];
                [menu_back setPosition:ccp( size.width/2 - 450, size.height/2 + 300)];
                
                // Add the menu to the layer
                [self addChild:menu_back];
                
                //Archipels
                CCMenuItemImage *archipel1 = [CCMenuItemImage itemWithNormalImage:@"archipel_1.png" selectedImage:@"archipel_1.png" target:self selector:@selector(archipalgoPressed:)];
                archipel1.tag = 0;
                
                CCMenuItemImage *archipel2 = [CCMenuItemImage itemWithNormalImage:@"archipel_2.png" selectedImage:@"archipel_2.png" target:self selector:@selector(archipalgoPressed:)];
                archipel2.tag = 1;
                
                CCMenuItemImage *archipel3 = [CCMenuItemImage itemWithNormalImage:@"archipel_3.png" selectedImage:@"archipel_3.png" target:self selector:@selector(archipalgoPressed:)];
                archipel3.tag = 2;
                
                CCMenuItemImage *archipel4 = [CCMenuItemImage itemWithNormalImage:@"archipel_4.png" selectedImage:@"archipel_4.png" target:self selector:@selector(archipalgoPressed:)];
                archipel4.tag = 3;
                
                CCMenu *menuArchipel = [CCMenu menuWithItems:archipel1, archipel2, archipel3, archipel4, nil];
                [menuArchipel alignItemsHorizontallyWithPadding:-30];
                [menuArchipel setPosition:ccp( size.width/2, size.height/2 - 60)];
                
                archipel1.scale = 0.5;
                archipel2.scale = 0.5;
                archipel3.scale = 0.5;
                archipel4.scale = 0.5;
                
                [self addChild:menuArchipel];
                
                // Name Archipels
                //archipel 1
                CCLabelTTF *archipel1Name = [CCLabelTTF labelWithString:@"ARCHIPEL 1" fontName:@"Marker Felt" fontSize:28];
                archipel1Name.position = ccp( size.width/2 - 300, size.height/2 - 160);
                
                [self addChild:archipel1Name];
                
                CCLabelTTF *didactitiel = [CCLabelTTF labelWithString:@"Didactitiel" fontName:@"Marker Felt" fontSize:24];
                didactitiel.position = ccp( size.width/2 - 300, size.height/2 - 200);
                
                [self addChild:didactitiel];
                
                //archipel 2
                CCLabelTTF *archipel2Name = [CCLabelTTF labelWithString:@"ARCHIPEL 2" fontName:@"Marker Felt" fontSize:28];
            
                archipel2Name.position = ccp( size.width/2 -100, size.height/2 +80 );
                
                [self addChild:archipel2Name];
                
                CCLabelTTF *ville = [CCLabelTTF labelWithString:@"Ville vs. Nature" fontName:@"Marker Felt" fontSize:24];
                ville.position = ccp( size.width/2 - 100, size.height/2 +40);
                
                [self addChild:ville];
                
                //archipel 3
                CCLabelTTF *archipel3Name = [CCLabelTTF labelWithString:@"ARCHIPEL 3" fontName:@"Marker Felt" fontSize:28];
                archipel3Name.position = ccp( size.width/2 +100, size.height/2 -160 );
                
                [self addChild:archipel3Name];
                
                CCLabelTTF *venus = [CCLabelTTF labelWithString:@"Venus vs. Mars" fontName:@"Marker Felt" fontSize:24];
                venus.position = ccp( size.width/2 + 100, size.height/2 -200);
                
                [self addChild:venus];
                
                //archipel 4
                CCLabelTTF *archipel4Name = [CCLabelTTF labelWithString:@"ARCHIPEL 4" fontName:@"Marker Felt" fontSize:28];
                archipel4Name.position = ccp( size.width/2 +300, size.height/2 +80 );
                
                [self addChild:archipel4Name];
                
                CCLabelTTF *humain = [CCLabelTTF labelWithString:@"Humain vs. Zombie" fontName:@"Marker Felt" fontSize:24];
                humain.position = ccp( size.width/2 +300, size.height/2 +40);
                
                [self addChild:humain];
                
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
    [[CCDirector sharedDirector] replaceScene:[JoinLayer node]];
}

- (void) archipalgoPressed: (CCMenuItem*) sender
{
    NSUserDefaults *archipelagosGameSave = [NSUserDefaults standardUserDefaults];
    
    switch (sender.tag)
    {
    //On a sélectionné le didacticiel
        case 0:
//            [[CCDirector sharedDirector] replaceScene:[Archipelago sceneWithParameters:[archipelagosGameSave objectForKey:@"tutorial"] andUniverse:@"cityNature"]];
            break;
            
        case 1:
            [[CCDirector sharedDirector] replaceScene:[Archipelago sceneWithParameters:[archipelagosGameSave objectForKey:@"cityNature"] andUniverse:@"cityNature"]];
            break;
            
        default:
            break;
    }
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
        else
        {
            // IPHONE SCREEN
            
        }
        
        
    }
}

@end
