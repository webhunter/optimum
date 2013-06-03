//
//  Map.m
//  Optimum-maquette
//
//  Created by Jean-Louis Danielo on 25/04/13.
//  Copyright 2013 __MyCompanyName__. All rights reserved.
//

#import "Map.h"


#import "TeamLayer.h"
#import "EndGame.h" //Scene appelée lorsque la scene est terminée


@implementation Map

// Helper class method that creates a Scene with the HelloWorldLayer as the only child.
+ (CCScene *) scene
{
	// 'scene' is an autorelease object.
	CCScene *scene = [CCScene node];
	
	// 'layer' is an autorelease object.
	Map *layer = [Map node];
	
	// add layer as a child to scene
	[scene addChild: layer];
	
	// return the scene
	return scene;
}

+ (CCScene *) sceneWithParameters:(NSDictionary*)parameters
{
	// 'scene' is an autorelease object.
	CCScene *scene = [CCScene node];
    
	// 'layer' is an autorelease object.
	Map *layer = [Map nodeWithParameters:parameters];
	
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
        size = [[CCDirector sharedDirector] winSize];
        self.game = [parameters objectForKey:@"game"];
        CCLOG(@"gamegamegame : %@", self.game);

        CCSpriteFrameCache* frameCache = [CCSpriteFrameCache sharedSpriteFrameCache];
        [frameCache addSpriteFramesWithFile:@"sprites-interface.plist"];
        
        timeElapse = 0;

        nbrGame = [[parameters valueForKeyPath:@"save.nbrGame"] intValue];
        
        CCSprite *background = [CCSprite spriteWithFile:@"BG6.png"];
        background.anchorPoint = ccp(0, 0);
        background.position = ccp(0, 0);
        [self addChild:background z:-1];
        
        //Notifications
        //Gestion du lâcher d'optimum
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(optimumRelease:)
                                                     name:@"optimumPosition"
                                                   object:nil];
        //Gestion du lâcher d'unité
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(unitRelease:)
                                                     name:@"unitPositionEnd"
                                                   object:nil];
        //Gestion du déplacement d'unité
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(unitMove:)
                                                     name:@"unitPositionMove"
                                                   object:nil];
		self.isTouchEnabled = YES;
        
        archipelago = [[parameters objectForKey:@"save"] objectForKey:@"universe"];
        NSString *mapType = @"";
        
        if ([archipelago isEqualToString:@"cityNature"])
        {
            mapType = @"maquette-map-2.tmx";
        }else{
            mapType = @"maquette-map-2.tmx";
        }
        
        Mapquake *map = [[Mapquake alloc] initWithTMXFile:mapType];
        
        //Permet de compenser le bug lié à la présence d'une tuile sur la case (0, 0)
        CCTMXLayer *tilesLayer = [map layerNamed:@"Tiles"];
        [tilesLayer removeTileAt:ccp(0, 0)];
        
        [self centerIntoScreen:map];
        [self addChild:map z:-1 tag:TileMapTag];
        
        //Stack d'élements gauche et droite
        leftStack = [CCSprite spriteWithSpriteFrameName:@"zone-ville.png"];
        leftStack.anchorPoint = ccp(0, 1);
        leftStack.position = ccp(0, size.height);
        
        [self addChild:leftStack];
        
        rightStack = [CCSprite spriteWithSpriteFrameName:@"zone-nature.png"];
        rightStack.anchorPoint = ccp(0, 1);
        rightStack.position = ccp(size.width - rightStack.boundingBox.size.width, size.height);
        [self addChild:rightStack];
        
        NSDate *methodStart = [NSDate date];
        
        NSDate *methodFinish = [NSDate date];
        NSTimeInterval executionTime = [methodFinish timeIntervalSinceDate:methodStart];
        CCLOG(@"%f", executionTime);
        
        stackElementLeft = [[NSMutableArray alloc] init];
        stackElementRight = [[NSMutableArray alloc] init];
        
        [self displayInterface];
        
        CCParticleMeteor *emitter2 = [[CCParticleMeteor alloc] initWithTotalParticles:150];
        
        emitter2.texture = [[CCTextureCache sharedTextureCache] addImage:@"ice-pattern.png"];
        emitter2.position = ccp(123, 345);
        emitter2.life = 0.5;
        emitter2.duration = 2;
        
        emitter2.speed = 60;
        
        id emitMove = [CCMoveTo actionWithDuration:1.5 position:ccp(223, 345)];
        
        
        //        [self addChild:emitter2 z:1];
        
        [emitter2 runAction:[CCSequence actions:emitMove, nil]];
        emitter2.autoRemoveOnFinish = YES;
        
        //Hitbox
        
        CCMenuItemFont *buttonPause = [CCMenuItemFont itemWithString:@"Pause" target:self selector:@selector(pauseGame:)];
        buttonPause.color = ccORANGE;
        buttonPause.tag = 4;
        
        
        CCMenu *menu_next = [CCMenu menuWithItems:buttonPause, nil];
        [menu_next setPosition:ccp( size.width/2, size.height/2 - 300)];
        
        [self addChild:menu_next];
        
//         [[CCDirector sharedDirector] pause];
        
        
        [self schedule: @selector(tilesAttacks:) interval:1];
        
        //Récupère le nombre d'unité détruites pour chaque clan
        unitLeftDestroyed = 0, unitRightDestroyed = 0;
        
        // Le jeu n'est pas en pause par défaut
        gameIsPause = NO;
    }
    
    return self;
}

// Permet de mettre le jeu en pause
- (void) pauseGame: (CCMenuItem  *) menuItem
{
    CCNode* node = [self getChildByTag:4];
    CCMenuItemFont* label = (CCMenuItemFont*)node;
    
    if (gameIsPause == NO) {
        [[CCDirector sharedDirector] pause];
        gameIsPause = YES;
        [self gameIsPaused: NO];
        [label setString:@"Reprendre"];
    }else{
        [[CCDirector sharedDirector] resume];
        gameIsPause = NO;
        [self gameIsPaused: YES];
        [label setString:@"Pause"];
    }
}

- (void) gameIsPaused:(BOOL)gameState
{
    // Désactive le déplacement d'unités
    for (UnitSprite *sprite in self.children)
    {
        if ([sprite isKindOfClass:[UnitSprite class]])
        {
            sprite.touchEnabled = gameState;
        }
    }
    
    // Désactive le déplacement de ressources
    for (OptimumRessource *ressource in self.children)
    {
        if ([ressource isKindOfClass:[OptimumRessource class]])
        {
            ressource.touchEnabled = gameState;
        }
    }
    
}

- (void) centerIntoScreen:(CCNode*) element
{
    CGSize winSize = [[CCDirector sharedDirector] winSize];
    CGSize elementSize = [element boundingBox].size;
    
    float x = ((winSize.width - elementSize.width) / 2);
    float y = ((winSize.height - elementSize.height) / 2);
    
    CGPoint centerPoint = ccp(x, y);
    [element setPosition:centerPoint];
}

- (void) generateOptimum: (ccTime) dt
{
    for (int i = 0; i <= 1; i++) {
        [self addOptimum];
    }
    
    countdown--;
    NSString *string = @"Is not an invalid string";
    [countdownLabel setString:[string timeFormatted:countdown]];
    
    if (countdown <= 0)
    {
        [self endGame];
        [self unschedule:@selector(generateOptimum:)];
    }
}

#pragma mark - end Game

- (void) endGame
{
    CCNode* node = [self getChildByTag:TileMapTag];
    NSAssert([node isKindOfClass:[CCTMXTiledMap class]], @"not a CCTMXTiledMap");
    CCTMXTiledMap* tileMap = (CCTMXTiledMap*)node;
    
    CCTMXLayer *layer = [tileMap layerNamed:@"Tiles"];
    
    NSMutableDictionary *unitTeamLeft = [[NSMutableDictionary alloc] init];
    NSMutableDictionary *unitTeamRight = [[NSMutableDictionary alloc] init];
    
    int unitsLevelOneRight = 0, unitsLevelTwoRight = 0, unitsLevelThreeRight = 0;
    int unitsLevelFourRight = 0, unitsLevelFiveRight = 0;
    int unitsRight = 0;
    
    int unitsLevelOneLeft = 0, unitsLevelTwoLeft = 0, unitsLevelThreeLeft = 0;
    int unitsLevelFourLeft = 0, unitsLevelFiveLeft = 0;
    int unitsLeft = 0;
    
    for (NSUInteger y = 0; y < layer.layerSize.height; y++)
    {
        for (NSUInteger x = 0; x < layer.layerSize.width; x++)
        {
            if (
                [layer tileGIDAt:ccp(x, y)] != 33 ||
                [layer tileGIDAt:ccp(x, y)] != 0
                )
            {
                //Team de droite
                if ([layer tileAt: ccp(x, y)].team == YES)
                {
                    switch ([layer tileAt: ccp(x, y)].type)
                    {
                        case 1:
                            unitsLevelOneRight++;
                            break;
                        case 2:
                            unitsLevelTwoRight++;
                            break;
                        case 3:
                            unitsLevelThreeRight++;
                            break;
                        case 4:
                            unitsLevelFourRight++;
                            break;
                        case 5:
                            unitsLevelFiveRight++;
                            break;
                        default:
                            break;
                    }
                }else{
                    switch ([layer tileAt: ccp(x, y)].type)
                    {
                        case 1:
                            unitsLevelOneLeft++;
                            break;
                        case 2:
                            unitsLevelTwoLeft++;
                            break;
                        case 3:
                            unitsLevelThreeLeft++;
                            break;
                        case 4:
                            unitsLevelFourLeft++;
                            break;
                        case 5:
                            unitsLevelFiveLeft++;
                            break;
                        default:
                            break;
                    }
                }
            }
        }
    }
    
    unitsLeft = unitsLevelOneLeft + unitsLevelTwoLeft + unitsLevelThreeLeft + unitsLevelFourLeft + unitsLevelFiveLeft;
    unitsRight = unitsLevelOneRight + unitsLevelTwoRight + unitsLevelThreeRight + unitsLevelFourRight + unitsLevelFiveRight;
    
    [unitTeamLeft setObject:[NSNumber numberWithInt:unitsLevelOneLeft] forKey:@"unitsLevelOne"];
    [unitTeamLeft setObject:[NSNumber numberWithInt:unitsLevelTwoLeft] forKey:@"unitsLevelTwo"];
    [unitTeamLeft setObject:[NSNumber numberWithInt:unitsLevelThreeLeft] forKey:@"unitsLevelThree"];
    [unitTeamLeft setObject:[NSNumber numberWithInt:unitsLevelFourLeft] forKey:@"unitsLevelFour"];
    [unitTeamLeft setObject:[NSNumber numberWithInt:unitsLevelFiveLeft] forKey:@"unitsLevelFive"];
    [unitTeamLeft setObject:[NSNumber numberWithInt:unitsLeft] forKey:@"units"];
    
    [unitTeamRight setObject:[NSNumber numberWithInt:unitsLevelOneRight] forKey:@"unitsLevelOne"];
    [unitTeamRight setObject:[NSNumber numberWithInt:unitsLevelTwoRight] forKey:@"unitsLevelTwo"];
    [unitTeamRight setObject:[NSNumber numberWithInt:unitsLevelThreeRight] forKey:@"unitsLevelThree"];
    [unitTeamRight setObject:[NSNumber numberWithInt:unitsLevelFourRight] forKey:@"unitsLevelFour"];
    [unitTeamRight setObject:[NSNumber numberWithInt:unitsLevelFiveRight] forKey:@"unitsLevelFive"];
    [unitTeamRight setObject:[NSNumber numberWithInt:unitsRight] forKey:@"units"];
    
    
    NSArray *objects = [NSArray arrayWithObjects:unitTeamLeft, unitTeamRight, archipelago, [NSNumber numberWithInt:nbrGame], self.game, nil];
    NSArray *keys = [NSArray arrayWithObjects:@"unitTeamLeft", @"unitTeamRight", @"universe", @"nbrGame", @"game", nil];
    
    
    NSDictionary *stats = [NSDictionary dictionaryWithObjects:objects forKeys:keys];
    
    [[CCDirector sharedDirector] replaceScene:[CCTransitionFade transitionWithDuration:1.0
                                                                                 scene:[EndGame sceneWithParameters:stats]
                                                                             withColor:ccGREEN]];
}

- (void) displayInterface{
    
    level1UnitLeft = 42;
    level2UnitLeft = 7;
    level3UnitLeft = 7;
    level4UnitLeft = 0;
    level5UnitLeft = 7;
    //Affichage des unités
    //  Unité gauche (Ville)
    UnitSprite *unitLeftLevelOne = [[UnitSprite alloc] initWithUnitType:0 atPosition:ccp(51, size.height - 40 * 2) withUnits:level1UnitLeft];
    [self addChild:unitLeftLevelOne z:unitOddLevelOne];
    
    UnitSprite *unitLeftLevelTwo = [[UnitSprite alloc] initWithUnitType:2
                                                      atPosition:ccp(51, size.height - (40 * 5)) withUnits:level2UnitLeft];
    [self addChild:unitLeftLevelTwo z:unitOddLevelTwo];
    
    UnitSprite *unitLeftLevelThree = [[UnitSprite alloc] initWithUnitType:4
                                                             atPosition:ccp(51, size.height - (40 * 8)) withUnits:level3UnitLeft];
    [self addChild:unitLeftLevelThree z:unitOddLevelThree];
    
    UnitSprite *unitLeftLevelFour = [[UnitSprite alloc] initWithUnitType:6
                                                               atPosition:ccp(51, size.height - (40 * 11)) withUnits:level4UnitLeft];
    [self addChild:unitLeftLevelFour z:unitOddLevelFour];
    
    UnitSprite *unitLeftLevelFive = [[UnitSprite alloc] initWithUnitType:8
                                                              atPosition:ccp(51, size.height - (40 * 14)) withUnits:level5UnitLeft];
    [self addChild:unitLeftLevelFive z:unitOddLevelFive];
    
    
    level1UnitRight = 1;
    level2UnitRight = 7;
    level3UnitRight = 7;
    level4UnitRight = 7;
    level5UnitRight = 70;
    //  Unité droite (Nature)
    UnitSprite *unitRightLevelOne = [[UnitSprite alloc] initWithUnitType:1 atPosition:ccp(size.width - 51, size.height - 40 * 2) withUnits:level1UnitRight];
    [self addChild:unitRightLevelOne z:unitEvenLevelOne];

    
    UnitSprite *unitRightLevelTwo = [[UnitSprite alloc] initWithUnitType:3 atPosition:ccp(size.width - 51, size.height - 40 * 5) withUnits:level2UnitRight];
    [self addChild:unitRightLevelTwo z:unitEvenLevelTwo];
  
    
    UnitSprite *unitRightLevelThree = [[UnitSprite alloc] initWithUnitType:5 atPosition:ccp(size.width - 51, size.height - 40 * 8) withUnits:level3UnitRight];
    [self addChild:unitRightLevelThree z:unitEvenLevelThree];
    
    UnitSprite *unitRightLevelFour = [[UnitSprite alloc] initWithUnitType:7 atPosition:ccp(size.width - 51, size.height - 40 * 11) withUnits:level4UnitRight];
    [self addChild:unitRightLevelFour z:unitEvenLevelFour];
    
    UnitSprite *unitRightLevelFive = [[UnitSprite alloc] initWithUnitType:9 atPosition:ccp(size.width - 51, size.height - 40 * 14) withUnits:level5UnitRight];
    [self addChild:unitRightLevelFive z:unitEvenLevelFive];

    float fontSize = 18;

    //Affichage des scores
    scoreLabelLeft = [[CCLabelTTF alloc] initWithString:@"0"
                                             dimensions:CGSizeMake(120, 120)
                                             hAlignment:kCCTextAlignmentLeft
                                               fontName:@"HelveticaNeue-Bold"
                                               fontSize:fontSize];
    scoreLabelLeft.position = ccp(150, 130);
    scoreLabelLeft.color = ccc3(209, 185, 218);
    [self addChild:scoreLabelLeft z: 6000];
    
    
    scoreLabelRight = [[CCLabelTTF alloc] initWithString:@"0"
                                              dimensions:CGSizeMake(120, 120)
                                              hAlignment:kCCTextAlignmentLeft
                                                fontName:@"HelveticaNeue-Bold"
                                                fontSize:fontSize];
    scoreLabelRight.position = ccp(957, 130);
    scoreLabelRight.color = ccc3(197, 229, 232);
    [self addChild:scoreLabelRight z: 6000];
    
    rightStackBar = [self createSpriteRectangleWithSize:CGSizeMake(85, 32)];
    rightStackBar.color = ccc3(197, 229, 232);
    rightStackBar.anchorPoint = ccp(0, .5);
    rightStackBar.position = ccp(512, 700);
    rightStackBar.scaleX = 0.1;
    [self addChild:rightStackBar];
    
    leftStackBar = [self createSpriteRectangleWithSize:CGSizeMake(85, 32)];
    leftStackBar.color = ccc3(209, 185, 218);
    leftStackBar.anchorPoint = ccp(1, .5);
    leftStackBar.position = ccp(512, 700);
    leftStackBar.scaleX = 0.1;
    [self addChild:leftStackBar];
    
    //Affichage du temps imparti
    countdown = 60 * 4;
    NSString *string = @"string";
    countdownLabel = [[CCLabelTTF alloc] initWithString:[string timeFormatted:countdown]
                                             dimensions:CGSizeMake(150, 130)
                                             hAlignment:kCCTextAlignmentLeft
                                               fontName:@"HelveticaNeue-Bold"
                                               fontSize:42.0f];
    countdownLabel.position = ccp(525, 705);
    countdownLabel.color = ccc3(200, 140, 48);
    [self addChild:countdownLabel z: 6000];
    
    //Lancement du chronomètre
    [self schedule: @selector(generateOptimum:) interval:1];
    
    //Affichage du nombre unités - Left
    
    CGSize labelSize = CGSizeMake(8, 13);
    
    int unitsLeftLabelX = 76;
    
    int units1Label = size.height - 54,
        units2Label = size.height - 175.5,
        units3Label = size.height - 298,
        units4Label = size.height - 418,
        units5Label = size.height - 540;
    
    level1UnitLeftLabel.contentSize = labelSize;
    level1UnitLeftLabel = [[CCLabelAtlas alloc] initWithString:[NSString stringWithFormat:@"%i", level1UnitLeft]
                                                charMapFile:@"numeros_ville.png"
                                                itemWidth:8
                                                itemHeight:13
                                                startCharMap:'.'];
    
    level1UnitLeftLabel.anchorPoint = ccp(.5, .5);
    level1UnitLeftLabel.position = ccp(unitsLeftLabelX, units1Label);
    [self addChild:level1UnitLeftLabel z: 6000];

    level2UnitLeftLabel.contentSize = labelSize;
    level2UnitLeftLabel = [[CCLabelAtlas alloc] initWithString:[NSString stringWithFormat:@"%i", level2UnitLeft]
                                                   charMapFile:@"numeros_ville.png"
                                                     itemWidth:8
                                                    itemHeight:13
                                                  startCharMap:'.'];
    level2UnitLeftLabel.anchorPoint = ccp(.5, .5);
    level2UnitLeftLabel.position = ccp(unitsLeftLabelX, units2Label);
    [self addChild:level2UnitLeftLabel z: 6000];

    level3UnitLeftLabel.contentSize = labelSize;
    level3UnitLeftLabel = [[CCLabelAtlas alloc] initWithString:[NSString stringWithFormat:@"%i", level3UnitLeft]
                                                   charMapFile:@"numeros_ville.png"
                                                     itemWidth:8
                                                    itemHeight:13
                                                  startCharMap:'.'];
    level3UnitLeftLabel.anchorPoint = ccp(.5, .5);
    level3UnitLeftLabel.position = ccp(unitsLeftLabelX, units3Label);
    [self addChild:level3UnitLeftLabel z: 6000];
    
    level4UnitLeftLabel.contentSize = labelSize;
    level4UnitLeftLabel = [[CCLabelAtlas alloc] initWithString:[NSString stringWithFormat:@"%i", level4UnitLeft]
                                                   charMapFile:@"numeros_ville.png"
                                                     itemWidth:8
                                                    itemHeight:13
                                                  startCharMap:'.'];
    level4UnitLeftLabel.anchorPoint = ccp(.5, .5);
    level4UnitLeftLabel.position = ccp(unitsLeftLabelX, units4Label);
    [self addChild:level4UnitLeftLabel z: 6000];
    
    level5UnitLeftLabel.contentSize = labelSize;
    level5UnitLeftLabel = [[CCLabelAtlas alloc] initWithString:[NSString stringWithFormat:@"%i", level5UnitLeft]
                                                   charMapFile:@"numeros_ville.png"
                                                     itemWidth:8
                                                    itemHeight:13
                                                  startCharMap:'.'];
    level5UnitLeftLabel.anchorPoint = ccp(.5, .5);
    level5UnitLeftLabel.position = ccp(unitsLeftLabelX, units5Label);
    [self addChild:level5UnitLeftLabel z: 6000];
    
//    for (UnitSprite *sprite in self.children) {
//        
//        if ([sprite isKindOfClass:[UnitSprite class]])
//        {
    
    
    //Affichage du nombre unités - Right
    
    int unitsRightLabelX = size.width - 76;
    
    level1UnitRightLabel.contentSize = labelSize;
    level1UnitRightLabel = [[CCLabelAtlas alloc] initWithString:[NSString stringWithFormat:@"%i", level1UnitRight]
                                                    charMapFile:@"numeros_nature.png"
                                                      itemWidth:8
                                                     itemHeight:13
                                                   startCharMap:'.'];
    
    level1UnitRightLabel.anchorPoint = ccp(.5, .5);
    level1UnitRightLabel.position = ccp(unitsRightLabelX, units1Label);
    [self addChild:level1UnitRightLabel z: 6000];
    
    level2UnitRightLabel.contentSize = labelSize;
    level2UnitRightLabel = [[CCLabelAtlas alloc] initWithString:[NSString stringWithFormat:@"%i", level2UnitRight]
                                                    charMapFile:@"numeros_nature.png"
                                                      itemWidth:8
                                                     itemHeight:13
                                                   startCharMap:'.'];
    
    level2UnitRightLabel.anchorPoint = ccp(.5, .5);
    level2UnitRightLabel.position = ccp(unitsRightLabelX, units2Label);
    [self addChild:level2UnitRightLabel z: 6000];
    
    level3UnitRightLabel.contentSize = labelSize;
    level3UnitRightLabel = [[CCLabelAtlas alloc] initWithString:[NSString stringWithFormat:@"%i", level3UnitRight]
                                                    charMapFile:@"numeros_nature.png"
                                                      itemWidth:8
                                                     itemHeight:13
                                                   startCharMap:'.'];
    
    level3UnitRightLabel.anchorPoint = ccp(.5, .5);
    level3UnitRightLabel.position = ccp(unitsRightLabelX, units3Label);
    [self addChild:level3UnitRightLabel z: 6000];
    
    level4UnitRightLabel.contentSize = labelSize;
    level4UnitRightLabel = [[CCLabelAtlas alloc] initWithString:[NSString stringWithFormat:@"%i", level4UnitRight]
                                                    charMapFile:@"numeros_nature.png"
                                                      itemWidth:8
                                                     itemHeight:13
                                                   startCharMap:'.'];
    
    level4UnitRightLabel.anchorPoint = ccp(.5, .5);
    level4UnitRightLabel.position = ccp(unitsRightLabelX, units4Label);
    [self addChild:level4UnitRightLabel z: 6000];
    
    level5UnitRightLabel.contentSize = labelSize;
    level5UnitRightLabel = [[CCLabelAtlas alloc] initWithString:[NSString stringWithFormat:@"%i", level5UnitRight]
                                                    charMapFile:@"numeros_nature.png"
                                                      itemWidth:8
                                                     itemHeight:13
                                                   startCharMap:'.'];

    level5UnitRightLabel.anchorPoint = ccp(.5, .5);
    level5UnitRightLabel.position = ccp(unitsRightLabelX, units5Label);
    [self addChild:level5UnitRightLabel z: 6000];
    
    // 60, 31, 30 - 2px 90° - ombre interne
    // 
    
}


//Permet de générer des rectangles de couleur
- (CCSprite*) createSpriteRectangleWithSize:(CGSize)size
{
    CCSprite *sprite = [CCSprite node];
    GLubyte *buffer = malloc(sizeof(GLubyte)*4);
    for (int i=0; i<4; i++) { buffer[i]=255; }
    CCTexture2D *tex = [[CCTexture2D alloc] initWithData:buffer pixelFormat:kCCTexture2DPixelFormat_RGB5A1 pixelsWide:1 pixelsHigh:1 contentSize:size];
    [sprite setTexture:tex];
    [sprite setTextureRect:CGRectMake(0, 0, size.width, size.height)];
    free(buffer);
    
    return sprite;
}

- (void) addOptimum
{
    OptimumRessource *optimumRessource = [[OptimumRessource alloc] init];
	[self addChild:optimumRessource z:4444];
}

- (CGPoint) locationFromTouch:(UITouch*)touch
{
	CGPoint touchLocation = [touch locationInView: [touch view]];
	return [[CCDirector sharedDirector] convertToGL:touchLocation];
}

- (void) optimumRelease:(NSNotification *)notification {
    
    CGRect optimumBoundingBox = [[[notification object] objectForKey:@"position"] CGRectValue];
    NSInteger tag = [[[notification object] objectForKey:@"tag"] intValue];
    
    //On récupère les caractérisques du sprite (sous-classe d'OptimumRessource) relâché
    CCNode* node = [self getChildByTag:tag];
	OptimumRessource* spriteTouched = (OptimumRessource*)node;
    
    //Tests de collision entre le sprite récupéré et les différents élements
    if(CGRectIntersectsRect(optimumBoundingBox, leftStack.boundingBox) || CGRectIntersectsRect(rightStack.boundingBox, optimumBoundingBox))
    {
        /* Camp de gauche green | YES */
        if (CGRectIntersectsRect(rightStack.boundingBox, optimumBoundingBox))
        {
            if ([spriteTouched optimumType] == 3)
            {
                int disaster = arc4random() % 2;
                [self mysticEvent:disaster forTeam:YES]; //Yes : partie de droite
            }
            [stackElementRight addObject:[NSNumber numberWithInteger:[spriteTouched optimumType]]];
            [self removeChild:spriteTouched cleanup:YES];
            scoreLabelRight.string = [NSString stringWithFormat:@"%d", [stackElementRight count]];
            
            /* Camp de droite rose | NO */
        }else{
            if ([spriteTouched optimumType] == 3)
            {
                int disaster = arc4random() % 2;
                [self mysticEvent:disaster forTeam:NO]; //Yes : partie de gauche
            }
            [stackElementLeft addObject:[NSNumber numberWithInteger:[spriteTouched optimumType]]];
            [self removeChild:spriteTouched cleanup:YES];
            scoreLabelLeft.string = [NSString stringWithFormat:@"%d", [stackElementLeft count]];
        }
        
        /*
         // Math simple :
         // on divise le nombre d'Optimum récoltés dans un clan
         // pour ensuite le diviser par le nombre total d'Optimum récoltés par les joueurs...
         // pour l'autre partie, on sous-trait le chiffre précédemment obtenu à 1
         //
         */
        
        float scale = (float)[stackElementRight count] / (float)([stackElementRight count] + [stackElementLeft count]);
        rightStackBar.scaleX = scale;
        leftStackBar.scaleX = 1 - scale;
    }else{
        //        [spriteTouched resumeSchedulerAndActions];
        //Si on relâche l'Optimum sans le vide (pas dans une colonne). Eh bien, l'Optimum reprend sa course
        CCAction* fall = [CCMoveTo actionWithDuration:2
                                             position: ccp(spriteTouched.position.x, 0)];
        [spriteTouched runAction:fall];
    }
}

#pragma mark - Gestion des évènements

//Génère un évènement positif ou négatif en fonction du nombre récupéré 0 : positif | 1 : négatif
- (void) mysticEvent:(int)randNumber forTeam:(BOOL)team
{
    NSArray *positiveEventsList = [[NSArray alloc] initWithObjects:@"Infinite Ressources 3s", @"Add one unit", @"Add one random ressource", @"Victory", @"Heal", nil];
    NSArray *negativeEventsList = [[NSArray alloc] initWithObjects:@"Remove All", @"Remove one unit", @"Random disaster", @"Area effect change", nil];
    
    int randEvent = 0;
    
    if (randNumber == 0) //L'évèment est positif
    {
        //On génère un évènement positif aléatoire
        randEvent = arc4random() % [positiveEventsList count];
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Évènement" message:[positiveEventsList objectAtIndex:randEvent] delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil];
        //        [alert show];
        
        NSLog(@"%@", [positiveEventsList objectAtIndex:randEvent]);
        
        switch (randEvent) {
            case 0: //Ressources infinies
                    //                [self addUnitForTeam:team];
                break;
            case 1: //Ajout d'unité
                [self addUnitForTeam:team];
                break;
            case 2: //Ajout ressource aléatoire
                    //                [self addUnitForTeam:team];
                break;
            case 3: //Victoire
                    //                [self instantVictoryForTeam:team];
                break;
            case 4: //Ressources infinies
                    //                [self addUnitForTeam:team];
                break;
                
            default:
                break;
        }
        
    }else{  //L'évèment est négatif
            //On génère un évènement négatif aléatoire
        randEvent = arc4random() % [negativeEventsList count];
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Évènement" message:[negativeEventsList objectAtIndex:randEvent] delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil];
        //        [alert show];
        
        NSLog(@"%@", [negativeEventsList objectAtIndex:randEvent]);
        
        int randUnit = (arc4random() % 5) + 1; //Permet de savoir de quelle unité va perdre un élement
        
        switch (randEvent) {
            case 0: //Suppression de toutes les unités
                [self removeAllUnitsForTeam:team];
                break;
            case 1: //Supression d'unité
                [self substractUnitForTeam:team andUnit:randUnit];
                break;
            case 2: //Catastrophe aléatoire
                [self randomDisaster];
                break;
            case 3: //Area effect change
                    //                [self addUnitForTeam:team];
                CCLOG(@"Default");
                break;
            default:
                CCLOG(@"Default");
                break;
        }
    }
}


#pragma mark - Évènements Positifs

- (void) addUnitForTeam:(BOOL)team
{
    //    if (team == NO) { //On retire du camp de gauche
    //        numberOfUnitLeft++;
    //        [numberOfUnitLeftLabel setString:[NSString stringWithFormat:@"%d", numberOfUnitLeft]];
    //    }else{
    //        numberOfUnitRight++;
    //        [numberOfUnitRightLabel setString:[NSString stringWithFormat:@"%d", numberOfUnitRight]];
    //    }
    
    [self checkUnits];
}

- (void) instantVictoryForTeam:(BOOL)team
{
    NSArray *objectsProperties = [[NSArray alloc] initWithObjects:
                                  [NSNumber numberWithBool:team],
                                  nil];
    
    NSArray *keysProperties = [[NSArray alloc] initWithObjects:@"winner", nil];
    
    NSDictionary *parameters = [[NSDictionary alloc]
                                initWithObjects:objectsProperties
                                forKeys:keysProperties];
    //    [[CCDirector sharedDirector] replaceScene:[CCTransitionFade transitionWithDuration:1.0 scene:[HelloWorldLayer sceneWithParameters:parameters] withColor:ccORANGE]];
}

#pragma mark - Évènements Négatifs

- (void) removeAllUnitsForTeam:(BOOL)team{
    if (team == NO)
    { //On retire du camp de gauche
        
        level1UnitLeft = 0;
        [level1UnitLeftLabel setString:[NSString stringWithFormat:@"%d", level1UnitLeft]];
        
        level2UnitLeft = 0;
        [level2UnitLeftLabel setString:[NSString stringWithFormat:@"%d", level2UnitLeft]];
        
        level3UnitLeft = 0;
        [level3UnitLeftLabel setString:[NSString stringWithFormat:@"%d", level3UnitLeft]];
        
        level4UnitLeft = 0;
        [level4UnitLeftLabel setString:[NSString stringWithFormat:@"%d", level4UnitLeft]];
        
        level5UnitLeft = 0;
        [level5UnitLeftLabel setString:[NSString stringWithFormat:@"%d", level5UnitLeft]];
    }else{
        level1UnitRight = 0;
        [level1UnitRightLabel setString:[NSString stringWithFormat:@"%d", level1UnitRight]];
        
        level2UnitRight = 0;
        [level2UnitRightLabel setString:[NSString stringWithFormat:@"%d", level2UnitRight]];
        
        level3UnitRight = 0;
        [level3UnitRightLabel setString:[NSString stringWithFormat:@"%d", level3UnitRight]];
        
        level4UnitRight = 0;
        [level4UnitRightLabel setString:[NSString stringWithFormat:@"%d", level4UnitRight]];
        
        level5UnitRight = 0;
        [level5UnitRightLabel setString:[NSString stringWithFormat:@"%d", level5UnitRight]];
    }
}

- (void) substractUnitForTeam:(BOOL)team andUnit:(int)unit{
    switch (unit)
    {
        case 1:
            level1UnitLeft--;
            if (level1UnitLeft <= 0) { //Le nombre d'unités ne peut être inférieur à 0
                level1UnitLeft = 0;
            }
            [level1UnitLeftLabel setString:[NSString stringWithFormat:@"%d", level1UnitLeft]];
            break;
            
        case 3:
            level2UnitLeft--;
            if (level2UnitLeft <= 0) { //Le nombre d'unités ne peut être inférieur à 0
                level2UnitLeft = 0;
            }
            [level2UnitLeftLabel setString:[NSString stringWithFormat:@"%d", level2UnitLeft]];
            break;
            
        case 5:
            level3UnitLeft--;
            if (level3UnitLeft <= 0) { //Le nombre d'unités ne peut être inférieur à 0
                level3UnitLeft = 0;
            }
            [level3UnitLeftLabel setString:[NSString stringWithFormat:@"%d", level3UnitLeft]];
            break;
            
        case 7:
            level4UnitLeft--;
            if (level4UnitLeft <= 0) { //Le nombre d'unités ne peut être inférieur à 0
                level4UnitLeft = 0;
            }
            [level4UnitLeftLabel setString:[NSString stringWithFormat:@"%d", level4UnitLeft]];
            break;
            
        case 9:
            level5UnitLeft--;
            if (level5UnitLeft <= 0) { //Le nombre d'unités ne peut être inférieur à 0
                level5UnitLeft = 0;
            }
            [level5UnitLeftLabel setString:[NSString stringWithFormat:@"%d", level5UnitLeft]];
            break;
            
        case 2:
            level1UnitRight--;
            if (level1UnitRight <= 0) { //Le nombre d'unités ne peut être inférieur à 0
                level1UnitRight = 0;
            }
            [level1UnitRightLabel setString:[NSString stringWithFormat:@"%d", level1UnitRight]];
            break;
            
        case 4:
            level2UnitRight--;
            if (level2UnitRight <= 0) { //Le nombre d'unités ne peut être inférieur à 0
                level2UnitRight = 0;
            }
            [level2UnitRightLabel setString:[NSString stringWithFormat:@"%d", level2UnitRight]];
            break;
            
        case 6:
            level3UnitRight--;
            if (level3UnitRight <= 0) { //Le nombre d'unités ne peut être inférieur à 0
                level3UnitRight = 0;
            }
            [level3UnitRightLabel setString:[NSString stringWithFormat:@"%d", level3UnitRight]];
            break;
            
        case 8:
            level4UnitRight--;
            if (level4UnitRight <= 0) { //Le nombre d'unités ne peut être inférieur à 0
                level4UnitRight = 0;
            }
            [level4UnitRightLabel setString:[NSString stringWithFormat:@"%d", level4UnitRight]];
            break;
            
        case 10:
            level5UnitRight--;
            if (level5UnitRight <= 0) { //Le nombre d'unités ne peut être inférieur à 0
                level5UnitRight = 0;
            }
            [level5UnitRightLabel setString:[NSString stringWithFormat:@"%d", level5UnitRight]];
            break;
            
        default:
            
            break;
    }
}


#pragma mark - Catastrophes

- (void) randomDisaster{
    NSArray *disastersList = [[NSArray alloc] initWithObjects:@"Freeze", @"Meteors", @"empty", nil];
    
    int randomDisaster = arc4random() % [disastersList count];
    
    switch (randomDisaster) {
        case 0:
            //            [self earthquake];
            [self freeze];
            break;
            
        case 1:
            //            [self meteors];
            //            Meteor *truc = [[Meteor alloc] init];
            //            [self addChild:truc];
            CCLOG(@"Meteor");
            break;
            
        case 2: //Vide
            CCLOG(@"Nothing");
            break;
            
        default:
            CCLOG(@"Default");
            break;
    }
}

- (void) earthquake{
    CCNode* node = [self getChildByTag:TileMapTag];
	CCTMXTiledMap* tiledMap = (CCTMXTiledMap*)node;
    
    CCMoveTo* moveForward = [CCMoveTo actionWithDuration:0.15f position:ccp(tiledMap.boundingBox.origin.x + 10, tiledMap.boundingBox.origin.y)];
    CCMoveTo* moveBackward = [CCMoveTo actionWithDuration:0.15f position:ccp(tiledMap.boundingBox.origin.x, tiledMap.boundingBox.origin.y)];
    
    CCSequence *pulseSequence = [CCSequence actionOne:moveForward two:moveBackward];
    CCRepeat *repeat = [CCRepeat actionWithAction:pulseSequence times:5];
    [tiledMap runAction:repeat];
}

- (void) freeze{
    FreezeScreen *freezeMap = [[FreezeScreen alloc] init];
    [self addChild:freezeMap z:9999 tag:0];
}

//- (void) ccTouchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
//{
//	// get the position in tile coordinates from the touch location
//	CGPoint touchLocation = [self locationFromTouches:touches];
//    
//    CCNode* node = [self getChildByTag:TileMapTag];
//	NSAssert([node isKindOfClass:[CCTMXTiledMap class]], @"not a CCTMXTiledMap");
//	CCTMXTiledMap* tileMap = (CCTMXTiledMap*)node;
//    
//    CCTMXLayer *layer = [tileMap layerNamed:@"Tiles"];
//    
//    CGPoint tileCord = [self tilePosFromLocation:touchLocation tileMap:tileMap];
//    
//    if (
//        [layer tileGIDAt:tileCord] != 33 ||
//        [layer tileGIDAt:tileCord] != 0
//        )
//    {
////        CCLOG([layer tileAt:tileCord].team ? @"Yes" : @"No");
//        CCLOG(@"%i", [layer tileAt:tileCord].frequency);
//    }
//}


-(CGPoint) locationFromTouches:(NSSet*)touches
{
	return [self locationFromTouch:[touches anyObject]];
}



#pragma mark - Gestion des déplacements et actions sur la carte isométrique

- (void) unitMove:(NSNotification *)notification {
    NSInteger tag = [[[notification object] objectForKey:@"tag"] intValue];
    CGPoint touchLocation = [[[notification object] objectForKey:@"touchLocation"] CGPointValue];
    
    CCNode *unitNode = [self getChildByTag:tag];
    UnitSprite *sprite = (UnitSprite*)unitNode;
    
    CCNode* node = [self getChildByTag:TileMapTag];
	CCTMXTiledMap* tiledMap = (CCTMXTiledMap*)node;
    CCTMXLayer *highlightLayer;
    
    
    if (sprite.team) { //Equipe de droite
        highlightLayer = [tiledMap layerNamed:@"HighlightRight"];
    }else{
        highlightLayer = [tiledMap layerNamed:@"HighlightLeft"];
    }
    
    CGPoint tileCord = [self tilePosFromLocation:sprite.position tileMap:tiledMap];
    CGPoint coords = [self positionForTileCoord:ccp(tileCord.x, tileCord.y-1) tileMap:tiledMap];
    coords.x -= (tiledMap.position.y / 3);
    
    if (CGRectContainsPoint(tiledMap.boundingBox, touchLocation)){
        //        sprite.position = coords;
        
        for (NSUInteger y = 0; y < tiledMap.mapSize.height; y++) {
            for (NSUInteger x = 0; x < tiledMap.mapSize.width; x++) {
                CGPoint p = ccp(x, y);
                //Affichage de la zone d'effets
                if(
                   CGPointEqualToPoint(p, [[[self getProximityTiles:tileCord] objectAtIndex:0] CGPointValue]) ||
                   CGPointEqualToPoint(p, [[[self getProximityTiles:tileCord] objectAtIndex:1] CGPointValue]) ||
                   CGPointEqualToPoint(p, [[[self getProximityTiles:tileCord] objectAtIndex:2] CGPointValue]) ||
                   CGPointEqualToPoint(p, [[[self getProximityTiles:tileCord] objectAtIndex:3] CGPointValue])
                   ) {
                    [highlightLayer setTileGID:31 at:p];
                    
                    CCFadeTo *fadeIn = [CCFadeTo actionWithDuration:0.5 opacity:127];
                    CCFadeTo *fadeOut = [CCFadeTo actionWithDuration:0.5 opacity:255];
                    CCSequence *pulseSequence = [CCSequence actionOne:fadeIn two:fadeOut];
                    CCRepeatForever *repeat = [CCRepeatForever actionWithAction:pulseSequence];
                    [[highlightLayer tileAt:p] runAction:repeat];
                }else{
                    [highlightLayer removeTileAt:p];
                    //                    [tilesLayer tileAt:p].opacity = 255;
                }
                
                //On met en place des helpers pour les trucs cachés
                //                if (
                //                    CGPointEqualToPoint(p, [[[self getProximityTilesHelpers:tileCord] objectAtIndex:0] CGPointValue]) ||
                //                    CGPointEqualToPoint(p, [[[self getProximityTilesHelpers:tileCord] objectAtIndex:1] CGPointValue]) ||
                //                    CGPointEqualToPoint(p, [[[self getProximityTilesHelpers:tileCord] objectAtIndex:2] CGPointValue]) ||
                //                    CGPointEqualToPoint(p, [[[self getProximityTilesHelpers:tileCord] objectAtIndex:3] CGPointValue]) ||
                //                    CGPointEqualToPoint(p, [[[self getProximityTilesHelpers:tileCord] objectAtIndex:4] CGPointValue])
                //                    ) {
                //                    [tilesLayer tileAt:p].opacity = 127;
                //                }else{
                //                    [tilesLayer tileAt:p].opacity = 255;
                //                }
            }
        }
    }else{
        [self cleanLayer:@"HighlightLeft"];
        [self cleanLayer:@"HighlightRight"];
    }
}


//Lâcher d'unité
- (void) unitRelease:(NSNotification *)notification {
    
    NSInteger tag = [[[notification object] objectForKey:@"tag"] intValue];
    CGPoint touchLocation = [[[notification object] objectForKey:@"touchLocation"] CGPointValue];
    CGPoint initPosition = [[[notification object] objectForKey:@"initPosition"] CGPointValue];
    //    BOOL team = [[[notification object] objectForKey:@"team"] boolValue];
    
    //On récupère les caractérisques du sprite (sous-classe d'OptimumRessource) relâché
    CCNode* mapNode = [self getChildByTag:TileMapTag];
	CCTMXTiledMap* tiledMap = (CCTMXTiledMap*)mapNode;
    CCTMXLayer *tilesLayer = [tiledMap layerNamed:@"Tiles"];
    
    CCNode *unitNode = [self getChildByTag:tag];
    UnitSprite *sprite = (UnitSprite*)unitNode;
    
    CGPoint tileCord = [self tilePosFromLocation:touchLocation tileMap:tiledMap];
    tileCord.y -= 1;
    
    [self cleanLayer:@"HighlightLeft"];
    [self cleanLayer:@"HighlightRight"];
    [self opaqueLayer:@"Tiles"];
    
    //    [self actionAtCoordinate:ccp(0, 0)];
    
    
    //    Permet de placer à sa place initiale le Sprite sélectionné
    CCAction *back2InitPosition = [CCMoveTo actionWithDuration:.2f
                                                      position: ccp(initPosition.x, initPosition.y)];
    
    CCAction *backInitPosition = [CCMoveTo actionWithDuration:0
                                                     position: ccp(initPosition.x, initPosition.y)];
    
    if (CGRectContainsPoint(tiledMap.boundingBox, touchLocation))
    {
        //On vérifie que la tuile sélectionnée est vide
        if (
            [tilesLayer tileGIDAt:ccp(tileCord.x, tileCord.y + 1)] == 33 ||
            [tilesLayer tileGIDAt:ccp(tileCord.x, tileCord.y + 1)] == 0
            )
        {
            [tilesLayer setTileGID:sprite.level at:ccp(tileCord.x, tileCord.y + 1)];
            
            [self substractUnitForTeam:sprite.team andUnit:sprite.level];
            [self checkUnits];
            
            [sprite runAction:backInitPosition];
            
            //            [self fullMap:tiledMap atLayer:@"Tiles"];
        }else{
            
            [sprite runAction:back2InitPosition];
        }
    }else{
        
        [sprite runAction:back2InitPosition];
    }
}

//Gère le stack d'unités
//- (void) checkUnits:(UnitSprite*)sprite{
- (void) checkUnits{
    //Vérifie qu'il est toujours possible de placer des tuiles pour une unité donnée
    for (UnitSprite *sprite in self.children) {
        
        if ([sprite isKindOfClass:[UnitSprite class]])
        {
            // Camp de droite
            switch (sprite.level)
            {
                case 2:
                    sprite.units = level1UnitRight;
                    break;
                    
                case 4:
                    sprite.units = level2UnitRight;
                    break;
                    
                case 6:
                    sprite.units = level3UnitRight;
                    break;
                    
                case 8:
                    sprite.units = level4UnitRight;
                    break;
                    
                case 10:
                    sprite.units = level5UnitRight;
                    break;
                    
                    // Camp de gauche
                case 1:
                    sprite.units = level1UnitLeft;
                    break;
                    
                case 3:
                    sprite.units = level2UnitLeft;
                    break;
                    
                case 5:
                    sprite.units = level3UnitLeft;
                    break;
                    
                case 7:
                    sprite.units = level4UnitLeft;
                    break;
                    
                case 9:
                    sprite.units = level5UnitLeft;
                    break;
                    
                default:
                    break;
            }
        }
    }
}


- (void) cleanLayer:(NSString*)layerName{
    CCNode* mapNode = [self getChildByTag:TileMapTag];
	CCTMXTiledMap* tiledMap = (CCTMXTiledMap*)mapNode;
    CCTMXLayer *layer = [tiledMap layerNamed:layerName];
    
    for (NSUInteger y = 0; y < tiledMap.mapSize.height; y++) {
        for (NSUInteger x = 0; x < tiledMap.mapSize.width; x++) {
            CGPoint p = ccp(x, y);
            [layer removeTileAt:p];
        }
    }
}

- (void) opaqueLayer:(NSString*)layerName{
    CCNode* mapNode = [self getChildByTag:TileMapTag];
	CCTMXTiledMap* tiledMap = (CCTMXTiledMap*)mapNode;
    CCTMXLayer *layer = [tiledMap layerNamed:layerName];
    
    for (NSUInteger y = 0; y < tiledMap.mapSize.height; y++) {
        for (NSUInteger x = 0; x < tiledMap.mapSize.width; x++) {
            CGPoint p = ccp(x, y);
            [layer tileAt:p].opacity = 255;
        }
    }
}

- (NSArray*) getProximityTilesHelpers:(CGPoint)location
{
    /*
     On récupère la tuile sélectionnée, c'est "location" (X, Y)
     Les tuiles environnantes correspondent aux coordonnées suivantes, en formation + :
     Diagonale H gauche : (X-1, Y)
     Diagonale H droite : (X, Y-1)
     Diagonale B gauche : (X, Y+1)
     Diagonale B droite : (X+1, Y) llll
     */
    
    CGPoint diagonalUpperLeft = ccp(location.x - 1, location.y);
    CGPoint diagonalUpperRight = ccp(location.x, location.y - 1);
    
    CGPoint diagonalBottomLeft = ccp(location.x, location.y + 1);
    CGPoint diagonalBottomRight = ccp(location.x + 1, location.y);
    
    CGPoint top = ccp(location.x - 1, location.y - 1);
    CGPoint right = ccp(location.x + 1, location.y - 1);
    
    CGPoint bottom = ccp(location.x + 1, location.y + 1);
    CGPoint left = ccp(location.x - 1, location.y + 1);
    
    NSArray *proximityTiles = [[NSArray alloc] initWithObjects:
                               [NSValue valueWithCGPoint:diagonalBottomLeft],
                               [NSValue valueWithCGPoint:diagonalBottomRight],
                               [NSValue valueWithCGPoint:right],
                               [NSValue valueWithCGPoint:bottom],
                               [NSValue valueWithCGPoint:left],
                               nil];
    
    return proximityTiles;
}

- (NSArray*) getProximityTiles:(CGPoint)location
{
    /*
     On récupère la tuile sélectionnée, c'est "location" (X, Y)
     Les tuiles environnantes correspondent aux coordonnées suivantes, en formation + :
     Diagonale H gauche : (X-1, Y)
     Diagonale H droite : (X, Y-1)
     Diagonale B gauche : (X, Y+1)
     Diagonale B droite : (X+1, Y)
     */
    
    CGPoint diagonalUpperLeft = ccp(location.x - 1, location.y);
    CGPoint diagonalUpperRight = ccp(location.x, location.y - 1);
    
    CGPoint diagonalBottomLeft = ccp(location.x, location.y + 1);
    CGPoint diagonalBottomRight = ccp(location.x + 1, location.y);
    
    NSArray *proximityTiles = [[NSArray alloc] initWithObjects:
                               [NSValue valueWithCGPoint:diagonalUpperLeft],
                               [NSValue valueWithCGPoint:diagonalUpperRight],
                               [NSValue valueWithCGPoint:diagonalBottomLeft],
                               [NSValue valueWithCGPoint:diagonalBottomRight],
                               nil];
    
    return proximityTiles;
}

- (CGPoint)positionForTileCoord:(CGPoint)tileLocation tileMap:(CCTMXTiledMap*)tileMap
{
	int x = (tileMap.position.x + (tileMap.mapSize.width * (tileMap.tileSize.width/2))) + ((tileLocation.x - tileLocation.y) * (tileMap.tileSize.width/2));
	int y = (tileMap.position.y + (tileMap.mapSize.height * (tileMap.tileSize.width/2)) - (tileMap.tileSize.height/2)) - ((tileLocation.y + tileLocation.x) * (tileMap.tileSize.height/2));
    
	return ccp(x, y);
}

-(CGPoint) tilePosFromLocation:(CGPoint)location tileMap:(CCTMXTiledMap*)tileMap
{
	// Tilemap position must be subtracted, in case the tilemap position is not at 0,0 due to scrolling
	CGPoint pos = ccpSub(location, tileMap.position);
	
	float halfMapWidth = (tileMap.mapSize.width) * 0.5f;
	float mapHeight = (tileMap.mapSize.height);
	float tileWidth = (tileMap.tileSize.width / 1);
	float tileHeight = (tileMap.tileSize.height / 1);
	
	CGPoint tilePosDiv = CGPointMake(pos.x / tileWidth, pos.y / tileHeight);
    
	float inverseTileY = mapHeight - tilePosDiv.y;
    
	// Cast to int makes sure that result is in whole numbers, tile coordinates will be used as array indices
	float posX = (int)(inverseTileY + tilePosDiv.x - halfMapWidth);
	float posY = (int)(inverseTileY - tilePosDiv.x + halfMapWidth);
    
	// make sure coordinates are within isomap bounds
	posX = MAX(0, posX);
	posX = MIN(tileMap.mapSize.width - 1, posX);
	posY = MAX(0, posY);
	posY = MIN(tileMap.mapSize.height - 1, posY);
	
	pos = CGPointMake(posX, posY);
    
	return pos;
}

//Gestion du remplissage de la carte
- (void) fullMap:(CCTMXTiledMap*) tileMap atLayer:(NSString*)layerName{
    
    CCTMXLayer* layer = [tileMap layerNamed:layerName];
    
    NSMutableArray *fullMap = [[NSMutableArray alloc] init];
    [fullMap removeAllObjects];
    //    int i = 0;
    for (NSUInteger y = 0; y < layer.layerSize.height; y++) {
        for (NSUInteger x = 0; x < layer.layerSize.width; x++) {
            //            NSUInteger pos = x + layer.layerSize.width * y;
            uint32_t gid = [layer tileGIDAt:ccp(x, y)];
            
            if (gid != 0) {
                [fullMap addObject:@"full"];
            }
        }
    }
    
    if ([fullMap count] >= (tileMap.mapSize.height * tileMap.mapSize.width)) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Carte remplie !" message:nil delegate:self cancelButtonTitle:@"ok" otherButtonTitles: nil];
        [alert show];
    }
}

//- (void) actions
- (void) tilesAttacks: (ccTime) dt
{
    timeElapse++;
    CCNode* node = [self getChildByTag:TileMapTag];
    NSAssert([node isKindOfClass:[CCTMXTiledMap class]], @"not a CCTMXTiledMap");
    CCTMXTiledMap* tileMap = (CCTMXTiledMap*)node;
    
    CCTMXLayer *layer = [tileMap layerNamed:@"Tiles"];
    
    for (NSUInteger y = 0; y < layer.layerSize.height; y++)
    {
        for (NSUInteger x = 0; x < layer.layerSize.width; x++)
        {
            if (
                [layer tileGIDAt:ccp(x, y)] != 33 ||
                [layer tileGIDAt:ccp(x, y)] != 0
                )
            {
                
//                [self actionAtCoordinate: ccp(x, y)];
                [self actionAtCoordinate: ccp(x, y)];
            }
        }
    }
}

- (void) actionAtCoordinate:(CGPoint)tile
{
    CCNode* node = [self getChildByTag:TileMapTag];
    NSAssert([node isKindOfClass:[CCTMXTiledMap class]], @"not a CCTMXTiledMap");
    CCTMXTiledMap* tileMap = (CCTMXTiledMap*)node;
    
    CCTMXLayer *layer = [tileMap layerNamed:@"Tiles"];
    
    int attackPoint = [layer tileAt:tile].attackPoint;
    BOOL teamTile = [layer tileAt:tile].team;
    int frequencyAttack = [layer tileAt:tile].frequency;
    
//    CCLOG(@"attackPoint : %i, frequencyAttack : %i", attackPoint, frequencyAttack);
    
    // On s'assure que l'unité a le "droit" d'attaquer
    if (timeElapse % frequencyAttack == 0)
    {
        
        //On recupère les tuiles aux alentours
        NSArray *arroundTiles = [[NSArray alloc] initWithArray:[self getProximityTiles:tile]];
        
        for (int i = 0; i < [arroundTiles count]; i++)
        {
            CGPoint p = [[arroundTiles objectAtIndex:i] CGPointValue];
            //On vérifie que l'on ne cible une tuile à l'extérieur de la map et qu'il y a un batîment à cet emplacement
            
            if (p.x >= 0 && p.x < tileMap.mapSize.width && p.y >= 0 && p.y < tileMap.mapSize.height)
            {
                if ([layer tileGIDAt:p] != 0 && [layer tileAt:p].team != teamTile)
                {
                    if ([layer tileAt:p].HP <= 0)
                    {
                        if ([layer tileAt:p].team == YES) {
                            unitLeftDestroyed++;
                        }else{
                            unitRightDestroyed++;
                        }
                        [layer removeTileAt:p];
                    }else{
                        [layer tileAt:p].HP -= attackPoint;
                        //Est-ce qu'on a atteint la moitié de la barre de vie ?
                        if ([layer tileAt:p].HP <= [layer tileAt:p].HPMax/2 && [layer tileAt:p].demi == NO)
                        {
                            [layer setTileGID:[layer tileGIDAt:p] + 10 at:p];
                            [layer tileAt:p].demi = YES;
                            //Est-ce qu'on a atteint la tiers de la barre de vie ?
                        }else if ([layer tileAt:p].HP <= [layer tileAt:p].HPMax/3 && [layer tileAt:p].tiers == NO)
                        {
                            [layer setTileGID:[layer tileGIDAt:p] + 10 at:p];
                            [layer tileAt:p].tiers = YES;
                        }
                    }
                }
            }
        }
    }
}

// on "dealloc" you need to release all your retained objects
- (void) dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    
	// in case you have something to dealloc, do it in this method
	// in this particular example nothing needs to be released.
	// cocos2d will automatically release all the children (Label)
	
	// don't forget to call "super dealloc"
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
    [[SimpleAudioEngine sharedEngine] stopBackgroundMusic];
    [[SimpleAudioEngine sharedEngine] preloadBackgroundMusic:@"jeu_loop.aif"];
    [[SimpleAudioEngine sharedEngine] playBackgroundMusic:@"jeu_loop.aif" loop:YES];
}

-(void) onExit
{
    // Called right before node’s dealloc method is called.
    // If using a CCTransitionScene: called when the transition has ended.
    [super onExit];
    [[SimpleAudioEngine sharedEngine] stopBackgroundMusic];
}

@end