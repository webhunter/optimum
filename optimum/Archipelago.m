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

+ (CCScene *) sceneWithParameters:(NSDictionary*)parameters
{
	// 'scene' is an autorelease object.
	CCScene *scene = [CCScene node];
    
	// 'layer' is an autorelease object.
	Archipelago *layer = [Archipelago nodeWithParameters:parameters];
	
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
    
    if( self=[super init] )
    {
        nbrGame = [[parameters objectForKey:@"nbrGame"] intValue];
        CCLOG(@"nbrGame : %i", nbrGame);
        // On regarde à quelle manche nous sommes
        switch ([[parameters objectForKey:@"nbrGame"] intValue])
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
                canPlayFirstGame = YES;
                canPlaySecondGame = NO;
                canPlayThirdGame = NO;
                break;
        }
        //Gestion des manches
//        canPlayFirstGame = [[parameters objectForKey:@"firstGame"] boolValue];
//        canPlaySecondGame = [[parameters objectForKey:@"secondGame"] boolValue];
//        canPlayThirdGame = [[parameters objectForKey:@"thirdGame"] boolValue];
        
        CGSize size = [[CCDirector sharedDirector] winSize];
        
        NSString *archipel1Img, *archipel2Img, *archipel3Img;
        
        if ([[parameters objectForKey:@"universe"] isEqualToString:@"ville"])
        {
            archipel1Img = @"archipel_1.png";
//            //La gagnant est l'univers de la ville
//            if ([[parameters objectForKey:@"winner"] intValue] == 0)
//            {
//                archipel1Img = @"archipel_1.png";
//            //La gagnant est l'univers de la nature
//            }else if ([[parameters objectForKey:@"winner"] intValue] == 1){
//                archipel1Img = @"archipel_1.png";
//            }else{
//                archipel1Img = @"archipel_1.png";
//            }
        }else{
            
        }
        
        //Archipels
        CCMenuItemImage *archipel1 = [CCMenuItemImage itemWithNormalImage:@"archipel_1.png"
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
    }
    
    return self;
}


- (void) startGame: (id) sender
{
    nbrGame++;
    NSArray *objects = [[NSArray alloc] initWithObjects:
                        [NSNumber numberWithInt:nbrGame],
                        nil];
    NSArray *keys = [[NSArray alloc] initWithObjects:@"nbrGame", nil];
    NSDictionary *dict = [[NSDictionary alloc] initWithObjects:objects forKeys:keys];
    
    
    [[CCDirector sharedDirector]
     replaceScene:[CCTransitionFade transitionWithDuration:0.5f
                                    scene:[Map sceneWithParameters:dict]
                   ]];
}



@end
