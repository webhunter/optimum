//
//  EndGame.m
//  optimum
//
//  Created by Jean-Louis Danielo on 19/05/13.
//  Copyright 2013 __MyCompanyName__. All rights reserved.
//

#import "EndGame.h"

#import "Map.h"
#import "Archipelago.h"


@implementation EndGame

+ (CCScene *) sceneWithParameters:(NSDictionary*)parameters
{
	// 'scene' is an autorelease object.
	CCScene *scene = [CCScene node];
    
	// 'layer' is an autorelease object.
	EndGame *layer = [EndGame nodeWithParameters:parameters];
	
	// add layer as a child to scene
	[scene addChild: layer];
    
    //	CCLOG(@"parameter : %i", parameter);
	// return the scene
	return scene;
}

+ (id) nodeWithParameters:(NSDictionary*)parameters{
    return [[self alloc] initWithParameters:parameters];
}

- (id) initWithParameters:(NSDictionary*)parameters{
    
    if( (self=[super init]) )
    {
        nbrGame = [[parameters objectForKey:@"nbrGame"] intValue];
        archipelago = [parameters objectForKey:@"universe"];
        
        NSUserDefaults *archipelagosGameSave = [NSUserDefaults standardUserDefaults];
        
        NSMutableDictionary *dict = [[NSMutableDictionary alloc] initWithDictionary:[archipelagosGameSave objectForKey:archipelago]];
        
        /******************* Calcul des points  ******************/
        
        int teamLeftPoints = 0, teamRightPoints = 0;
        
        int unitsLevelOneRight = [[parameters valueForKeyPath:@"unitTeamRight.unitsLevelOne"] intValue],
        unitsLevelTwoRight = [[parameters valueForKeyPath:@"unitTeamRight.unitsLevelTwo"] intValue],
        unitsLevelThreeRight = [[parameters valueForKeyPath:@"unitTeamRight.unitsLevelThree"] intValue],
        unitsLevelFourRight = [[parameters valueForKeyPath:@"unitTeamRight.unitsLevelFour"] intValue],
        unitsLevelFiveRight = [[parameters valueForKeyPath:@"unitTeamRight.unitsLevelFive"] intValue];
        int unitsRight = [[parameters valueForKeyPath:@"unitTeamRight.units"] intValue];
        
        int unitsLevelOneLeft = [[parameters valueForKeyPath:@"unitTeamLeft.unitsLevelOne"] intValue],
        unitsLevelTwoLeft = [[parameters valueForKeyPath:@"unitTeamLeft.unitsLevelTwo"] intValue],
        unitsLevelThreeLeft = [[parameters valueForKeyPath:@"unitTeamLeft.unitsLevelThree"] intValue],
        unitsLevelFourLeft = [[parameters valueForKeyPath:@"unitTeamLeft.unitsLevelFour"] intValue],
        unitsLevelFiveLeft = [[parameters valueForKeyPath:@"unitTeamLeft.unitsLevelFive"] intValue];
        int unitsLeft = [[parameters valueForKeyPath:@"unitTeamLeft.unitsLevelOne"] intValue];
        
        teamLeftPoints = (unitsLevelOneLeft * 1) + (unitsLevelTwoLeft * 2) + (unitsLevelThreeLeft * 3) + (unitsLevelFourLeft * 4) + (unitsLevelFiveLeft * 5);
        teamRightPoints = (unitsLevelOneRight * 1) + (unitsLevelTwoRight * 2) + (unitsLevelThreeRight * 3) + (unitsLevelFourRight * 4) + (unitsLevelFiveRight * 5);
        
        
        NSString *winnerName = @"nil";
        // La nature gagne
        if (teamRightPoints > teamLeftPoints) {
            winnerName = [dict objectForKey:@"evenTeam"];
        }else if (teamRightPoints < teamLeftPoints){
            winnerName = [dict objectForKey:@"oddTeam"];
        }
        
        switch (nbrGame) {
            case 1:
                [dict setObject:winnerName forKey:@"winnerOne"];
                break;
            case 2:
                [dict setObject:winnerName forKey:@"winnerTwo"];
                break;
            case 3:
                [dict setObject:winnerName forKey:@"winnerThree"];
                break;
                
            default:
                break;
        }
        
        //  On indique que l'on avance d'une île
        // Toutefois ceci ne peut se faire que si et seulement si
        // il y a un vainqueur
        if (![winnerName isEqualToString:@"nil"])
        {
            nbrGame++;
        }
        
        [dict setObject:[NSNumber numberWithInt:nbrGame] forKey:@"nbrGame"];
        
        // On met à jour les données concernant l'archipel (nombre de parties jouées, les vainqueurs)
        [archipelagosGameSave setObject:dict forKey:archipelago];
        [archipelagosGameSave synchronize];
        
  
        CGSize size = [[CCDirector sharedDirector] winSize];
        
        CCMenuItemFont *buttonOne = [CCMenuItemFont itemWithString:@"Manche suivante"
                                                    target:self
                                                    selector:@selector(nextGame:)];
        buttonOne.color = ccRED;
        
        CCMenu *menu_back = [CCMenu menuWithItems: buttonOne, nil];
        [menu_back setPosition:ccp( size.width/2 - 450, size.height/2 + 300)];
        
        [self addChild:menu_back];
        
        CCLabelTTF *winnerNameLabel = [[CCLabelTTF alloc] initWithString:winnerName fontName:@"Helvetica" fontSize:13];
        winnerNameLabel.position = ccp(50, 120);
        [self addChild:winnerNameLabel];
        
        
    }
    
    return self;
}

- (void) nextGame: (id) sender
{
    NSUserDefaults *archipelagosGameSave = [NSUserDefaults standardUserDefaults];
    
    //On envoit toutes les données relatives à cet univers concernant les parties
    [[CCDirector sharedDirector]
     replaceScene:[CCTransitionFade transitionWithDuration:0.5f
                                                     scene:[Archipelago sceneWithParameters:[archipelagosGameSave objectForKey:archipelago] andUniverse:archipelago]
                   ]];
}



//A RAJOUTER SUR TOUTES LES SCENES
-(void) onEnter
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

@end
