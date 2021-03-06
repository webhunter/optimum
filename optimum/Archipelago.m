//
//  Archipelago.m
//  optimum
//
//  Created by Jean-Louis Danielo on 19/05/13.
//  Copyright 2013 __MyCompanyName__. All rights reserved.
//

#import "Archipelago.h"

#import "Map.h"



@implementation Archipelago

@synthesize game = _game;

+ (CCScene *) sceneWithParameters:(NSDictionary*)parameters andUniverse:(NSString*)universe
{
	// 'scene' is an autorelease object.
	CCScene *scene = [CCScene node];
    
	// 'layer' is an autorelease object.
	Archipelago *layer = [Archipelago nodeWithParameters:parameters andUniverse:universe];
	
	// add layer as a child to scene
	[scene addChild: layer];
    
    //	CCLOG(@"parameter : %i", parameter);
	// return the scene
	return scene;
}

+ (CCScene *) scene
{
    // 'scene' is an autorelease object.
	CCScene *scene = [CCScene node];
    
	// 'layer' is an autorelease object.
	Archipelago *layer = [Archipelago node];
	
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
	Archipelago *layer = [Archipelago nodeWithGameObject:gameObject];
	
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
                        CCSprite *background = [CCSprite spriteWithFile:@"manches_dujeu_iPhone5.png"];
                        [background setPosition:ccp(size.width/2, size.height/2)];
                        
                        [self addChild:background];
                        
                    }
                    else
                    {
                        // IPHONE RETINA SCREEN
                        // ask director for the window size
                        CGSize size = [[CCDirector sharedDirector] winSize];
                        
                        // BackGround
                        CCSprite *background = [CCSprite spriteWithFile:@"manches_dujeu.png"];
                        [background setPosition:ccp(size.width/2, size.height/2)];
                        
                        [self addChild:background];
                        
                    }
                }
            }
        }
    }
    return self;
}

+ (id) nodeWithParameters:(NSDictionary*)parameters andUniverse:(NSString*)universe
{
    return [[self alloc] initWithParameters:parameters andUniverse:universe];
}

+ (CCScene *) sceneWithParameters:(NSDictionary*)parameters andUniverse:(NSString*)universe andGameObject:(Game*)gameObject
{
	// 'scene' is an autorelease object.
	CCScene *scene = [CCScene node];
    
	// 'layer' is an autorelease object.
	Archipelago *layer = [Archipelago nodeWithParameters:parameters andUniverse:universe andGameObject:gameObject];
	
	// add layer as a child to scene
	[scene addChild: layer];
    
    //	CCLOG(@"parameter : %i", parameter);
	// return the scene
	return scene;
}

+ (id) nodeWithParameters:(NSDictionary*)parameters andUniverse:(NSString*)universe andGameObject:(Game*)gameObject
{
    return [[self alloc] initWithParameters:parameters andUniverse:universe andGameObject:(Game*)gameObject];
}



- (id) initWithParameters:(NSDictionary*)parameters andUniverse:(NSString*)universe andGameObject:(Game*)gameObject
{
    
    if( self=[super init] )
    {
        CGSize size = [[CCDirector sharedDirector] winSize];
        nbrGame = [[parameters objectForKey:@"nbrGame"] intValue];
        self.game = gameObject;
        
        if( UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad )
        {
            CGFloat scale = [[UIScreen mainScreen] scale];
            if (scale > 1.0)
            {
                CCSprite *background = [CCSprite spriteWithFile:@"background-hd.jpg"];
                [background setPosition:ccp(size.width/2, size.height/2)];
                
                [self addChild:background];
                
                // Bouton back
                CCMenuItemImage *button_back = [CCMenuItemImage itemWithNormalImage:@"back_btn-hd.png" selectedImage:@"back_btn.png" target:self selector:@selector(buttonPressedBack:)];
                
                CCMenu *menu_back = [CCMenu menuWithItems:button_back, nil];
                [menu_back setPosition:ccp( size.width/2 - 472, size.height/2 + 345)];
                
                [self addChild:menu_back];
  
            }
            else
            {
                CCSprite *background = [CCSprite spriteWithFile:@"background.jpg"];
                [background setPosition:ccp(size.width/2, size.height/2)];
                
                [self addChild:background];
                
                // Bouton back
                CCMenuItemImage *button_back = [CCMenuItemImage itemWithNormalImage:@"back_btn.png" selectedImage:@"back_btn.png" target:self selector:@selector(buttonPressedBack:)];
                
                CCMenu *menu_back = [CCMenu menuWithItems:button_back, nil];
                [menu_back setPosition:ccp( size.width/2 - 472, size.height/2 + 345)];
                
                [self addChild:menu_back];
            }
        }
        
        CCLabelTTF *titre = [CCLabelTTF labelWithString:@"SÉLECTION DE LA MANCHE" fontName:@"Economica-Bold" fontSize:38];
        titre.position = ccp( size.width/2, size.height/2 + 300);
        
        [self addChild:titre];
        
        // On regarde à quelle manche nous sommes
        switch (nbrGame)
        {
            case 1:
                canPlayFirstGame = YES;
                canPlaySecondGame = NO;
                canPlayThirdGame = NO;
                break;
                
            case 2:
                canPlayFirstGame = NO;
                canPlaySecondGame = YES;
                canPlayThirdGame = NO;
                break;
                
            case 3:
                canPlayFirstGame = NO;
                canPlaySecondGame = NO;
                canPlayThirdGame = YES;
                break;
                
            default:
                canPlayFirstGame = NO;
                canPlaySecondGame = NO;
                canPlayThirdGame = NO;
                break;
        }
        
        //On gère la troisième manche | Si les deux manches n'ont pas le même nom de vainqueur
        if ([[parameters valueForKeyPath:@"winnerOne"] isEqualToString:[parameters valueForKeyPath:@"winnerTwo"]] && ![[parameters valueForKeyPath:@"winnerOne"] isEqualToString:@"nil"] && nbrGame == 3)
        {
            canPlayFirstGame = NO;
            canPlaySecondGame = NO;
            canPlayThirdGame = NO;
        }
        
        //Gestion des manches
        
        //CGSize size = [[CCDirector sharedDirector] winSize];
        
        NSString *island1Img, *island2Img, *island3Img,
                 *winnerOne, *winnerTwo, *winnerThree, *winner;
        
        archipelago = [parameters objectForKey:@"universe"];
        winnerOne = [parameters objectForKey:@"winnerOne"];
        winnerTwo = [parameters objectForKey:@"winnerTwo"];
        winnerThree = [parameters objectForKey:@"winnerThree"];
        
        NSArray *winners = [[NSArray alloc] initWithObjects:winnerOne, winnerTwo, winnerThree, nil];
        
        CCLOG(@"winners : %@", winners);
        
        //Nous sommes dans une opposition ville contre nature
        if ([archipelago isEqualToString:@"cityNature"])
        {
            //La gagnant est l'univers de la ville
            if ([winnerOne isEqualToString:@"city"])
            {
                island1Img = [parameters objectForKey:@"cityIsland"];
            //La gagnant est l'univers de la nature

            }else if ([winnerOne isEqualToString:@"nature"]){
                island1Img = [parameters objectForKey:@"natureIsland"];
            }else{
                if( UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad )
                {
                    CGFloat scale = [[UIScreen mainScreen] scale];
                    if (scale > 1.0)
                    {
                        island1Img = @"Manche_01-hd.png";
                    }
                    else
                    {
                        island1Img = @"Manche_01.png";
                    }
                }
            }
            
            //La gagnant est l'univers de la ville
            if ([winnerTwo isEqualToString:@"city"])
            {
                island2Img = [parameters objectForKey:@"cityIsland"];
                //La gagnant est l'univers de la nature
            }else if ([winnerOne isEqualToString:@"nature"]){
                CCLOG(@"truc2");
                island2Img = [parameters objectForKey:@"natureIsland"];
            }else{
                if( UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad )
                {
                    CGFloat scale = [[UIScreen mainScreen] scale];
                    if (scale > 1.0)
                    {
                        island2Img = @"Manche_02-hd.png";
                    }
                    else
                    {
                        island2Img = @"Manche_02.png";
                    }
                }
            }
            
            //La gagnant est l'univers de la ville
            if ([winnerThree isEqualToString:@"city"])
            {
                island3Img = [parameters objectForKey:@"cityIsland"];
                //La gagnant est l'univers de la nature
            }else if ([winnerOne isEqualToString:@"nature"]){
                island3Img = [parameters objectForKey:@"natureIsland"];
            }else{
                if( UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad )
                {
                    CGFloat scale = [[UIScreen mainScreen] scale];
                    if (scale > 1.0)
                    {
                        island3Img = @"Manche_03-hd.png";
                    }
                    else
                    {
                        island3Img = @"Manche_03.png";
                    }
                }
                
            }
        }else{
            
        }

        
        //Archipels

        CCMenuItemImage *archipel1 = [CCMenuItemImage itemWithNormalImage:island1Img
                                                      selectedImage:island1Img
                                                      target:self
                                                      selector:@selector(startGame:)];
        if (canPlayFirstGame == NO) {
            archipel1.isEnabled = NO;
            archipel1.opacity = 75;
        }else{
            archipel1.isEnabled = YES;
            archipel1.opacity = 255;
        }
        
        CCMenuItemImage *archipel2 = [CCMenuItemImage itemWithNormalImage:island2Img
                                                      selectedImage:island2Img
                                                      target:self
                                                      selector:@selector(startGame:)];
        
        if (canPlaySecondGame == NO) {
            archipel2.isEnabled = NO;
            archipel2.opacity = 75;
        }else{
            archipel2.isEnabled = YES;
            archipel2.opacity = 255;
        }
        
        CCMenuItemImage *archipel3 = [CCMenuItemImage itemWithNormalImage:island3Img
                                                      selectedImage:island3Img
                                                      target:self
                                                      selector:@selector(startGame:)];

        if (canPlayThirdGame == NO) {
            archipel3.isEnabled = NO;
            archipel3.opacity = 75;
        }else{
            archipel3.isEnabled = YES;
            archipel3.opacity = 255;
        }
        
        CCMenu *menuArchipel = [CCMenu menuWithItems:archipel1, archipel3, nil];
        [menuArchipel alignItemsHorizontallyWithPadding:200];
        
        [menuArchipel setPosition:ccp( size.width/2, size.height/2)];
        
        [self addChild:menuArchipel];
        
        CCMenu *menuArchipel2 = [CCMenu menuWithItems:archipel2, nil];
        
        [menuArchipel2 setPosition:ccp( size.width/2, size.height/2 - 100)];
        
        [self addChild:menuArchipel2];
        
        int occurrences = 0;
        
        for(NSString *string in winners)
        {
            occurrences += ([string isEqualToString:[parameters objectForKey:@"oddTeam"]] ? 1 : 0);
            if (occurrences == 2) {
                winner = [parameters objectForKey:@"oddTeam"];
            }
        }
        
        if (occurrences <= 1)
        {
            occurrences = 0;
            for(NSString *string in winners)
            {
                occurrences += ([string isEqualToString:[parameters objectForKey:@"evenTeam"]] ? 1 : 0);
                if (occurrences == 2)
                {
                    winner = [parameters objectForKey:@"evenTeam"];
                }
            }
        }
        
        // Désignation du vainqueur de la partie
        if ( occurrences == 2 )
        {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Le vainqueur est..." message:winner delegate:self cancelButtonTitle:@"ok" otherButtonTitles: nil];
            [alert show];
            
        }
        
        CCMenuItemFont *buttonOne = [CCMenuItemFont itemWithString:@"Réinitialiser archipel"
                                                            target:self
                                                          selector:@selector(resetArchipelago:)];
        buttonOne.color = ccRED;
        
        CCMenu *menu_back = [CCMenu menuWithItems: buttonOne, nil];
        [menu_back setPosition:ccp( size.width/2 - 450, size.height/2 + 300)];

        [self addChild:menu_back];
    }
    
    return self;
}

- (void) resetArchipelago: (id) sender
{
    NSUserDefaults *archipelagosGameSave = [NSUserDefaults standardUserDefaults];
    nbrGame = 1;
    
    NSMutableDictionary *dict = [[NSMutableDictionary alloc] initWithDictionary:[archipelagosGameSave objectForKey:archipelago]];
    [dict setObject:[NSNumber numberWithInt:nbrGame] forKey:@"nbrGame"];
    [dict setObject:@"nil" forKey:@"winnerOne"];
    [dict setObject:@"nil" forKey:@"winnerTwo"];
    [dict setObject:@"nil" forKey:@"winnerThree"];
    
    [archipelagosGameSave setObject:dict forKey:archipelago];
    [archipelagosGameSave synchronize];
    //On envoit toutes les données relatives à cet univers concernant les parties
    [[CCDirector sharedDirector]
     replaceScene:[Archipelago sceneWithParameters:[archipelagosGameSave objectForKey:archipelago] andUniverse:archipelago andGameObject:self.game]];
}

- (void) startGame: (id) sender
{
    // envoie données au joueur 1
    Packet *packet = [Packet packetWithType:PacketTypeMapGameStart];
    Player *player = [self.game playerAtPosition:PlayerPositionLeft];
    NSArray *array = [[NSArray alloc] initWithObjects:player.peerID, nil];
	[self.game sendPacketToOneClient:packet andClient:array];
    
    // envoie données au joueur 2
    Packet *packet2 = [Packet packetWithType:PacketTypeMapGameStart2];
    Player *player2 = [self.game playerAtPosition:PlayerPositionRight];
    NSArray *array2 = [[NSArray alloc] initWithObjects:player2.peerID, nil];
	[self.game sendPacketToOneClient:packet2 andClient:array2];
    
    
    NSUserDefaults *archipelagosGameSave = [NSUserDefaults standardUserDefaults];
    
    NSDictionary *parametersToNextScene = [[NSDictionary alloc]
                                                initWithObjectsAndKeys:
                                                    [archipelagosGameSave objectForKey:archipelago], @"save",
                                                    self.game, @"game",
                                           nil];
    
    //On envoit toutes les données relatives à cet univers concernant les parties
    [[CCDirector sharedDirector]
     replaceScene:[CCTransitionFade transitionWithDuration:0.5f
                                                     scene:[Map sceneWithParameters:parametersToNextScene]
                   ]];
}

- (void) buttonPressedBack: (id) sender
{
    // envoie données au joueurs
    [[CCDirector sharedDirector] replaceScene:[TeamLayer sceneWithGameObject:self.game]];
    //test
}

@end
