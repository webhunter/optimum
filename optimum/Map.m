//
//  Map.m
//  Optimum-maquette
//
//  Created by Jean-Louis Danielo on 25/04/13.
//  Copyright 2013 __MyCompanyName__. All rights reserved.
//

#import "Map.h"
#import "HelloWorldLayer.h"

#import "CCTMXLayer+TileLifeLayer.h"

#import "TeamLayer.h"


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

+ (CCScene *) sceneWithParameters:(NSString*)parameter
{
	// 'scene' is an autorelease object.
	CCScene *scene = [CCScene node];
    
	// 'layer' is an autorelease object.
	Map *layer = [Map node];
	
	// add layer as a child to scene
	[scene addChild: layer];
    
    //	CCLOG(@"parameter : %i", parameter);
	// return the scene
	return scene;
}

+ (id) nodeWithGameLevel:(NSString*)level{
    return [[self alloc] initWithGameLevel:level];
}

- (id) initWithGameLevel:(NSString*)level{
    
    return self;
}

// on "init" you need to initialize your instance
- (id) init
{
	// always call "super" init
	// Apple recommends to re-assign "self" with the "super's" return value
	if( (self=[super init]) )
    {
        CGSize size = [[CCDirector sharedDirector] winSize];
        
        timeElapse = 0;
        
        CCLOG(@"trucmuche");
        
        
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
        
        Mapquake *map = [[Mapquake alloc] initWithTMXFile:@"maquette-map-2.tmx"];
        
        CCTMXLayer *layer = [map layerNamed:@"Layer 0"];
        
        CGSize s = [layer layerSize];
        for( int x=0; x<s.width;x++) {
            for( int y=0; y< s.height; y++ ) {
                unsigned int tmpgid = [layer tileGIDAt:ccp(x,y)];
                [layer setTileGID:tmpgid+1 at:ccp(x,y)];
            }
        }
        
        [self centerIntoScreen:map];
        [self addChild:map z:-1 tag:TileMapTag];
        
        
        //Stack d'élements gauche et droite
        leftStack = [self createSpriteRectangleWithSize:CGSizeMake(81, size.height)];
        leftStack.color = ccc3(209, 185, 218);
        leftStack.position = ccp(40.5, 384);
        [self addChild:leftStack];
        
        rightStack = [self createSpriteRectangleWithSize:CGSizeMake(81, size.height)];
        rightStack.color = ccc3(197, 229, 232);
        rightStack.position = ccp((size.width - 40.5), 384);
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
        
        
        [self schedule: @selector(tilesAttacks:) interval:1];
	}
	return self;
}


//Function qui cadence l'attaque des différentes tuiles
//- (void) tilesAttacks: (ccTime) dt
//{
//    [self actions];
//}


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
    if (countdown <= 0) {
        [[CCDirector sharedDirector] replaceScene:[CCTransitionFade transitionWithDuration:1.0 scene:[TeamLayer scene] withColor:ccGREEN]];
    }
}

- (void) displayInterface{
    
    //Affichage des unités
    UnitSprite *sprited = [[UnitSprite alloc] initWithUnitType:5 atPosition:ccp(5 + 75, 750 - (75 / 2))];
    [self addChild:sprited z:1000];
    
    UnitSprite *sprited2 = [[UnitSprite alloc] initWithUnitType:0 atPosition:ccp(5 + 936, 750 - (75 / 2))];
    [self addChild:sprited2 z:1000];
    
    //Affichage des scores
    scoreLabelLeft = [[CCLabelTTF alloc] initWithString:@"0"
                                             dimensions:CGSizeMake(120, 120)
                                             hAlignment:kCCTextAlignmentLeft
                                               fontName:@"HelveticaNeue-Bold"
                                               fontSize:42.0f];
    scoreLabelLeft.position = ccp(150, 130);
    scoreLabelLeft.color = ccc3(209, 185, 218);
    [self addChild:scoreLabelLeft z: 6000];
    
    
    scoreLabelRight = [[CCLabelTTF alloc] initWithString:@"0"
                                              dimensions:CGSizeMake(120, 120)
                                              hAlignment:kCCTextAlignmentLeft
                                                fontName:@"HelveticaNeue-Bold"
                                                fontSize:42.0f];
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
    countdown = 60 * 3;
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
    
    level1UnitLeft = 7;
    level2UnitLeft = 7;
    level3UnitLeft = 7;
    level4UnitLeft = 7;
    level5UnitLeft = 7;
    
    level3UnitLeftLabel = [[CCLabelTTF alloc] initWithString:[NSString stringWithFormat:@"%i", level3UnitLeft]
                                                  dimensions:CGSizeMake(150, 130)
                                                  hAlignment:kCCTextAlignmentLeft
                                                    fontName:@"HelveticaNeue-Bold"
                                                    fontSize:31.0f];
    level3UnitLeftLabel.anchorPoint = ccp(0, .5);
    level3UnitLeftLabel.position = ccp(25, 705);
    level3UnitLeftLabel.color = ccc3(197, 229, 232);
    [self addChild:level3UnitLeftLabel z: 6000];
    
    level1UnitRight = 77;
    level2UnitRight = 7;
    level3UnitRight = 7;
    level4UnitRight = 7;
    level5UnitRight = 7;
    
    
    level1UnitRightLabel = [[CCLabelTTF alloc] initWithString:[NSString stringWithFormat:@"%i", level1UnitRight]
                                                   dimensions:CGSizeMake(150, 130)
                                                   hAlignment:kCCTextAlignmentLeft
                                                     fontName:@"HelveticaNeue-Bold"
                                                     fontSize:31.0f];
    level1UnitRightLabel.anchorPoint = ccp(0, .5);
    level1UnitRightLabel.position = ccp(sprited2.position.x + 30, 705);
    level1UnitRightLabel.color = ccc3(209, 185, 218);
    [self addChild:level1UnitRightLabel z: 6000];
}

- (void) displayUnitsNumber{
    
}

//Permet de générer des rectangles de couleur
- (CCSprite*) createSpriteRectangleWithSize:(CGSize)size
{
    CCSprite *sprite = [CCSprite node];
    GLubyte *buffer = malloc(sizeof(GLubyte)*4);
    for (int i=0;i<4;i++) {buffer[i]=255;}
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
        [alert show];
        
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
        [alert show];
        
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
    
    if (team == NO) { //On retire du camp de gauche
        switch (unit)
        {
            case 2:
                level1UnitLeft--;
                if (level1UnitLeft <= 0) { //Le nombre d'unités ne peut être inférieur à 0
                    level1UnitLeft = 0;
                }
                [level1UnitLeftLabel setString:[NSString stringWithFormat:@"%d", level1UnitLeft]];
                break;
                
            case 4:
                level2UnitLeft--;
                if (level2UnitLeft <= 0) { //Le nombre d'unités ne peut être inférieur à 0
                    level2UnitLeft = 0;
                }
                [level2UnitLeftLabel setString:[NSString stringWithFormat:@"%d", level2UnitLeft]];
                break;
                
            case 6:
                level3UnitLeft--;
                if (level3UnitLeft <= 0) { //Le nombre d'unités ne peut être inférieur à 0
                    level3UnitLeft = 0;
                }
                [level3UnitLeftLabel setString:[NSString stringWithFormat:@"%d", level3UnitLeft]];
                break;
                
            case 8:
                level4UnitLeft--;
                if (level4UnitLeft <= 0) { //Le nombre d'unités ne peut être inférieur à 0
                    level4UnitLeft = 0;
                }
                [level4UnitLeftLabel setString:[NSString stringWithFormat:@"%d", level4UnitLeft]];
                break;
                
            case 10:
                level5UnitLeft--;
                if (level5UnitLeft <= 0) { //Le nombre d'unités ne peut être inférieur à 0
                    level5UnitLeft = 0;
                }
                [level5UnitLeftLabel setString:[NSString stringWithFormat:@"%d", level5UnitLeft]];
                break;
                
            default:
                break;
        }
    }else{
        switch (unit)
        {
            case 1:
                level1UnitRight--;
                if (level1UnitRight <= 0) { //Le nombre d'unités ne peut être inférieur à 0
                    level1UnitRight = 0;
                }
                [level1UnitRightLabel setString:[NSString stringWithFormat:@"%d", level1UnitRight]];
                break;
                
            case 3:
                level2UnitRight--;
                if (level2UnitRight <= 0) { //Le nombre d'unités ne peut être inférieur à 0
                    level2UnitRight = 0;
                }
                [level2UnitRightLabel setString:[NSString stringWithFormat:@"%d", level2UnitRight]];
                break;
                
            case 5:
                level3UnitRight--;
                if (level3UnitRight <= 0) { //Le nombre d'unités ne peut être inférieur à 0
                    level3UnitRight = 0;
                }
                [level3UnitRightLabel setString:[NSString stringWithFormat:@"%d", level3UnitRight]];
                break;
                
            case 7:
                level4UnitRight--;
                if (level4UnitRight <= 0) { //Le nombre d'unités ne peut être inférieur à 0
                    level4UnitRight = 0;
                }
                [level4UnitRightLabel setString:[NSString stringWithFormat:@"%d", level4UnitRight]];
                break;
                
            case 9:
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
//    CCLOG(@"%d", [layer unitAt:tileCord].HP);
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
    
    
    //Permet de placer à sa place initiale le Sprite sélectionné
    CCAction *back2InitPosition = [CCMoveTo actionWithDuration:.2f
                                                      position: ccp(initPosition.x, initPosition.y)];
    
    CCAction *backInitPosition = [CCMoveTo actionWithDuration:0
                                                     position: ccp(initPosition.x, initPosition.y)];
    
    if (CGRectContainsPoint(tiledMap.boundingBox, touchLocation))
    {
        //On vérifie que la tuile sélectionnée est vide
        if ([tilesLayer tileGIDAt:ccp(tileCord.x, tileCord.y + 1)] == 0 ||
            [tilesLayer tileGIDAt:ccp(tileCord.x, tileCord.y + 1)] == 33 ||
            [tilesLayer tileGIDAt:ccp(tileCord.x, tileCord.y + 1)] == 34 ||
            [tilesLayer tileGIDAt:ccp(tileCord.x, tileCord.y + 1)] == 35 ||
            [tilesLayer tileGIDAt:ccp(tileCord.x, tileCord.y + 1)] == 36 ||
            [tilesLayer tileGIDAt:ccp(tileCord.x, tileCord.y + 1)] == 37 ||
            [tilesLayer tileGIDAt:ccp(tileCord.x, tileCord.y + 1)] == 38 ||
            [tilesLayer tileGIDAt:ccp(tileCord.x, tileCord.y + 1)] == 39 ||
            [tilesLayer tileGIDAt:ccp(tileCord.x, tileCord.y + 1)] == 40) //9
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
        if ([sprite isKindOfClass:[UnitSprite class]]) {
            if (sprite.team == NO) //On retire du camp de gauche
            {
                switch (sprite.level)
                {
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
            }else{
                switch (sprite.level) {
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
                        
                    default:
                        break;
                }
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
     Diagonale B droite : (X+1, Y)
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
            [self actionAtCoordinate: ccp(x, y)];
        }
    }
}

- (void) actionAtCoordinate:(CGPoint)tile
{
    CCNode* node = [self getChildByTag:TileMapTag];
    NSAssert([node isKindOfClass:[CCTMXTiledMap class]], @"not a CCTMXTiledMap");
    CCTMXTiledMap* tileMap = (CCTMXTiledMap*)node;
    
    CCTMXLayer *layer = [tileMap layerNamed:@"Tiles"];
    
    //    CCLOG(@"trc : %@", CGPointCreateDictionaryRepresentation(tile));
    
    //    NSLog(@"%i", [layer tileGIDAt:tile]);
    //Il y a un un bâtiment sur cette case
    if ([layer tileGIDAt:tile] != 0 &&
        [layer tileGIDAt:tile] != 33 &&
        [layer tileGIDAt:tile] != 34 &&
        [layer tileGIDAt:tile] != 35 &&
        [layer tileGIDAt:tile] != 36 &&
        [layer tileGIDAt:tile] != 37 &&
        [layer tileGIDAt:tile] != 38 &&
        [layer tileGIDAt:tile] != 39 &&
        [layer tileGIDAt:tile] != 40
        )
    {
        int attackPoint = [layer unitAt:tile].attackPoint;
        BOOL teamTile = [layer unitAt:tile].team;
        int frequencyAttack = [layer unitAt:tile].frequency;
        
        CCLOG(@"truc : %i, %i, timeElapse : %i", timeElapse % frequencyAttack, frequencyAttack, timeElapse);
        
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
                    if ([layer tileGIDAt:p] != 0 && [layer unitAt:p].team != teamTile)
                    {
                        if ([layer unitAt:p].HP <= 0)
                        {
                            [layer removeTileAt:p];
                        }else{
                            [layer unitAt:p].HP -= attackPoint;
                            //Est-ce qu'on a atteint la moitié de la barre de vie ?
                            if ([layer unitAt:p].HP <= [layer unitAt:p].HPMax/2 && [layer unitAt:p].demi == NO)
                            {
                                [layer setTileGID:[layer tileGIDAt:p] + 10 at:p];
                                [layer unitAt:p].demi = YES;
                                //Est-ce qu'on a atteint la tiers de la barre de vie ?
                            }else if ([layer unitAt:p].HP <= [layer unitAt:p].HPMax/3 && [layer unitAt:p].tiers == NO)
                            {
                                [layer setTileGID:[layer tileGIDAt:p] + 10 at:p];
                                [layer unitAt:p].tiers = YES;
                            }
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

@end