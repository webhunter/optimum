//
//  HelloWorldLayer.m
//  optimum
//
//  Created by REY Morgan on 28/04/13.
//  Copyright __MyCompanyName__ 2013. All rights reserved.
//


// Import the interfaces
#import "HelloWorldLayer.h"

// Needed to obtain the Navigation Controller
#import "AppDelegate.h"

#pragma mark - HelloWorldLayer

// HelloWorldLayer implementation
@implementation HelloWorldLayer

// Helper class method that creates a Scene with the HelloWorldLayer as the only child.
+(CCScene *) scene
{
	// 'scene' is an autorelease object.
	CCScene *scene = [CCScene node];
	
	// 'layer' is an autorelease object.
	HelloWorldLayer *layer = [HelloWorldLayer node];
	
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
        NSUserDefaults *archipelagosGameSave = [NSUserDefaults standardUserDefaults];
        
            
        if(![[NSUserDefaults standardUserDefaults] boolForKey:@"firstRun"])
        {
            NSArray *tutorialKeys = [[NSArray alloc] initWithObjects:@"stage1", @"stage2", nil];
            NSArray *tutorialObjects = [[NSArray alloc] initWithObjects:
                                        [NSNumber numberWithBool:YES],
                                        [NSNumber numberWithBool:YES],
                                        nil];
            NSDictionary *tutorialDict = [[NSDictionary alloc] initWithObjects:tutorialObjects
                                                                       forKeys:tutorialKeys];
            
            //Gestion des univers classiques
            
            //Archipel Nature vs. Ville
            NSArray *cityNatureKeys = [[NSArray alloc] initWithObjects:
                                       @"nbrGame",
                                       @"winnerOne",
                                       @"winnerTwo",
                                       @"winnerThree",
                                       @"universe",
                                       @"oddTeam",
                                       @"evenTeam",
                                       nil];
            
            NSArray *cityNatureObjects = [[NSArray alloc] initWithObjects:
                                          [NSNumber numberWithInt:1],
                                          @"nil",
                                          @"nil",
                                          @"nil",
                                          @"cityNature",
                                          @"city",
                                          @"nature",
                                          nil];
            NSDictionary *cityNatureDict = [[NSDictionary alloc] initWithObjects:cityNatureObjects forKeys:cityNatureKeys];
            
            
            
            [archipelagosGameSave setObject:tutorialDict forKey:@"tutorial"];
            [archipelagosGameSave setObject:cityNatureDict forKey:@"cityNature"];
            [archipelagosGameSave synchronize];
            
            [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"firstRun"];
        }
        
        
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
                        // create and initialize a Label
                        CCLabelTTF *label = [CCLabelTTF labelWithString:@"Optimum" fontName:@"Marker Felt" fontSize:64];
                        
                        // ask director for the window size
                        CGSize size = [[CCDirector sharedDirector] winSize];
                        
                        // position the label on the center of the screen
                        label.position =  ccp( size.width /2 , size.height/2 + 100);
                        
                        // add the label as a child to this Layer
                        [self addChild: label];
                        
                        // Menu
                        CCMenuItemImage *button_play = [CCMenuItemImage itemWithNormalImage:@"button_play.png" selectedImage:@"button_play.png" target:self selector:@selector(buttonPressedPlay:)];
                        
                        CCMenuItemImage *button_tuto = [CCMenuItemImage itemWithNormalImage:@"button_tuto.png" selectedImage:@"button_tuto.png" target:self selector:@selector(buttonPressedTuto:)];
                        
                        CCMenuItemImage *button_reglages = [CCMenuItemImage itemWithNormalImage:@"button_reglages.png" selectedImage:@"button_reglages.png" target:self selector:@selector(buttonPressedReglages:)];
                        
                        CCMenuItemImage *button_credit = [CCMenuItemImage itemWithNormalImage:@"button_credit.png" selectedImage:@"button_credit.png" target:self selector:@selector(buttonPressedCredit:)];
                        
                        button_credit.scale = 0.5;
                        button_play.scale = 0.5;
                        button_reglages.scale = 0.5;
                        button_tuto.scale = 0.5;
                        
                        CCMenu *menu = [CCMenu menuWithItems:button_play, button_tuto, button_reglages, button_credit, nil];
                        [menu alignItemsHorizontallyWithPadding:-60];
                        [menu setPosition:ccp( size.width/2, size.height/2 - 60)];
                        
                        // Add the menu to the layer
                        [self addChild:menu];
                        
                    }
                    else
                    {
                        // IPHONE RETINA SCREEN
                        // create and initialize a Label
                        CCLabelTTF *label = [CCLabelTTF labelWithString:@"Optimum" fontName:@"Marker Felt" fontSize:64];
                        
                        // ask director for the window size
                        CGSize size = [[CCDirector sharedDirector] winSize];
                        
                        // position the label on the center of the screen
                        label.position =  ccp( size.width /2 , size.height/2 + 100);
                        
                        // add the label as a child to this Layer
                        [self addChild: label];
                        
                        // Menu
                        CCMenuItemImage *button_play = [CCMenuItemImage itemWithNormalImage:@"button_play.png" selectedImage:@"button_play.png" target:self selector:@selector(buttonPressedPlay:)];
                        
                        CCMenuItemImage *button_tuto = [CCMenuItemImage itemWithNormalImage:@"button_tuto.png" selectedImage:@"button_tuto.png" target:self selector:@selector(buttonPressedTuto:)];
                        
                        CCMenuItemImage *button_reglages = [CCMenuItemImage itemWithNormalImage:@"button_reglages.png" selectedImage:@"button_reglages.png" target:self selector:@selector(buttonPressedReglages:)];
                        
                        CCMenuItemImage *button_credit = [CCMenuItemImage itemWithNormalImage:@"button_credit.png" selectedImage:@"button_credit.png" target:self selector:@selector(buttonPressedCredit:)];
                        
                        button_credit.scale = 0.5;
                        button_play.scale = 0.5;
                        button_reglages.scale = 0.5;
                        button_tuto.scale = 0.5;
                        
                        CCMenu *menu = [CCMenu menuWithItems:button_play, button_tuto, button_reglages, button_credit, nil];
                        [menu alignItemsHorizontallyWithPadding:-60];
                        [menu setPosition:ccp( size.width/2, size.height/2 - 60)];
                        
                        // Add the menu to the layer
                        [self addChild:menu];
                    }
                }
            }
            else
            {
                // IPHONE SCREEN 
                // create and initialize a Label
                CCLabelTTF *label = [CCLabelTTF labelWithString:@"Optimum" fontName:@"Marker Felt" fontSize:64];
                
                // ask director for the window size
                CGSize size = [[CCDirector sharedDirector] winSize];
                
                // position the label on the center of the screen
                label.position =  ccp( size.width /2 , size.height/2 + 100);
                
                // add the label as a child to this Layer
                [self addChild: label];
                
                // Menu
                CCMenuItemImage *button_play = [CCMenuItemImage itemWithNormalImage:@"button_play.png" selectedImage:@"button_play.png" target:self selector:@selector(buttonPressedPlay:)];
                
                CCMenuItemImage *button_tuto = [CCMenuItemImage itemWithNormalImage:@"button_tuto.png" selectedImage:@"button_tuto.png" target:self selector:@selector(buttonPressedTuto:)];
                
                CCMenuItemImage *button_reglages = [CCMenuItemImage itemWithNormalImage:@"button_reglages.png" selectedImage:@"button_reglages.png" target:self selector:@selector(buttonPressedReglages:)];
                
                CCMenuItemImage *button_credit = [CCMenuItemImage itemWithNormalImage:@"button_credit.png" selectedImage:@"button_credit.png" target:self selector:@selector(buttonPressedCredit:)];
                
                button_credit.scale = 0.5/2;
                button_play.scale = 0.5/2;
                button_reglages.scale = 0.5/2;
                button_tuto.scale = 0.5/2;
                
                CCMenu *menu = [CCMenu menuWithItems:button_play, button_tuto, button_reglages, button_credit, nil];
                [menu alignItemsHorizontallyWithPadding:-60];
                [menu setPosition:ccp( size.width/2, size.height/2 - 60)];
                
                // Add the menu to the layer
                [self addChild:menu];
            }
            
            
        }
		else
        {
            CGFloat scale = [[UIScreen mainScreen] scale];
            if (scale > 1.0)
            {
                // IPAD RETINA SCREEN
                
                // create and initialize a Label
                CCLabelTTF *label = [CCLabelTTF labelWithString:@"Optimum"
                                                fontName:@"Marker Felt"
                                                fontSize:64];
                
                // ask director for the window size
                CGSize size = [[CCDirector sharedDirector] winSize];
                
                // position the label on the center of the screen
                label.position =  ccp( size.width /2 , size.height/2 + 150);
                
                // add the label as a child to this Layer
                [self addChild: label];
                
                // Menu
                CCMenuItemImage *button_play = [CCMenuItemImage itemWithNormalImage:@"button_play.png" selectedImage:@"button_play.png" target:self selector:@selector(buttonPressedPlay:)];
                
                CCMenuItemImage *button_tuto = [CCMenuItemImage itemWithNormalImage:@"button_tuto.png" selectedImage:@"button_tuto.png" target:self selector:@selector(buttonPressedTuto:)];
                
                CCMenuItemImage *button_reglages = [CCMenuItemImage itemWithNormalImage:@"button_reglages.png" selectedImage:@"button_reglages.png" target:self selector:@selector(buttonPressedReglages:)];
                
                CCMenuItemImage *button_credit = [CCMenuItemImage itemWithNormalImage:@"button_credit.png" selectedImage:@"button_credit.png" target:self selector:@selector(buttonPressedCredit:)];
                
                CCMenu *menu = [CCMenu menuWithItems:button_play, button_tuto, button_reglages, button_credit, nil];
                [menu alignItemsHorizontallyWithPadding:-100];
                [menu setPosition:ccp( size.width/2, size.height/2 - 60)];
                
                
                // Add the menu to the layer
                [self addChild:menu];
            }
            else
            {
                // IPAD SCREEN
                
                // create and initialize a Label
                CCLabelTTF *label = [CCLabelTTF labelWithString:@"Optimum" fontName:@"Marker Felt" fontSize:64];
                
                // ask director for the window size
                CGSize size = [[CCDirector sharedDirector] winSize];
                
                // position the label on the center of the screen
                label.position =  ccp( size.width /2 , size.height/2 + 150);
                
                // add the label as a child to this Layer
                [self addChild: label];
                
                // Menu
                CCMenuItemImage *button_play = [CCMenuItemImage itemWithNormalImage:@"button_play.png" selectedImage:@"button_play.png" target:self selector:@selector(buttonPressedPlay:)];
                
                CCMenuItemImage *button_tuto = [CCMenuItemImage itemWithNormalImage:@"button_tuto.png" selectedImage:@"button_tuto.png" target:self selector:@selector(buttonPressedTuto:)];
                
                CCMenuItemImage *button_reglages = [CCMenuItemImage itemWithNormalImage:@"button_reglages.png" selectedImage:@"button_reglages.png" target:self selector:@selector(buttonPressedReglages:)];
                
                CCMenuItemImage *button_credit = [CCMenuItemImage itemWithNormalImage:@"button_credit.png" selectedImage:@"button_credit.png" target:self selector:@selector(buttonPressedCredit:)];
                
                button_credit.scale = 0.5;
                button_play.scale = 0.5;
                button_reglages.scale = 0.5;
                button_tuto.scale = 0.5;
                
                CCMenu *menu = [CCMenu menuWithItems:button_play, button_tuto, button_reglages, button_credit, nil];
                [menu alignItemsHorizontallyWithPadding:-100];
                [menu setPosition:ccp( size.width/2, size.height/2 - 60)];
                
                
                // Add the menu to the layer
                [self addChild:menu];
            }
            
        }
    }
	return self;
}

// on "dealloc" you need to release all your retained objects
- (void) dealloc
{
	
}

- (void) buttonPressedPlay: (id) sender
{
    [[CCDirector sharedDirector] replaceScene:[PlayLayer scene]];
}

- (void) buttonPressedTuto: (id) sender
{
    
}

- (void) buttonPressedReglages: (id) sender
{
    
}

- (void) buttonPressedCredit: (id) sender
{
    
}

- (void)hostViewController:(HostView *)controller didEndSessionWithReason:(QuitReason)reason
{
	if (reason == QuitReasonNoNetwork)
	{
		[self showNoNetworkAlert];
	}
    
}

- (void)showNoNetworkAlert
{
	UIAlertView *alertView = [[UIAlertView alloc]
                              initWithTitle:NSLocalizedString(@"No Network", @"No network alert title")
                              message:NSLocalizedString(@"To use multiplayer, please enable Bluetooth or Wi-Fi in your device's Settings.", @"No network alert message")
                              delegate:nil
                              cancelButtonTitle:NSLocalizedString(@"OK", @"Button: OK")
                              otherButtonTitles:nil];
    
	[alertView show];
}

@end
