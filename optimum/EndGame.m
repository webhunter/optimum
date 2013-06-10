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
        CCSpriteFrameCache* frameEndgame = [CCSpriteFrameCache sharedSpriteFrameCache];
        [frameEndgame addSpriteFramesWithFile:@"Endgame.plist"];
        
        nbrGame = [[parameters objectForKey:@"nbrGame"] intValue];
        archipelago = [parameters objectForKey:@"universe"];
        self.game = [parameters objectForKey:@"game"];
        
        CGSize size = [[CCDirector sharedDirector] winSize];
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
        
        CCSprite *background = [CCSprite spriteWithFile:@"BG6.png"];
        background.anchorPoint = ccp(0, 0);
        background.position = ccp(0, 0);
        [self addChild:background z:-1];
        
        
        NSString *winnerName = @"nil";
        // La nature gagne
        if (teamRightPoints > teamLeftPoints) {
            winnerName = [dict objectForKey:@"evenTeam"];
        }else if (teamRightPoints < teamLeftPoints){
            winnerName = [dict objectForKey:@"oddTeam"];
        }else{
            winnerName = @"nil";
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
        
        
        //Affichage
        CCSprite *reasonToStop = [CCSprite spriteWithSpriteFrameName:@"Scores_carte_remplie.png"];
        reasonToStop.anchorPoint = ccp(0, 0);
        reasonToStop.position = [[CCDirector sharedDirector] convertToGL: ccp(349, 121)];
        [self addChild:reasonToStop];
        
        
        CCMenuItemSprite *next = [CCMenuItemSprite itemWithNormalSprite:[CCSprite spriteWithSpriteFrameName:@"manche_suivante_btn.png"]
                                                        selectedSprite:[CCSprite spriteWithSpriteFrameName:@"manche_suivante_btn.png"]
                                                        target:self
                                                        selector:@selector(nextGame:)];
        
        CCMenu *menu_next = [CCMenu menuWithItems: next, nil];
        menu_next.anchorPoint = ccp(0, 0);
        [menu_next setPosition: [[CCDirector sharedDirector] convertToGL: ccp(484, 768 - 21)]];
        [self addChild:menu_next];
        
        CCSprite *cityImg = [CCSprite spriteWithSpriteFrameName:@"Scores_ile_Ville.png"];
        cityImg.anchorPoint = ccp(0, 0);
        cityImg.position = [[CCDirector sharedDirector] convertToGL: ccp(98, 305)];
        [self addChild:cityImg];
        
        CCSprite *natureImg = [CCSprite spriteWithSpriteFrameName:@"Scores_ile_Nature.png"];
        natureImg.anchorPoint = ccp(0, 0);
        natureImg.position = [[CCDirector sharedDirector] convertToGL: ccp(741, 305)];
        [self addChild:natureImg];
        
        NSArray *arrayStats = [[NSArray alloc] initWithObjects:@"Optimum récolté", @"Unités construites", @"Unités perdues", @"Unités restantes", nil];
        for (int i = 0; i < 4; i++)
        {
            CCSprite *stat = [CCSprite spriteWithSpriteFrameName:@"Scores_champsTxt.png"];
            stat.anchorPoint = ccp(0, 0);
            [stat setPosition: [[CCDirector sharedDirector] convertToGL: ccp(355, 439 + (63 * i))]];
            
            CCLabelTTF *labelStat = [[CCLabelTTF alloc] initWithString:[arrayStats objectAtIndex:i] fontName:@"Economica" fontSize:21];
            [labelStat setAnchorPoint:ccp(.5, .5)];
            [labelStat setPosition:ccp(
                                        (stat.boundingBox.size.width - 0) / 2,
                                        (stat.boundingBox.size.height - 0) / 2
                                       )];
            [stat addChild:labelStat];
            
            [self addChild:stat];
        }
        
    }
    
    return self;
}

- (void) nextGame: (id) sender
{
    NSUserDefaults *archipelagosGameSave = [NSUserDefaults standardUserDefaults];
    
    //On envoit toutes les données relatives à cet univers concernant les parties
    [[CCDirector sharedDirector]
     replaceScene:[CCTransitionFade transitionWithDuration:0.5f
                                                     scene:[Archipelago sceneWithParameters:[archipelagosGameSave objectForKey:archipelago] andUniverse:archipelago andGameObject:self.game]
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
