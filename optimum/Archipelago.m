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

+ (id) nodeWithParameters:(NSDictionary*)parameters andUniverse:(NSString*)universe
{
    return [[self alloc] initWithParameters:parameters andUniverse:universe];
}

- (id) initWithParameters:(NSDictionary*)parameters andUniverse:(NSString*)universe
{
    
    if( self=[super init] )
    {
        nbrGame = [[parameters objectForKey:@"nbrGame"] intValue];
        CCLOG(@"nbrGame : %@", parameters);
     
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
            CCLOG(@"winnerOne : %@", [parameters objectForKey:@"winnerOne"]);
            canPlayFirstGame = NO;
            canPlaySecondGame = NO;
            canPlayThirdGame = NO;
        }
        
        //Gestion des manches
        
        CGSize size = [[CCDirector sharedDirector] winSize];
        
        NSString *archipel1Img, *archipel2Img, *archipel3Img,
                 *winnerOne, *winnerTwo, *winnerThree;
        
        archipelago = [parameters objectForKey:@"universe"];
        winnerOne = [parameters objectForKey:@"winnerOne"];
        winnerTwo = [parameters objectForKey:@"winnerTwo"];
        winnerThree = [parameters objectForKey:@"winnerThree"];
        
        //Nous sommes dans une opposition ville contre nature
        if ([archipelago isEqualToString:@"cityNature"])
        {
            //La gagnant est l'univers de la ville
            if ([winnerOne isEqualToString:@"city"])
            {
                archipel1Img = @"archipel_1.png";
            //La gagnant est l'univers de la nature
            }else if ([winnerOne isEqualToString:@"nature"]){
                archipel1Img = @"archipel_1.png";
            }else{
                archipel1Img = @"archipel_1.png";
            }
        }else{
            
        }
        
        //Archipels
        CCMenuItemImage *archipel1 = [CCMenuItemImage itemWithNormalImage:archipel1Img
                                                      selectedImage:@"archipel_1.png"
                                                      target:self
                                                      selector:@selector(startGame:)];
        if (canPlayFirstGame == NO) {
            archipel1.isEnabled = NO;
            archipel1.opacity = 75;
        }else{
            archipel1.isEnabled = YES;
            archipel1.opacity = 255;
        }
        
        CCMenuItemImage *archipel2 = [CCMenuItemImage itemWithNormalImage:@"archipel_2.png"
                                                      selectedImage:@"archipel_2.png"
                                                      target:self
                                                      selector:@selector(startGame:)];
        
        if (canPlaySecondGame == NO) {
            archipel2.isEnabled = NO;
            archipel2.opacity = 75;
        }else{
            archipel2.isEnabled = YES;
            archipel2.opacity = 255;
        }
        
        CCMenuItemImage *archipel3 = [CCMenuItemImage itemWithNormalImage:@"archipel_3.png"
                                                      selectedImage:@"archipel_3.png"
                                                      target:self
                                                      selector:@selector(startGame:)];
        if (canPlayThirdGame == NO) {
            archipel3.isEnabled = NO;
            archipel3.opacity = 75;
        }else{
            archipel3.isEnabled = YES;
            archipel3.opacity = 255;
        }
        
        CCMenu *menuArchipel = [CCMenu menuWithItems:archipel1, archipel2, archipel3, nil];
        [menuArchipel alignItemsHorizontallyWithPadding:30];
        
        [menuArchipel setPosition:ccp( size.width/2, size.height/2 - 60)];
        
        [self addChild:menuArchipel];
        
        CCMenuItemFont *buttonOne = [CCMenuItemFont itemWithString:@"Réinitisaliser l'univers"
                                                            target:self
                                                          selector:@selector(resetArchipelago)];
        buttonOne.color = ccRED;
        
        CCMenu *menu_back = [CCMenu menuWithItems: buttonOne, nil];
        [menu_back setPosition:ccp( size.width/2 - 450, size.height/2 + 300)];
        
        [self addChild:menu_back];
    }
    
    return self;
}

- (void) resetArchipelago{
    nbrGame = 1;
    NSUserDefaults *archipelagosGameSave = [NSUserDefaults standardUserDefaults];
    NSMutableDictionary *dict = [[NSMutableDictionary alloc] initWithDictionary:[archipelagosGameSave objectForKey:archipelago]];
    [dict setObject:[NSNumber numberWithInt:nbrGame] forKey:@"nbrGame"];
    
    // On met à jour les données concernant l'archipel (nombre de parties jouées, les vainqueurs)
    [archipelagosGameSave setObject:dict forKey:archipelago];
    [archipelagosGameSave synchronize];
    [[CCDirector sharedDirector] replaceScene:[Archipelago sceneWithParameters:[archipelagosGameSave objectForKey:archipelago] andUniverse:archipelago]];
}

- (void) startGame: (id) sender
{
    
    NSUserDefaults *archipelagosGameSave = [NSUserDefaults standardUserDefaults];
    
    //On envoit toutes les données relatives à cet univers concernant les parties
    [[CCDirector sharedDirector]
     replaceScene:[CCTransitionFade transitionWithDuration:0.5f
                                    scene:[Map sceneWithParameters:[archipelagosGameSave objectForKey:archipelago]]
                   ]];
}



@end
