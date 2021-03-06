//
//  WaitLayer.m
//  optimum
//
//  Created by REY Morgan on 29/04/13.
//  Copyright 2013 __MyCompanyName__. All rights reserved.
//

#import "WaitLayer.h"


@implementation WaitLayer
{
    QuitReason _quitReason;
}

// Helper class method that creates a Scene with the HelloWorldLayer as the only child.
+(CCScene *) scene
{
	// 'scene' is an autorelease object.
	CCScene *scene = [CCScene node];
	
	// 'layer' is an autorelease object.
	WaitLayer *layer = [WaitLayer node];
	
	// add layer as a child to scene
	[scene addChild: layer];
	
	// return the scene
	return scene;
}

-(id) init
{
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
                        
                        // BackGround
                        CCSprite *background = [CCSprite spriteWithFile:@"background_iph-hd.png"];
                        [background setPosition:ccp(size.width/2, size.height/2)];
                        
                        [self addChild:background];
                        
                        CCLabelTTF *message = [CCLabelTTF labelWithString:@"EN COURS DE CONNEXION..." fontName:@"Economica-Bold" fontSize:24];
                        message.position = ccp( size.width/2, size.height/2 );
                        
                        [self addChild:message];
                        
                        // Bouton back
                        CCMenuItemImage *button_back = [CCMenuItemImage itemWithNormalImage:@"back_btn_iph-hd.png" selectedImage:@"back_btn_iph-hd.png" target:self selector:@selector(buttonPressedBack:)];
                        
                        CCMenu *menu_back = [CCMenu menuWithItems:button_back, nil];
                        //[menu alignItemsHorizontallyWithPadding:-10];
                        [menu_back setPosition:ccp( size.width/2 - 128, size.height/2 + 252)];
                        
                        // Add the menu to the layer
                        [self addChild:menu_back];
                    }
                    else
                    {
                        // IPHONE RETINA SCREEN
                        // ask director for the window size
                        CGSize size = [[CCDirector sharedDirector] winSize];
                        
                        // BackGround
                        CCSprite *background = [CCSprite spriteWithFile:@"background_iph.png"];
                        [background setPosition:ccp(size.width/2, size.height/2)];
                        
                        [self addChild:background];
                        
                        CCLabelTTF *message = [CCLabelTTF labelWithString:@"EN COURS DE CONNEXION..." fontName:@"Economica-Bold" fontSize:24];
                        message.position = ccp( size.width/2, size.height/2 );
                        
                        [self addChild:message];
                        
                        // Bouton back
                        CCMenuItemImage *button_back = [CCMenuItemImage itemWithNormalImage:@"back_btn_iph.png" selectedImage:@"back_btn_iph.png" target:self selector:@selector(buttonPressedBack:)];
                        
                        CCMenu *menu_back = [CCMenu menuWithItems:button_back, nil];
                        //[menu alignItemsHorizontallyWithPadding:-10];
                        [menu_back setPosition:ccp( size.width/2 - 128, size.height/2 + 208)];
                        
                        // Add the menu to the layer
                        [self addChild:menu_back];
                    }
                }
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
    _quitReason = QuitReasonUserQuit;
    [test disconnectFromServer];
    [[CCDirector sharedDirector] replaceScene:[JoinLayer node]];
}






@end
