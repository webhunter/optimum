//
//  RegleLayer.m
//  optimum
//
//  Created by REY Morgan on 11/06/13.
//  Copyright 2013 __MyCompanyName__. All rights reserved.
//

#import "RegleLayer.h"
#import "HelloWorldLayer.h"
#import "SlidingMenuGrid.h"


@implementation RegleLayer

// Helper class method that creates a Scene with the HelloWorldLayer as the only child.
+(CCScene *) scene
{
	// 'scene' is an autorelease object.
	CCScene *scene = [CCScene node];
	
	// 'layer' is an autorelease object.
	RegleLayer *layer = [RegleLayer node];
	
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
                CCSprite *background = [CCSprite spriteWithFile:@"background-hd.jpg"];
                [background setPosition:ccp(size.width/2, size.height/2)];
                
                [self addChild:background];
                
                // Bouton back
                CCMenuItemImage *button_back = [CCMenuItemImage itemWithNormalImage:@"back_btn-hd.png" selectedImage:@"back_btn-hd.png" target:self selector:@selector(buttonPressedBack:)];
                
                CCMenu *menu_back = [CCMenu menuWithItems:button_back, nil];
                [menu_back setPosition:ccp( size.width/2 - 472, size.height/2 + 345)];
                
                [self addChild:menu_back];
                
                //Titre
                CCLabelTTF *titre = [CCLabelTTF labelWithString:@"RÈGLES" fontName:@"Economica-Bold" fontSize:38];
                titre.position = ccp( size.width/2, size.height/2 + 300);
                
                [self addChild:titre];
                
                id target = self;
                //objc_selector* selector = @selector(LaunchLevel:);
                int iMaxLevels = 11;
                
                NSMutableArray* allItems = [NSMutableArray arrayWithCapacity:11];
                for (int i = 1; i <= iMaxLevels; ++i)
                {
                    CCSprite* normalSprite = [CCSprite spriteWithFile:[NSString stringWithFormat:@"frame-%d-hd.png",i]];
                    CCSprite* selectedSprite = [CCSprite spriteWithFile:[NSString stringWithFormat:@"frame-%d-hd.png",i]];
                    CCMenuItemSprite* item =[CCMenuItemSprite itemFromNormalSprite:normalSprite selectedSprite:selectedSprite target:target selector:@selector(LaunchLevel:)];
                    [allItems addObject:item];
                }
                
                SlidingMenuGrid* menuGrid = [SlidingMenuGrid menuWithArray:allItems cols:1 rows:1 position:CGPointMake(size.width/2, size.height/2) padding:CGPointMake(90.f, 80.f) ];
                [self addChild:menuGrid];
                
                
                
            }
            else
            {
                // IPAD
                // ask director for the window size
                CGSize size = [[CCDirector sharedDirector] winSize];
                
                // BackGround
                CCSprite *background = [CCSprite spriteWithFile:@"background.jpg"];
                [background setPosition:ccp(size.width/2, size.height/2)];
                
                [self addChild:background];
                
                
                
                //Titre
                CCLabelTTF *titre = [CCLabelTTF labelWithString:@"RÈGLES" fontName:@"Economica-Bold" fontSize:38];
                titre.position = ccp( size.width/2, size.height/2 + 300);
                
                [self addChild:titre];
                
                id target = self;
                //objc_selector* selector = @selector(LaunchLevel:);
                int iMaxLevels = 11;
                
                NSMutableArray* allItems = [NSMutableArray arrayWithCapacity:11];
                for (int i = 1; i <= iMaxLevels; ++i)
                {
                    CCSprite* normalSprite = [CCSprite spriteWithFile:[NSString stringWithFormat:@"frame-%d.png",i]];
                    CCSprite* selectedSprite = [CCSprite spriteWithFile:[NSString stringWithFormat:@"frame-%d.png",i]];
                    CCMenuItemSprite* item =[CCMenuItemSprite itemFromNormalSprite:normalSprite selectedSprite:selectedSprite target:target selector:@selector(LaunchLevel:)];
                    [allItems addObject:item];
                }
                
                SlidingMenuGrid* menuGrid = [SlidingMenuGrid menuWithArray:allItems cols:1 rows:1 position:CGPointMake(size.width/2, size.height/2) padding:CGPointMake(90.f, 80.f) ];
                [self addChild:menuGrid ];
                
                // Bouton back
                CCMenuItemImage *button_back = [CCMenuItemImage itemWithNormalImage:@"back_btn.png" selectedImage:@"back_btn.png" target:self selector:@selector(buttonPressedBack:)];
                
                CCMenu *menu_back = [CCMenu menuWithItems:button_back, nil];
                [menu_back setPosition:ccp( size.width/2 - 472, size.height/2 + 345)];
                
                [self addChild:menu_back];
                
            }
        }
        
    }
    return self;
}

- (void) buttonPressedBack: (id) sender
{
    [[CCDirector sharedDirector] replaceScene:[HelloWorldLayer node]];
}

- (void) LaunchLevel: (id) sender
{
    //nothing
}

@end
