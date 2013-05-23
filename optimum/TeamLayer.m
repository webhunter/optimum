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


@implementation TeamLayer

@synthesize delegate = _delegate;
@synthesize game = _game;

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
                        CGSize size = [[CCDirector sharedDirector] winSize];
                        
<<<<<<< HEAD
                        UIAlertView *truc = [[UIAlertView alloc] initWithTitle:@"Titre" message:nil delegate:self cancelButtonTitle:@"ok" otherButtonTitles: nil];
                        [truc show];
                        
=======
>>>>>>> 79336757177b42f2cdbe07cc8151a89ce0d63ae5
                        CCLabelTTF *newMessage = [CCLabelTTF labelWithString:@"Enfin!!!..." fontName:@"Marker Felt" fontSize:24];
                        newMessage.position = ccp( size.width/2, size.height/2 );
                        
                        [self addChild:newMessage];
                        
                    }
                    else
                    {
                        // IPHONE RETINA SCREEN
<<<<<<< HEAD

                        UIAlertView *truc = [[UIAlertView alloc] initWithTitle:@"Titre" message:nil delegate:self cancelButtonTitle:@"ok" otherButtonTitles: nil];
                        [truc show];

=======
>>>>>>> 79336757177b42f2cdbe07cc8151a89ce0d63ae5
                        CGSize size = [[CCDirector sharedDirector] winSize];
                        
                        CCLabelTTF *newMessage = [CCLabelTTF labelWithString:@"Enfin!!!..." fontName:@"Marker Felt" fontSize:24];
                        newMessage.position = ccp( size.width/2, size.height/2 );
                        
                        [self addChild:newMessage];
<<<<<<< HEAD

=======
>>>>>>> 79336757177b42f2cdbe07cc8151a89ce0d63ae5
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
                
                // Bouton back
                CCMenuItemImage *button_back = [CCMenuItemImage itemWithNormalImage:@"button_back.png" selectedImage:@"button_back.png" target:self selector:@selector(buttonPressedBack:)];
                CCMenuItemFont *buttonOne = [CCMenuItemFont itemWithString:@"Carte" target:self selector:@selector(onNewGame:)];
                buttonOne.color = ccRED;
                
                CCMenu *menu_back = [CCMenu menuWithItems:button_back, buttonOne, nil];
                [menu_back setPosition:ccp( size.width/2 - 450, size.height/2 + 300)];
                button_back.scale = CC_CONTENT_SCALE_FACTOR();
                
                [self addChild:menu_back];
                
                [menu_back alignItemsVertically];
                [menu_back alignItemsVerticallyWithPadding:10];	// 10px of padding around each button
                [menu_back alignItemsHorizontally];
                [menu_back alignItemsHorizontallyWithPadding:20];	// 20px of padding around each button
                
                //Slider
                CCSlider *slider1 = [CCSlider sliderWithBackgroundFile: @"slide.png"
                                                             thumbFile: @"ville.png"];
                [slider1 setPosition:ccp( size.width/2, size.height/2 + 170)];
                
                [self addChild:slider1];
                
                CCSlider *slider2 = [CCSlider sliderWithBackgroundFile: @"slide.png"
                                                             thumbFile: @"nature.png"];
                [slider2 setPosition:ccp( size.width/2, size.height/2 - 170)];
                slider1.scale = CC_CONTENT_SCALE_FACTOR();
                slider2.scale = CC_CONTENT_SCALE_FACTOR();
                
                [self addChild:slider2];
            }
            else
            {
                // IPAD SCREEN
                // ask director for the window size
                CGSize size = [[CCDirector sharedDirector] winSize];
                
                // Bouton back
                CCMenuItemImage *button_back = [CCMenuItemImage itemWithNormalImage:@"button_back.png" selectedImage:@"button_back.png" target:self selector:@selector(buttonPressedBack:)];
                
                CCMenuItemFont *buttonOne = [CCMenuItemFont itemWithString:@"Carte" target:self selector:@selector(onNewGame:)];
                buttonOne.color = ccRED;
                
                CCMenu *menu_back = [CCMenu menuWithItems:button_back, buttonOne, nil];
                [menu_back setPosition:ccp( size.width/2 - 450, size.height/2 + 300)];
                
                [self addChild:menu_back];
                
                [menu_back alignItemsVertically];
                [menu_back alignItemsVerticallyWithPadding:10];	// 10px of padding around each button
                [menu_back alignItemsHorizontally];
                [menu_back alignItemsHorizontallyWithPadding:20];	// 20px of padding around each button
                
                //Slider
                CCSlider *slider1 = [CCSlider sliderWithBackgroundFile: @"slide.png"
                                         thumbFile: @"ville.png"];
                [slider1 setPosition:ccp( size.width/2, size.height/2 + 170)];
                
                [self addChild:slider1];
                
                CCSlider *slider2 = [CCSlider sliderWithBackgroundFile: @"slide.png"
                                                             thumbFile: @"nature.png"];
                [slider2 setPosition:ccp( size.width/2, size.height/2 - 170)];
                
                [self addChild:slider2];
            }
        }
    }
	return self;
}

- (void) onNewGame: (CCMenuItem  *) menuItem{
    
<<<<<<< HEAD
    //    [[CCDirector sharedDirector]
    //     replaceScene:[CCTransitionFade transitionWithDuration:0.5f
    //                                                     scene:[Map sceneWithParameters:@"string"]
    //                   ]];
    
    NSArray *keys = [[NSArray alloc] initWithObjects:@"string", @"NextScene", nil];
    NSArray *objects = [[NSArray alloc] initWithObjects:@"truc", @"Archipelago", nil];

=======
//    [[CCDirector sharedDirector]
//     replaceScene:[CCTransitionFade transitionWithDuration:0.5f
//                                                     scene:[Map sceneWithParameters:@"string"]
//                   ]];
    
    NSArray *keys = [[NSArray alloc] initWithObjects:@"string", @"NextScene", nil];
    NSArray *objects = [[NSArray alloc] initWithObjects:@"truc", @"Map", nil];
>>>>>>> 79336757177b42f2cdbe07cc8151a89ce0d63ae5
    
    NSDictionary *dict = [[NSDictionary alloc] initWithObjects:objects forKeys:keys];
    
    [[CCDirector sharedDirector]
     replaceScene:[CCTransitionFade transitionWithDuration:0.5f
<<<<<<< HEAD
                                    scene:[Tips sceneWithNextScene:dict]
=======
                                                     scene:[Tips sceneWithNextScene:dict]
>>>>>>> 79336757177b42f2cdbe07cc8151a89ce0d63ae5
                   ]];
}

-(void) onEnter
<<<<<<< HEAD
=======
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
>>>>>>> 79336757177b42f2cdbe07cc8151a89ce0d63ae5
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

