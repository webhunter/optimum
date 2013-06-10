//
//  CreditLayer.m
//  optimum
//
//  Created by REY Morgan on 09/06/13.
//  Copyright 2013 __MyCompanyName__. All rights reserved.
//

#import "CreditLayer.h"
#import "HelloWorldLayer.h"


@implementation CreditLayer

// Helper class method that creates a Scene with the HelloWorldLayer as the only child.
+(CCScene *) scene
{
	// 'scene' is an autorelease object.
	CCScene *scene = [CCScene node];
	
	// 'layer' is an autorelease object.
	CreditLayer *layer = [CreditLayer node];
	
	// add layer as a child to scene
	[scene addChild: layer];
	
	// return the scene
	return scene;
}

-(id) init
{
    if( UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad )
    {
        if((self=[super init]))
        {
            CGFloat scale = [[UIScreen mainScreen] scale];
            if (scale > 1.0)
            {
                // IPAD RETINA SCREEN
                // ask director for the window size
                CGSize size = [[CCDirector sharedDirector] winSize];
                
                // BackGround
                CCSprite *background = [CCSprite spriteWithFile:@"background_credits-hd.png"];
                [background setPosition:ccp(size.width/2, size.height/2)];
                
                [self addChild:background];
                
                // Bouton back
                CCMenuItemImage *button_back = [CCMenuItemImage itemWithNormalImage:@"back_btn-hd.png" selectedImage:@"back_btn-hd.png" target:self selector:@selector(buttonPressedBack:)];
                
                CCMenu *menu_back = [CCMenu menuWithItems:button_back, nil];
                [menu_back setPosition:ccp( size.width/2 - 472, size.height/2 + 345)];
                
                [self addChild:menu_back];
                
                //Titre
                CCLabelTTF *titre = [CCLabelTTF labelWithString:@"CRÉDITS" fontName:@"Economica-Bold" fontSize:38];
                titre.position = ccp( size.width/2, size.height/2 + 300);
                
                [self addChild:titre];
                
   
                
            }
            else
            {
                // IPAD
                // ask director for the window size
                CGSize size = [[CCDirector sharedDirector] winSize];
                
                // BackGround
                CCSprite *background = [CCSprite spriteWithFile:@"background_credits.png"];
                [background setPosition:ccp(size.width/2, size.height/2)];
                
                [self addChild:background];
                
                // Bouton back
                CCMenuItemImage *button_back = [CCMenuItemImage itemWithNormalImage:@"back_btn.png" selectedImage:@"back_btn.png" target:self selector:@selector(buttonPressedBack:)];
                
                CCMenu *menu_back = [CCMenu menuWithItems:button_back, nil];
                [menu_back setPosition:ccp( size.width/2 - 472, size.height/2 + 345)];
                
                [self addChild:menu_back];
                
                //Titre
                CCLabelTTF *titre = [CCLabelTTF labelWithString:@"CRÉDITS" fontName:@"Economica-Bold" fontSize:38];
                titre.position = ccp( size.width/2, size.height/2 + 300);
                
                [self addChild:titre];
                
            }
        }
        
    }
    return self;
}

- (void) buttonPressedBack: (id) sender
{
    [[CCDirector sharedDirector] replaceScene:[HelloWorldLayer node]];
}




@end
