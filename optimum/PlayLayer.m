//
//  PlayLayer.m
//  optimum
//
//  Created by REY Morgan on 29/04/13.
//  Copyright 2013 __MyCompanyName__. All rights reserved.
//

#import "PlayLayer.h"


@implementation PlayLayer

// Helper class method that creates a Scene with the HelloWorldLayer as the only child.
+(CCScene *) scene
{
	// 'scene' is an autorelease object.
	CCScene *scene = [CCScene node];
	
	// 'layer' is an autorelease object.
	PlayLayer *layer = [PlayLayer node];
	
	// add layer as a child to scene
	[scene addChild: layer];
	
	// return the scene
	return scene;
}

// on "init" you need to initialize your instance
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
                        
                    }
                    else
                    {
                        // IPHONE RETINA SCREEN
                        
                    
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
                
                // Menu
                CCMenuItemImage *button_create = [CCMenuItemImage itemWithNormalImage:@"button_create.png" selectedImage:@"button_create.png" target:self selector:@selector(buttonPressed:)];
                
                CCMenu *menu = [CCMenu menuWithItems:button_create, nil];
                //[menu alignItemsHorizontallyWithPadding:-10];
                [menu setPosition:ccp( size.width/2, size.height/2 )];
                
                // Add the menu to the layer
                [self addChild:menu];
                
                //bouton back
                CCMenuItemImage *button_back = [CCMenuItemImage itemWithNormalImage:@"button_back.png" selectedImage:@"button_back.png" target:self selector:@selector(buttonPressedBack:)];
                
                CCMenu *menu_back = [CCMenu menuWithItems:button_back, nil];
                //[menu alignItemsHorizontallyWithPadding:-10];
                [menu_back setPosition:ccp( size.width/2 - 450, size.height/2 + 300)];
                
                // Add the menu to the layer
                [self addChild:menu_back];
            }
            else
            {
                // IPAD SCREEN
                
                // ask director for the window size
                CGSize size = [[CCDirector sharedDirector] winSize];
                
                // Menu
                CCMenuItemImage *button_create = [CCMenuItemImage itemWithNormalImage:@"button_create.png" selectedImage:@"button_create.png" target:self selector:@selector(buttonPressed:)];
                
                CCMenu *menu = [CCMenu menuWithItems:button_create, nil];
                //[menu alignItemsHorizontallyWithPadding:-10];
                [menu setPosition:ccp( size.width/2, size.height/2 )];
                
                // Add the menu to the layer
                [self addChild:menu];
                
                //bouton back
                CCMenuItemImage *button_back = [CCMenuItemImage itemWithNormalImage:@"button_back.png" selectedImage:@"button_back.png" target:self selector:@selector(buttonPressedBack:)];
                
                CCMenu *menu_back = [CCMenu menuWithItems:button_back, nil];
                //[menu alignItemsHorizontallyWithPadding:-10];
                [menu_back setPosition:ccp( size.width/2 - 450, size.height/2 + 300)];
                
                // Add the menu to the layer
                [self addChild:menu_back];
            }
            
        }
    }
	return self;
}
// on "dealloc" you need to release all your retained objects
- (void) dealloc
{
	
}

- (void) buttonPressed: (id) sender
{
    [[CCDirector sharedDirector] replaceScene:[HostLayer scene]];
}

- (void) buttonPressedBack: (id) sender
{
    [[CCDirector sharedDirector] replaceScene:[HelloWorldLayer scene]];
}

@end

