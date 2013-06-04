//
//  ConstructLayer.m
//  optimum
//
//  Created by REY Morgan on 01/06/13.
//  Copyright 2013 __MyCompanyName__. All rights reserved.
//

#import "ConstructLayer.h"


@implementation ConstructLayer

+(CCScene *) scene
{
	// 'scene' is an autorelease object.
	CCScene *scene = [CCScene node];
	
	// 'layer' is an autorelease object.
	ConstructLayer *layer = [ConstructLayer node];
	
	// add layer as a child to scene
	[scene addChild: layer];
	
	// return the scene
	return scene;
}

+(CCScene *) scene2
{
	// 'scene' is an autorelease object.
	CCScene *scene2 = [CCScene node];
	
	// 'layer' is an autorelease object.
	ConstructLayer *layer2 = [ConstructLayer node];
	
	// add layer as a child to scene
	[scene2 addChild: layer2];
	
	// return the scene
	return scene2;
}

// On surchage CCScene en lui indiquant les paramètres à passer
+ (CCScene *) sceneWithGameObject:(Game*)gameObject
{
    // 'scene' is an autorelease object.
	CCScene *scene = [CCScene node];
	
	// On indique quel node (initialiseur) à utiliser
    // en lui passant les paramètres les mêmes que dans scene
	ConstructLayer *layer = [ConstructLayer nodeWithGameObject:gameObject];
	
	// add layer as a child to scene
	[scene addChild: layer];
	
	// return the scene
	return scene;
}

+ (CCScene *) sceneWithGameObject2:(Game*)gameObject
{
    // 'scene' is an autorelease object.
	CCScene *scene2 = [CCScene node];
	
	// On indique quel node (initialiseur) à utiliser
    // en lui passant les paramètres les mêmes que dans scene
	ConstructLayer *layer2 = [ConstructLayer nodeWithGameObject2:gameObject];
	
	// add layer as a child to scene
	[scene2 addChild: layer2];
	
	// return the scene
	return scene2;
}

// le node indique quel initialisateur est à utiliser
+ (id) nodeWithGameObject:(Game*)gameObject
{
    return [[self alloc] initWithGameObject:(Game*)gameObject];
}

+ (id) nodeWithGameObject2:(Game*)gameObject
{
    return [[self alloc] initWithGameObject2:(Game*)gameObject];
}

// Ville
- (id) initWithGameObject:(Game*)gameObject
{
    if( (self=[super init]) )
    {
        //Notifications
        //Gestion du lâcher de ressource
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(optimumRelease:)
                                                     name:@"optimumRessourceConstructEnd"
                                                   object:nil];
        //Gestion du déplacement de ressource
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(optimumMove:)
                                                     name:@"optimumRessourceConstructMove"
                                                   object:nil];
        
        //Gestion du du lâcher de ressource
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(unitBuiltEnd:)
                                                     name:@"unitBuiltEnd"
                                                   object:nil];
        
        team = NO;
        gameElement = gameObject;
        CCSpriteFrameCache* frameCache = [CCSpriteFrameCache sharedSpriteFrameCache];
        [frameCache addSpriteFramesWithFile:@"Chaudron_ville.plist"];
        cauldronContent = [[NSCountedSet alloc] init];
        
        
        // Recettes
        unitLevelOneRecipe = [[NSCountedSet alloc] initWithObjects:
                                                [NSNumber numberWithInt:2],
                                                [NSNumber numberWithInt:2],
                                                [NSNumber numberWithInt:2],
                              nil];
        
        unitLevelTwoRecipe = [[NSCountedSet alloc] initWithObjects:
                                                [NSNumber numberWithInt:0],
                                                [NSNumber numberWithInt:2],
                                                [NSNumber numberWithInt:2],
                              nil];
        
        unitLevelThreeRecipe = [[NSCountedSet alloc] initWithObjects:
                                                [NSNumber numberWithInt:0],
                                                [NSNumber numberWithInt:1],
                                                [NSNumber numberWithInt:2],
                              nil];
        
        unitLevelFourRecipe = [[NSCountedSet alloc] initWithObjects:
                                                [NSNumber numberWithInt:0],
                                                [NSNumber numberWithInt:0],
                                                [NSNumber numberWithInt:1],
                                                [NSNumber numberWithInt:2],
                                                [NSNumber numberWithInt:2],
                                                [NSNumber numberWithInt:2],
                              nil];
        
        unitLevelFiveRecipe = [[NSCountedSet alloc] initWithObjects:
                                                [NSNumber numberWithInt:0],
                                                [NSNumber numberWithInt:0],
                                                [NSNumber numberWithInt:0],
                                                [NSNumber numberWithInt:1],
                                                [NSNumber numberWithInt:1],
                                                [NSNumber numberWithInt:1],
                                                [NSNumber numberWithInt:2],
                                                [NSNumber numberWithInt:2],
                                                [NSNumber numberWithInt:2],
                                                [NSNumber numberWithInt:2],
                                                [NSNumber numberWithInt:2],
                              nil];
        
        //Ressources dans le Chaudron
        redResource = 3;
        grayResource = 5;
        greenResource = 7;
        
        redResourceInCauldron = 0;
        grayResourceInCauldron = 0;
        greenResourceInCauldron = 0;
        
        self.isAccelerometerEnabled = YES;
        [[UIAccelerometer sharedAccelerometer] setUpdateInterval:1/60];
        
        
        if( UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone )
        {
            if ([[UIScreen mainScreen] bounds].size.height == 568)
            {
                // IPHONE 5
                // ask director for the window size
                CGSize size = [[CCDirector sharedDirector] winSize];
                
                //Background
                CCSprite *background = [CCSprite spriteWithFile:@"background_01_iPhone5.jpg"];
                [background setPosition:ccp(size.width/2, size.height/2)];
                
                [self addChild:background];
                
                //book ville
                CCSprite *bookVille = [CCSprite spriteWithSpriteFrameName:@"book_Ville.png"];
                bookVille.anchorPoint = ccp(0, 1);
                [bookVille setPosition:ccp(0, size.height)];
                
                [self addChild:bookVille];
                
                //Chaudron
                CCSprite *chaudron = [CCSprite spriteWithSpriteFrameName:@"chaudron_ville.png"];
                [chaudron setPosition:ccp(size.width/2, size.height/2 - 40)];
                chaudron.tag = chaudronTag;
                [self addChild:chaudron];
                
                //Envoi Ipad
                CCSprite *envoiIpad = [CCSprite spriteWithSpriteFrameName:@"envoi_iPad.png"];
                envoiIpad.tag = unitToiPad;
                [envoiIpad setPosition:ccp(size.width/2 + 118, size.height/2 - 243)];
                
                [self addChild:envoiIpad];
                
                //Bouton annuler
                CCMenuItemSprite *cancel = [CCMenuItemSprite
                                                itemWithNormalSprite:[CCSprite spriteWithSpriteFrameName:@"btn_supp.png"]
                                                selectedSprite:[CCSprite spriteWithSpriteFrameName:@"btn_supp.png"]
                                                target:self
                                                selector:@selector(cancelCauldronContent:)];
                
                CCMenu *menu_back = [CCMenu menuWithItems:cancel, nil];
                [menu_back setPosition:ccp(size.width/2, size.height/2 - 266)];
                
                // Add the menu to the layer
                [self addChild:menu_back];
                
                // Ressource verte complete
                CCSprite *ressourceVerteFull = [CCSprite spriteWithSpriteFrameName:@"ressource_bis_vert.png"];
                [ressourceVerteFull setPosition:ccp(size.width/2 + 113 , size.height/2 + 92 )];
                
                [self addChild:ressourceVerteFull];
                
                
                OptimumRessourceConstruct *ressourceVerteDrag = [[OptimumRessourceConstruct alloc]
                                                                 initWithRessourceType:0
                                                                 atPosition:ccp(size.width/2 + 113 , size.height/2 + 92 )
                                                                 forTeam:NO];
                ressourceVerteDrag.units = greenResource;
                [self addChild:ressourceVerteDrag];
                
                CCSprite *pastilleVerte = [CCSprite spriteWithSpriteFrameName:@"pastille_vert.png"];
                [pastilleVerte setPosition:ccp(size.width/2 + 92 , size.height/2 + 115 )];
                
                [self addChild:pastilleVerte];
                
                // Ressource grise complete
                CCSprite *ressourceGriseFull = [CCSprite spriteWithSpriteFrameName:@"ressource_bis_gris.png"];
                [ressourceGriseFull setPosition:ccp(size.width/2 - 113 , size.height/2 + 92 )];
                
                [self addChild:ressourceGriseFull];
            
                
                OptimumRessourceConstruct *ressourceGriseDrag = [[OptimumRessourceConstruct alloc]
                                                                 initWithRessourceType:1
                                                                 atPosition:ccp(size.width/2 - 113 , size.height/2 + 92 )
                                                                 forTeam:NO];
                ressourceGriseDrag.units = grayResource;
                [self addChild:ressourceGriseDrag];
                
                CCSprite *pastilleGrise = [CCSprite spriteWithSpriteFrameName:@"pastille_gris.png"];
                [pastilleGrise setPosition:ccp(size.width/2 - 88 , size.height/2 + 111 )];
                
                [self addChild:pastilleGrise];
                
                // Ressource rouge complete
                CCSprite *ressourceRougeFull = [CCSprite spriteWithSpriteFrameName:@"ressource_bis_rouge.png"];
                [ressourceRougeFull setPosition:ccp(size.width/2 - 113 , size.height/2 - 170 )];
                
                [self addChild:ressourceRougeFull];
                
                OptimumRessourceConstruct *ressourceRougeDrag = [[OptimumRessourceConstruct alloc]
                                                                initWithRessourceType:2
                                                                atPosition:ccp(size.width/2 - 113 , size.height/2 - 170 )
                                                                forTeam:NO];
                ressourceRougeDrag.units = redResource;
                [self addChild:ressourceRougeDrag];
                
                CCSprite *pastilleRouge = [CCSprite spriteWithSpriteFrameName:@"pastille_rouge.png"];
                [pastilleRouge setPosition:ccp(size.width/2 - 90 , size.height/2 - 192 )];
                
                [self addChild:pastilleRouge];
                
                // Points pour ressource verte
                CCSprite *point1Vert = [CCSprite spriteWithSpriteFrameName:@"point_01.png"];
                [point1Vert setPosition:ccp(size.width/2 + 87 , size.height/2 + 65 )];
                
                [self addChild:point1Vert];
                
                CCSprite *point2Vert = [CCSprite spriteWithSpriteFrameName:@"point_02.png"];
                [point2Vert setPosition:ccp(size.width/2 + 80 , size.height/2 + 57 )];
                
                [self addChild:point2Vert];
                
                CCSprite *point3Vert = [CCSprite spriteWithSpriteFrameName:@"point_03.png"];
                [point3Vert setPosition:ccp(size.width/2 + 73 , size.height/2 + 49 )];
                
                [self addChild:point3Vert];
                
                // Points pour ressource grise
                CCSprite *point1Gris = [CCSprite spriteWithSpriteFrameName:@"point_01.png"];
                [point1Gris setPosition:ccp(size.width/2 - 91 , size.height/2 + 62 )];
                
                [self addChild:point1Gris];
                
                CCSprite *point2Gris = [CCSprite spriteWithSpriteFrameName:@"point_02.png"];
                [point2Gris setPosition:ccp(size.width/2 - 84 , size.height/2 + 54 )];
                
                [self addChild:point2Gris];
                
                CCSprite *point3Gris = [CCSprite spriteWithSpriteFrameName:@"point_03.png"];
                [point3Gris setPosition:ccp(size.width/2 - 77 , size.height/2 + 46 )];
                
                [self addChild:point3Gris];
                
                // Points pour ressource rouge
                CCSprite *point1Rouge = [CCSprite spriteWithSpriteFrameName:@"point_01.png"];
                [point1Rouge setPosition:ccp(size.width/2 - 89 , size.height/2 - 140 )];
                
                [self addChild:point1Rouge];
                
                CCSprite *point2Rouge = [CCSprite spriteWithSpriteFrameName:@"point_02.png"];
                [point2Rouge setPosition:ccp(size.width/2 - 82 , size.height/2 - 132 )];
                
                [self addChild:point2Rouge];
                
                CCSprite *point3Rouge = [CCSprite spriteWithSpriteFrameName:@"point_03.png"];
                [point3Rouge setPosition:ccp(size.width/2 - 75 , size.height/2 - 124 )];
                
                [self addChild:point3Rouge];
                
                // Gestion des labels
                
                CGSize labelRessourceSize = CGSizeMake(8, 24);
                CGSize labelRessourceInCauldronSize = CGSizeMake(8, 24);
                //Hors chaudron
                redResourceLabel.contentSize = labelRessourceSize;
                redResourceLabel = [[CCLabelAtlas alloc] initWithString:[NSString stringWithFormat:@"%i", redResource]
                                                            charMapFile:@"number_unit_big_rouge.png"
                                                              itemWidth:7
                                                             itemHeight:12
                                                           startCharMap:'.'];
                redResourceLabel.anchorPoint = ccp(.5, .5);
                redResourceLabel.position = pastilleRouge.position;
                [self addChild:redResourceLabel];
                
                grayResourceLabel.contentSize = labelRessourceSize;
                grayResourceLabel = [[CCLabelAtlas alloc] initWithString:[NSString stringWithFormat:@"%i", grayResource]
                                                             charMapFile:@"number_unit_big_gris.png"
                                                               itemWidth:7
                                                              itemHeight:12
                                                            startCharMap:'.'];
                grayResourceLabel.anchorPoint = ccp(.5, .5);
                grayResourceLabel.position = pastilleGrise.position;
                [self addChild:grayResourceLabel];
                
                greenResourceLabel.contentSize = labelRessourceSize;
                greenResourceLabel = [[CCLabelAtlas alloc] initWithString:[NSString stringWithFormat:@"%i", greenResource]
                                                              charMapFile:@"number_unit_big_vert.png"
                                                                itemWidth:7
                                                               itemHeight:12
                                                             startCharMap:'.'];
                greenResourceLabel.anchorPoint = ccp(.5, .5);
                greenResourceLabel.position = pastilleVerte.position;
                [self addChild:greenResourceLabel];
                
                //In chaudron
                //ROUGE
                redResourceInCauldronLabel.contentSize = labelRessourceInCauldronSize;
                redResourceInCauldronLabel = [[CCLabelAtlas alloc] initWithString:[NSString stringWithFormat:@"%i", redResourceInCauldron]
                                                                      charMapFile:@"number_unit_small_rouge.png"
                                                                        itemWidth:8
                                                                       itemHeight:11
                                                                     startCharMap:'.'];
                redResourceInCauldronLabel.anchorPoint = ccp(.5, .5);
                redResourceInCauldronLabel.position = ccpAdd(pastilleRouge.position, ccp(26, 80));
                [self addChild:redResourceInCauldronLabel];
                
                //GRISE
                grayResourceInCauldronLabel.contentSize = labelRessourceInCauldronSize;
                grayResourceInCauldronLabel = [[CCLabelAtlas alloc] initWithString:[NSString stringWithFormat:@"%i", grayResourceInCauldron]
                                                                       charMapFile:@"number_unit_small_gris.png"
                                                                         itemWidth:8
                                                                        itemHeight:11
                                                                      startCharMap:'.'];
                grayResourceInCauldronLabel.anchorPoint = ccp(.5, .5);
                grayResourceInCauldronLabel.position = ccpAdd(pastilleGrise.position, ccp(23, -79));
                [self addChild:grayResourceInCauldronLabel];
                
                //VERT
                greenResourceInCauldronLabel.contentSize = labelRessourceInCauldronSize;
                greenResourceInCauldronLabel = [[CCLabelAtlas alloc] initWithString:[NSString stringWithFormat:@"%i", greenResourceInCauldron]
                                                                        charMapFile:@"number_unit_small_vert.png"
                                                                          itemWidth:8
                                                                         itemHeight:11
                                                                       startCharMap:'.'];
                greenResourceInCauldronLabel.anchorPoint = ccp(.5, .5);
                greenResourceInCauldronLabel.position = ccpAdd(pastilleVerte.position, ccp(-31, -79));
                [self addChild:greenResourceInCauldronLabel];
                
            }
            else
            {
                // IPHONE RETINA SCREEN
                CGSize size = [[CCDirector sharedDirector] winSize];
                
                //Background
                CCSprite *background = [CCSprite spriteWithFile:@"background_01.jpg"];
                [background setPosition:ccp(size.width/2, size.height/2)];
                
                [self addChild:background];
                
                //book ville
                CCSprite *bookVille = [CCSprite spriteWithSpriteFrameName:@"book_Ville.png"];
                bookVille.anchorPoint = ccp(0, 1);
                [bookVille setPosition:ccp(0, size.height)];
                
                [self addChild:bookVille];
                
                //Chaudron
                CCSprite *chaudron = [CCSprite spriteWithSpriteFrameName:@"chaudron_ville.png"];
                [chaudron setPosition:ccp(size.width/2, size.height/2 - 50)];
                chaudron.tag = chaudronTag;
                [self addChild:chaudron];
                
                //Envoi Ipad
                CCSprite *envoiIpad = [CCSprite spriteWithSpriteFrameName:@"envoi_iPad.png"];
                envoiIpad.tag = unitToiPad;
                [envoiIpad setPosition:ccp(size.width/2 + 118, size.height/2 - 203)];
                
                [self addChild:envoiIpad];
                
                //Bouton annuler
                CCMenuItemSprite *cancel = [CCMenuItemSprite
                                            itemWithNormalSprite:[CCSprite spriteWithSpriteFrameName:@"btn_supp.png"]
                                            selectedSprite:[CCSprite spriteWithSpriteFrameName:@"btn_supp.png"]
                                            target:self
                                            selector:@selector(cancelCauldronContent:)];
                
                CCMenu *menu_back = [CCMenu menuWithItems:cancel, nil];
                [menu_back setPosition:ccp(size.width/2, 18)];
                
                // Add the menu to the layer
                [self addChild:menu_back];
                
                
                // Ressource verte complete
                CCSprite *ressourceVerteFull = [CCSprite spriteWithSpriteFrameName:@"ressource_bis_vert.png"];
                [ressourceVerteFull setPosition:ccp(size.width/2 + 113 , size.height/2 + 82 )];
                
                [self addChild:ressourceVerteFull];
                
                
                OptimumRessourceConstruct *resourceVerteDrag = [[OptimumRessourceConstruct alloc]
                                                                 initWithRessourceType:0
                                                                 atPosition:ccp(size.width/2 + 113 , size.height/2 + 82 )
                                                                 forTeam:NO];
                resourceVerteDrag.units = greenResource;
                [self addChild:resourceVerteDrag];
                
                
                CCSprite *pastilleVerte = [CCSprite spriteWithSpriteFrameName:@"pastille_vert.png"];
                [pastilleVerte setPosition:ccp(size.width/2 + 92 , size.height/2 + 105 )];
                
                [self addChild:pastilleVerte];
                
                // Ressource grise complete
                CCSprite *ressourceGriseFull = [CCSprite spriteWithSpriteFrameName:@"ressource_bis_gris.png"];
                [ressourceGriseFull setPosition:ccp(size.width/2 - 113 , size.height/2 + 82 )];
                
                [self addChild:ressourceGriseFull];
            
    
                
                OptimumRessourceConstruct *ressourceGriseDrag = [[OptimumRessourceConstruct alloc]
                                                                 initWithRessourceType:1
                                                                 atPosition:ccp(size.width/2 - 113 , size.height/2 + 82 )
                                                                 forTeam:NO];
                ressourceGriseDrag.units = grayResource;
                [self addChild:ressourceGriseDrag];
                
                
                CCSprite *pastilleGrise = [CCSprite spriteWithSpriteFrameName:@"pastille_gris.png"];
                [pastilleGrise setPosition:ccp(size.width/2 - 88 , size.height/2 + 101 )];
                
                [self addChild:pastilleGrise];
                
                // Ressource rouge complete
                CCSprite *ressourceRougeFull = [CCSprite spriteWithSpriteFrameName:@"ressource_bis_rouge.png"];
                [ressourceRougeFull setPosition:ccp(size.width/2 - 113 , size.height/2 - 180 )];
                
                [self addChild:ressourceRougeFull];
 
                
                OptimumRessourceConstruct *ressourceRougeDrag = [[OptimumRessourceConstruct alloc]
                                                                 initWithRessourceType:2
                                                                 atPosition:ccp(size.width/2 - 113 , size.height/2 - 180 )
                                                                 forTeam:NO];
                ressourceRougeDrag.units = redResource;
                [self addChild:ressourceRougeDrag];
                
                CCSprite *pastilleRouge = [CCSprite spriteWithSpriteFrameName:@"pastille_rouge.png"];
                [pastilleRouge setPosition:ccp(size.width/2 - 90 , size.height/2 - 202 )];
                
                [self addChild:pastilleRouge];
                
                // Points pour ressource verte
                CCSprite *point1Vert = [CCSprite spriteWithSpriteFrameName:@"point_01.png"];
                [point1Vert setPosition:ccp(size.width/2 + 87 , size.height/2 + 55 )];
                
                [self addChild:point1Vert];
                
                CCSprite *point2Vert = [CCSprite spriteWithSpriteFrameName:@"point_02.png"];
                [point2Vert setPosition:ccp(size.width/2 + 80 , size.height/2 + 47 )];
                
                [self addChild:point2Vert];
                
                CCSprite *point3Vert = [CCSprite spriteWithSpriteFrameName:@"point_03.png"];
                [point3Vert setPosition:ccp(size.width/2 + 73 , size.height/2 + 39 )];
                
                [self addChild:point3Vert];
                
                // Points pour ressource grise
                CCSprite *point1Gris = [CCSprite spriteWithSpriteFrameName:@"point_01.png"];
                [point1Gris setPosition:ccp(size.width/2 - 91 , size.height/2 + 52 )];
                
                [self addChild:point1Gris];
                
                CCSprite *point2Gris = [CCSprite spriteWithSpriteFrameName:@"point_02.png"];
                [point2Gris setPosition:ccp(size.width/2 - 84 , size.height/2 + 44 )];
                
                [self addChild:point2Gris];
                
                CCSprite *point3Gris = [CCSprite spriteWithSpriteFrameName:@"point_03.png"];
                [point3Gris setPosition:ccp(size.width/2 - 77 , size.height/2 + 36 )];
                
                [self addChild:point3Gris];
                
                // Points pour ressource rouge
                CCSprite *point1Rouge = [CCSprite spriteWithSpriteFrameName:@"point_01.png"];
                [point1Rouge setPosition:ccp(size.width/2 - 89 , size.height/2 - 150 )];
                
                [self addChild:point1Rouge];
                
                CCSprite *point2Rouge = [CCSprite spriteWithSpriteFrameName:@"point_02.png"];
                [point2Rouge setPosition:ccp(size.width/2 - 82 , size.height/2 - 142 )];
                
                [self addChild:point2Rouge];
                
                CCSprite *point3Rouge = [CCSprite spriteWithSpriteFrameName:@"point_03.png"];
                [point3Rouge setPosition:ccp(size.width/2 - 75 , size.height/2 - 134 )];
                
                [self addChild:point3Rouge];
                
                // Gestion des labels
                
                CGSize labelRessourceSize = CGSizeMake(8, 24);
                CGSize labelRessourceInCauldronSize = CGSizeMake(8, 24);
                //Hors chaudron
                redResourceLabel.contentSize = labelRessourceSize;
                redResourceLabel = [[CCLabelAtlas alloc] initWithString:[NSString stringWithFormat:@"%i", redResource]
                                           charMapFile:@"number_unit_big_rouge.png"
                                             itemWidth:7
                                            itemHeight:12
                                          startCharMap:'.'];
                redResourceLabel.anchorPoint = ccp(.5, .5);
                redResourceLabel.position = pastilleRouge.position;
                [self addChild:redResourceLabel];
                
                grayResourceLabel.contentSize = labelRessourceSize;
                grayResourceLabel = [[CCLabelAtlas alloc] initWithString:[NSString stringWithFormat:@"%i", grayResource]
                                                             charMapFile:@"number_unit_big_gris.png"
                                                               itemWidth:7
                                                              itemHeight:12
                                                            startCharMap:'.'];
                grayResourceLabel.anchorPoint = ccp(.5, .5);
                grayResourceLabel.position = pastilleGrise.position;
                [self addChild:grayResourceLabel];
                
                greenResourceLabel.contentSize = labelRessourceSize;
                greenResourceLabel = [[CCLabelAtlas alloc] initWithString:[NSString stringWithFormat:@"%i", greenResource]
                                                              charMapFile:@"number_unit_big_vert.png"
                                                                itemWidth:7
                                                               itemHeight:12
                                                             startCharMap:'.'];
                greenResourceLabel.anchorPoint = ccp(.5, .5);
                greenResourceLabel.position = pastilleVerte.position;
                [self addChild:greenResourceLabel];
                
                //In chaudron
                //ROUGE
                redResourceInCauldronLabel.contentSize = labelRessourceInCauldronSize;
                redResourceInCauldronLabel = [[CCLabelAtlas alloc] initWithString:[NSString stringWithFormat:@"%i", redResourceInCauldron]
                                                                      charMapFile:@"number_unit_small_rouge.png"
                                                                        itemWidth:8
                                                                       itemHeight:11
                                                                     startCharMap:'.'];
                redResourceInCauldronLabel.anchorPoint = ccp(.5, .5);
                redResourceInCauldronLabel.position = ccpAdd(pastilleRouge.position, ccp(26, 80));
                [self addChild:redResourceInCauldronLabel];
                
                //GRISE
                grayResourceInCauldronLabel.contentSize = labelRessourceInCauldronSize;
                grayResourceInCauldronLabel = [[CCLabelAtlas alloc] initWithString:[NSString stringWithFormat:@"%i", grayResourceInCauldron]
                                                                       charMapFile:@"number_unit_small_gris.png"
                                                                         itemWidth:8
                                                                        itemHeight:11
                                                                      startCharMap:'.'];
                grayResourceInCauldronLabel.anchorPoint = ccp(.5, .5);
                grayResourceInCauldronLabel.position = ccpAdd(pastilleGrise.position, ccp(23, -79));
                [self addChild:grayResourceInCauldronLabel];
                
                //VERT
                greenResourceInCauldronLabel.contentSize = labelRessourceInCauldronSize;
                greenResourceInCauldronLabel = [[CCLabelAtlas alloc] initWithString:[NSString stringWithFormat:@"%i", greenResourceInCauldron]
                                                                        charMapFile:@"number_unit_small_vert.png"
                                                                          itemWidth:8
                                                                         itemHeight:11
                                                                       startCharMap:'.'];
                greenResourceInCauldronLabel.anchorPoint = ccp(.5, .5);
                greenResourceInCauldronLabel.position = ccpAdd(pastilleVerte.position, ccp(-31, -79));
                [self addChild:greenResourceInCauldronLabel];
                
            }
        }
		
        
    }
	return self;
}

//Nature
- (id) initWithGameObject2:(Game*)gameObject
{
    if( (self=[super init]) )
    {
        //Notifications
        //Gestion du lâcher d'unité
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(optimumRelease:)
                                                     name:@"optimumRessourceConstructEnd"
                                                   object:nil];
        //Gestion du déplacement d'unité
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(optimumMove:)
                                                     name:@"optimumRessourceConstructMove"
                                                   object:nil];
        
        //Gestion du du lâcher de ressource
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(unitBuiltEnd:)
                                                     name:@"unitBuiltEnd"
                                                   object:nil];
        
        team = YES;
        gameElement = gameObject;
        CCSpriteFrameCache* frameCache = [CCSpriteFrameCache sharedSpriteFrameCache];
        [frameCache addSpriteFramesWithFile:@"Chaudron_nature.plist"];
        cauldronContent = [[NSCountedSet alloc] init];
        
        
        // Recettes
        unitLevelOneRecipe = [[NSCountedSet alloc] initWithObjects:
                              [NSNumber numberWithInt:2],
                              [NSNumber numberWithInt:2],
                              [NSNumber numberWithInt:2],
                              nil];
        
        unitLevelTwoRecipe = [[NSCountedSet alloc] initWithObjects:
                              [NSNumber numberWithInt:0],
                              [NSNumber numberWithInt:0],
                              [NSNumber numberWithInt:2],
                              nil];
        
        unitLevelThreeRecipe = [[NSCountedSet alloc] initWithObjects:
                                [NSNumber numberWithInt:0],
                                [NSNumber numberWithInt:1],
                                [NSNumber numberWithInt:2],
                                nil];
        
        unitLevelFourRecipe = [[NSCountedSet alloc] initWithObjects:
                               [NSNumber numberWithInt:0],
                               [NSNumber numberWithInt:0],
                               [NSNumber numberWithInt:0],
                               [NSNumber numberWithInt:1],
                               [NSNumber numberWithInt:2],
                               [NSNumber numberWithInt:2],
                               nil];
        
        unitLevelFiveRecipe = [[NSCountedSet alloc] initWithObjects:
                               [NSNumber numberWithInt:0],
                               [NSNumber numberWithInt:0],
                               [NSNumber numberWithInt:0],
                               [NSNumber numberWithInt:0],
                               [NSNumber numberWithInt:0],
                               [NSNumber numberWithInt:1],
                               [NSNumber numberWithInt:1],
                               [NSNumber numberWithInt:1],
                               [NSNumber numberWithInt:2],
                               [NSNumber numberWithInt:2],
                               [NSNumber numberWithInt:2],
                               nil];
        
        //Ressources dans le Chaudron
        redResource = 3;
        grayResource = 5;
        greenResource = 7;
        
        redResourceInCauldron = 0;
        grayResourceInCauldron = 0;
        greenResourceInCauldron = 0;
        
        self.isAccelerometerEnabled = YES;
        [[UIAccelerometer sharedAccelerometer] setUpdateInterval:1/60];
        
        
        if( UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone )
        {
            if ([[UIScreen mainScreen] bounds].size.height == 568)
            {
                // IPHONE 5
                // ask director for the window size
                CGSize size = [[CCDirector sharedDirector] winSize];
                
                //Background
                CCSprite *background = [CCSprite spriteWithFile:@"background_01_iPhone5.jpg"];
                [background setPosition:ccp(size.width/2, size.height/2)];
                
                [self addChild:background];
                
                //book nature
                CCSprite *bookNature = [CCSprite spriteWithSpriteFrameName:@"book_nature.png"];
                bookNature.anchorPoint = ccp(0, 1);
                [bookNature setPosition:ccp(0, size.height)];
                
                [self addChild:bookNature];
                
                //Chaudron
                CCSprite *chaudron = [CCSprite spriteWithSpriteFrameName:@"chaudron_nature.png"];
                [chaudron setPosition:ccp(size.width/2, size.height/2 - 40)];
                chaudron.tag = chaudronTag;
                [self addChild:chaudron];
                
                //Envoi Ipad
                CCSprite *envoiIpad = [CCSprite spriteWithSpriteFrameName:@"envoi_iPad.png"];
                envoiIpad.tag = unitToiPad;
                [envoiIpad setPosition:ccp(size.width/2 - 118, size.height/2 - 243)];
                
                [self addChild:envoiIpad];
                
                //Bouton annuler
                CCMenuItemSprite *cancel = [CCMenuItemSprite
                                            itemWithNormalSprite:[CCSprite spriteWithSpriteFrameName:@"btn_supp.png"]
                                            selectedSprite:[CCSprite spriteWithSpriteFrameName:@"btn_supp.png"]
                                            target:self
                                            selector:@selector(cancelCauldronContent:)];
                
                CCMenu *menu_back = [CCMenu menuWithItems:cancel, nil];
                [menu_back setPosition:ccp(size.width/2, size.height/2 - 266)];
                
                // Add the menu to the layer
                [self addChild:menu_back];
                
                // Ressource verte complete
                CCSprite *ressourceVerteFull = [CCSprite spriteWithSpriteFrameName:@"ressource_bis_vert_nature.png"];
                [ressourceVerteFull setPosition:ccp(size.width/2 + 113 , size.height/2 - 169 )];
                
                [self addChild:ressourceVerteFull];
                
                OptimumRessourceConstruct *ressourceVerteDrag = [[OptimumRessourceConstruct alloc]
                                                                 initWithRessourceType:0
                                                                 atPosition:ccp(size.width/2 + 113 , size.height/2 - 169 )
                                                                 forTeam:YES];
                ressourceVerteDrag.units = greenResource;
                [self addChild:ressourceVerteDrag];
                
                CCSprite *pastilleVerte = [CCSprite spriteWithSpriteFrameName:@"pastille_vert.png"];
                [pastilleVerte setPosition:ccp(size.width/2 + 88 , size.height/2 - 189 )];
                
                [self addChild:pastilleVerte];
                
                // Ressource grise complete
                CCSprite *ressourceGriseFull = [CCSprite spriteWithSpriteFrameName:@"ressource_bis_gris_nature.png"];
                [ressourceGriseFull setPosition:ccp(size.width/2 + 113 , size.height/2 + 92 )];
                
                [self addChild:ressourceGriseFull];
                
                
                OptimumRessourceConstruct *ressourceGriseDrag = [[OptimumRessourceConstruct alloc]
                                                                 initWithRessourceType:1
                                                                 atPosition:ccp(size.width/2 + 113 , size.height/2 + 92 )
                                                                 forTeam:YES];
                ressourceGriseDrag.units = grayResource;
                [self addChild:ressourceGriseDrag];
                
                CCSprite *pastilleGrise = [CCSprite spriteWithSpriteFrameName:@"pastille_gris.png"];
                [pastilleGrise setPosition:ccp(size.width/2 +92, size.height/2 + 115 )];
                
                [self addChild:pastilleGrise];
                
                // Ressource rouge complete
                CCSprite *ressourceRougeFull = [CCSprite spriteWithSpriteFrameName:@"ressource_bis_rouge_nature.png"];
                [ressourceRougeFull setPosition:ccp(size.width/2 - 113 , size.height/2 + 92 )];
                
                [self addChild:ressourceRougeFull];
                
                
                OptimumRessourceConstruct *ressourceRougeDrag = [[OptimumRessourceConstruct alloc]
                                                                initWithRessourceType:2
                                                                atPosition:ccp(size.width/2 - 113 , size.height/2 +92 )
                                                                forTeam:YES];
                ressourceRougeDrag.units = redResource;
                [self addChild:ressourceRougeDrag];
                
                CCSprite *pastilleRouge = [CCSprite spriteWithSpriteFrameName:@"pastille_rouge.png"];
                [pastilleRouge setPosition:ccp(size.width/2 - 88 , size.height/2 + 111 )];
                
                [self addChild:pastilleRouge];
                
                // Points pour ressource verte
                CCSprite *point1Vert = [CCSprite spriteWithSpriteFrameName:@"point_01.png"];
                [point1Vert setPosition:ccp(size.width/2 + 89 , size.height/2 - 140 )];
                
                [self addChild:point1Vert];
                
                CCSprite *point2Vert = [CCSprite spriteWithSpriteFrameName:@"point_02.png"];
                [point2Vert setPosition:ccp(size.width/2 + 82 , size.height/2 - 132 )];
                
                [self addChild:point2Vert];
                
                CCSprite *point3Vert = [CCSprite spriteWithSpriteFrameName:@"point_03.png"];
                [point3Vert setPosition:ccp(size.width/2 + 75 , size.height/2 - 124 )];
                
                [self addChild:point3Vert];
                
                // Points pour ressource rouge
                CCSprite *point1Rouge = [CCSprite spriteWithSpriteFrameName:@"point_01.png"];
                [point1Rouge setPosition:ccp(size.width/2 - 91 , size.height/2 + 62 )];
                
                [self addChild:point1Rouge];
                
                CCSprite *point2Rouge = [CCSprite spriteWithSpriteFrameName:@"point_02.png"];
                [point2Rouge setPosition:ccp(size.width/2 - 84 , size.height/2 + 54 )];
                
                [self addChild:point2Rouge];
                
                CCSprite *point3Rouge = [CCSprite spriteWithSpriteFrameName:@"point_03.png"];
                [point3Rouge setPosition:ccp(size.width/2 - 77 , size.height/2 + 46 )];
                
                [self addChild:point3Rouge];
                
                // Points pour ressource grise
                CCSprite *point1Gris = [CCSprite spriteWithSpriteFrameName:@"point_01.png"];
                [point1Gris setPosition:ccp(size.width/2 + 87 , size.height/2 + 65 )];
                
                [self addChild:point1Gris];
                
                CCSprite *point2Gris = [CCSprite spriteWithSpriteFrameName:@"point_02.png"];
                [point2Gris setPosition:ccp(size.width/2 + 80 , size.height/2 + 57 )];
                
                [self addChild:point2Gris];
                
                CCSprite *point3Gris = [CCSprite spriteWithSpriteFrameName:@"point_03.png"];
                [point3Gris setPosition:ccp(size.width/2 + 73 , size.height/2 + 49 )];
                
                [self addChild:point3Gris];
                
                // Gestion des labels
                
                CGSize labelRessourceSize = CGSizeMake(8, 24);
                CGSize labelRessourceInCauldronSize = CGSizeMake(8, 24);
                //Hors chaudron
                redResourceLabel.contentSize = labelRessourceSize;
                redResourceLabel = [[CCLabelAtlas alloc] initWithString:[NSString stringWithFormat:@"%i", redResource]
                                                            charMapFile:@"number_unit_big_rouge.png"
                                                              itemWidth:7
                                                             itemHeight:12
                                                           startCharMap:'.'];
                redResourceLabel.anchorPoint = ccp(.5, .5);
                redResourceLabel.position = pastilleRouge.position;
                [self addChild:redResourceLabel];
                
                grayResourceLabel.contentSize = labelRessourceSize;
                grayResourceLabel = [[CCLabelAtlas alloc] initWithString:[NSString stringWithFormat:@"%i", grayResource]
                                                             charMapFile:@"number_unit_big_gris.png"
                                                               itemWidth:7
                                                              itemHeight:12
                                                            startCharMap:'.'];
                grayResourceLabel.anchorPoint = ccp(.5, .5);
                grayResourceLabel.position = pastilleGrise.position;
                [self addChild:grayResourceLabel];
                
                greenResourceLabel.contentSize = labelRessourceSize;
                greenResourceLabel = [[CCLabelAtlas alloc] initWithString:[NSString stringWithFormat:@"%i", greenResource]
                                                              charMapFile:@"number_unit_big_vert.png"
                                                                itemWidth:7
                                                               itemHeight:12
                                                             startCharMap:'.'];
                greenResourceLabel.anchorPoint = ccp(.5, .5);
                greenResourceLabel.position = pastilleVerte.position;
                [self addChild:greenResourceLabel];
                
                //In chaudron
                //ROUGE
                redResourceInCauldronLabel.contentSize = labelRessourceInCauldronSize;
                redResourceInCauldronLabel = [[CCLabelAtlas alloc] initWithString:[NSString stringWithFormat:@"%i", redResourceInCauldron]
                                                                      charMapFile:@"number_unit_small_rouge.png"
                                                                        itemWidth:8
                                                                       itemHeight:11
                                                                     startCharMap:'.'];
                redResourceInCauldronLabel.anchorPoint = ccp(.5, .5);
                redResourceInCauldronLabel.position = ccpAdd(pastilleRouge.position, ccp(26, 80));
                [self addChild:redResourceInCauldronLabel];
                
                //GRISE
                grayResourceInCauldronLabel.contentSize = labelRessourceInCauldronSize;
                grayResourceInCauldronLabel = [[CCLabelAtlas alloc] initWithString:[NSString stringWithFormat:@"%i", grayResourceInCauldron]
                                                                       charMapFile:@"number_unit_small_gris.png"
                                                                         itemWidth:8
                                                                        itemHeight:11
                                                                      startCharMap:'.'];
                grayResourceInCauldronLabel.anchorPoint = ccp(.5, .5);
                grayResourceInCauldronLabel.position = ccpAdd(pastilleGrise.position, ccp(23, -79));
                [self addChild:grayResourceInCauldronLabel];
                
                //VERT
                greenResourceInCauldronLabel.contentSize = labelRessourceInCauldronSize;
                greenResourceInCauldronLabel = [[CCLabelAtlas alloc] initWithString:[NSString stringWithFormat:@"%i", greenResourceInCauldron]
                                                                        charMapFile:@"number_unit_small_vert.png"
                                                                          itemWidth:8
                                                                         itemHeight:11
                                                                       startCharMap:'.'];
                greenResourceInCauldronLabel.anchorPoint = ccp(.5, .5);
                greenResourceInCauldronLabel.position = ccpAdd(pastilleVerte.position, ccp(-31, -79));
                [self addChild:greenResourceInCauldronLabel];
                
            }
            else
            {
                // IPHONE RETINA SCREEN
                // ask director for the window size
                CGSize size = [[CCDirector sharedDirector] winSize];
                
                //Background
                CCSprite *background = [CCSprite spriteWithFile:@"background_01_iPhone5.jpg"];
                [background setPosition:ccp(size.width/2, size.height/2)];
                
                [self addChild:background];
                
                //book nature
                CCSprite *bookNature = [CCSprite spriteWithSpriteFrameName:@"book_nature.png"];
                bookNature.anchorPoint = ccp(0, 1);
                [bookNature setPosition:ccp(0, size.height)];
                
                [self addChild:bookNature];
                
                //Chaudron
                CCSprite *chaudron = [CCSprite spriteWithSpriteFrameName:@"chaudron_nature.png"];
                [chaudron setPosition:ccp(size.width/2, size.height/2 - 50)];
                chaudron.tag = chaudronTag;
                [self addChild:chaudron];
                
                //Envoi Ipad
                CCSprite *envoiIpad = [CCSprite spriteWithSpriteFrameName:@"envoi_iPad.png"];
                envoiIpad.tag = unitToiPad;
                [envoiIpad setPosition:ccp(size.width/2 - 118, size.height/2 - 199)];
                
                [self addChild:envoiIpad];
                
                //Bouton annuler
                CCMenuItemSprite *cancel = [CCMenuItemSprite
                                            itemWithNormalSprite:[CCSprite spriteWithSpriteFrameName:@"btn_supp.png"]
                                            selectedSprite:[CCSprite spriteWithSpriteFrameName:@"btn_supp.png"]
                                            target:self
                                            selector:@selector(cancelCauldronContent:)];
                
                CCMenu *menu_back = [CCMenu menuWithItems:cancel, nil];
                [menu_back setPosition:ccp(size.width/2, size.height/2 - 223)];
                
                // Add the menu to the layer
                [self addChild:menu_back];
                
                // Ressource verte complete
                CCSprite *ressourceVerteFull = [CCSprite spriteWithSpriteFrameName:@"ressource_bis_vert_nature.png"];
                [ressourceVerteFull setPosition:ccp(size.width/2 + 113 , size.height/2 - 179 )];
                
                [self addChild:ressourceVerteFull];
                
                OptimumRessourceConstruct *ressourceVerteDrag = [[OptimumRessourceConstruct alloc]
                                                                 initWithRessourceType:0
                                                                 atPosition:ccp(size.width/2 + 113 , size.height/2 - 179 )
                                                                 forTeam:YES];
                ressourceVerteDrag.units = greenResource;
                [self addChild:ressourceVerteDrag];
                
                CCSprite *pastilleVerte = [CCSprite spriteWithSpriteFrameName:@"pastille_vert.png"];
                [pastilleVerte setPosition:ccp(size.width/2 + 88 , size.height/2 - 199 )];
                
                [self addChild:pastilleVerte];
                
                // Ressource grise complete
                CCSprite *ressourceGriseFull = [CCSprite spriteWithSpriteFrameName:@"ressource_bis_gris_nature.png"];
                [ressourceGriseFull setPosition:ccp(size.width/2 + 113 , size.height/2 + 82 )];
                
                [self addChild:ressourceGriseFull];
                
                
                OptimumRessourceConstruct *ressourceGriseDrag = [[OptimumRessourceConstruct alloc]
                                                                 initWithRessourceType:1
                                                                 atPosition:ccp(size.width/2 + 113 , size.height/2 + 82 )
                                                                 forTeam:YES];
                ressourceGriseDrag.units = grayResource;
                [self addChild:ressourceGriseDrag];
                
                CCSprite *pastilleGrise = [CCSprite spriteWithSpriteFrameName:@"pastille_gris.png"];
                [pastilleGrise setPosition:ccp(size.width/2 +92, size.height/2 + 105 )];
                
                [self addChild:pastilleGrise];
                
                // Ressource rouge complete
                CCSprite *ressourceRougeFull = [CCSprite spriteWithSpriteFrameName:@"ressource_bis_rouge_nature.png"];
                [ressourceRougeFull setPosition:ccp(size.width/2 - 113 , size.height/2 + 82 )];
                
                [self addChild:ressourceRougeFull];
                
                
                OptimumRessourceConstruct *ressourceRougeDrag = [[OptimumRessourceConstruct alloc]
                                                                 initWithRessourceType:2
                                                                 atPosition:ccp(size.width/2 - 113 , size.height/2 +82 )
                                                                 forTeam:YES];
                ressourceRougeDrag.units = redResource;
                [self addChild:ressourceRougeDrag];
                
                CCSprite *pastilleRouge = [CCSprite spriteWithSpriteFrameName:@"pastille_rouge.png"];
                [pastilleRouge setPosition:ccp(size.width/2 - 88 , size.height/2 + 101 )];
                
                [self addChild:pastilleRouge];
                
                // Points pour ressource verte
                CCSprite *point1Vert = [CCSprite spriteWithSpriteFrameName:@"point_01.png"];
                [point1Vert setPosition:ccp(size.width/2 + 89 , size.height/2 - 150 )];
                
                [self addChild:point1Vert];
                
                CCSprite *point2Vert = [CCSprite spriteWithSpriteFrameName:@"point_02.png"];
                [point2Vert setPosition:ccp(size.width/2 + 82 , size.height/2 - 142 )];
                
                [self addChild:point2Vert];
                
                CCSprite *point3Vert = [CCSprite spriteWithSpriteFrameName:@"point_03.png"];
                [point3Vert setPosition:ccp(size.width/2 + 75 , size.height/2 - 134 )];
                
                [self addChild:point3Vert];
                
                // Points pour ressource rouge
                CCSprite *point1Rouge = [CCSprite spriteWithSpriteFrameName:@"point_01.png"];
                [point1Rouge setPosition:ccp(size.width/2 - 91 , size.height/2 + 52 )];
                
                [self addChild:point1Rouge];
                
                CCSprite *point2Rouge = [CCSprite spriteWithSpriteFrameName:@"point_02.png"];
                [point2Rouge setPosition:ccp(size.width/2 - 84 , size.height/2 + 44 )];
                
                [self addChild:point2Rouge];
                
                CCSprite *point3Rouge = [CCSprite spriteWithSpriteFrameName:@"point_03.png"];
                [point3Rouge setPosition:ccp(size.width/2 - 77 , size.height/2 + 36 )];
                
                [self addChild:point3Rouge];
                
                // Points pour ressource grise
                CCSprite *point1Gris = [CCSprite spriteWithSpriteFrameName:@"point_01.png"];
                [point1Gris setPosition:ccp(size.width/2 + 87 , size.height/2 + 55 )];
                
                [self addChild:point1Gris];
                
                CCSprite *point2Gris = [CCSprite spriteWithSpriteFrameName:@"point_02.png"];
                [point2Gris setPosition:ccp(size.width/2 + 80 , size.height/2 + 47 )];
                
                [self addChild:point2Gris];
                
                CCSprite *point3Gris = [CCSprite spriteWithSpriteFrameName:@"point_03.png"];
                [point3Gris setPosition:ccp(size.width/2 + 73 , size.height/2 + 39 )];
                
                [self addChild:point3Gris];
                
                // Gestion des labels
                
                CGSize labelRessourceSize = CGSizeMake(8, 24);
                CGSize labelRessourceInCauldronSize = CGSizeMake(8, 24);
                //Hors chaudron
                redResourceLabel.contentSize = labelRessourceSize;
                redResourceLabel = [[CCLabelAtlas alloc] initWithString:[NSString stringWithFormat:@"%i", redResource]
                                                            charMapFile:@"number_unit_big_rouge.png"
                                                              itemWidth:7
                                                             itemHeight:12
                                                           startCharMap:'.'];
                redResourceLabel.anchorPoint = ccp(.5, .5);
                redResourceLabel.position = pastilleRouge.position;
                [self addChild:redResourceLabel];
                
                grayResourceLabel.contentSize = labelRessourceSize;
                grayResourceLabel = [[CCLabelAtlas alloc] initWithString:[NSString stringWithFormat:@"%i", grayResource]
                                                             charMapFile:@"number_unit_big_gris.png"
                                                               itemWidth:7
                                                              itemHeight:12
                                                            startCharMap:'.'];
                grayResourceLabel.anchorPoint = ccp(.5, .5);
                grayResourceLabel.position = pastilleGrise.position;
                [self addChild:grayResourceLabel];
                
                greenResourceLabel.contentSize = labelRessourceSize;
                greenResourceLabel = [[CCLabelAtlas alloc] initWithString:[NSString stringWithFormat:@"%i", greenResource]
                                                              charMapFile:@"number_unit_big_vert.png"
                                                                itemWidth:7
                                                               itemHeight:12
                                                             startCharMap:'.'];
                greenResourceLabel.anchorPoint = ccp(.5, .5);
                greenResourceLabel.position = pastilleVerte.position;
                [self addChild:greenResourceLabel];
                
                //In chaudron
                //ROUGE
                redResourceInCauldronLabel.contentSize = labelRessourceInCauldronSize;
                redResourceInCauldronLabel = [[CCLabelAtlas alloc] initWithString:[NSString stringWithFormat:@"%i", redResourceInCauldron]
                                                                      charMapFile:@"number_unit_small_rouge.png"
                                                                        itemWidth:8
                                                                       itemHeight:11
                                                                     startCharMap:'.'];
                redResourceInCauldronLabel.anchorPoint = ccp(.5, .5);
                redResourceInCauldronLabel.position = ccpAdd(pastilleRouge.position, ccp(26, 80));
                [self addChild:redResourceInCauldronLabel];
                
                //GRISE
                grayResourceInCauldronLabel.contentSize = labelRessourceInCauldronSize;
                grayResourceInCauldronLabel = [[CCLabelAtlas alloc] initWithString:[NSString stringWithFormat:@"%i", grayResourceInCauldron]
                                                                       charMapFile:@"number_unit_small_gris.png"
                                                                         itemWidth:8
                                                                        itemHeight:11
                                                                      startCharMap:'.'];
                grayResourceInCauldronLabel.anchorPoint = ccp(.5, .5);
                grayResourceInCauldronLabel.position = ccpAdd(pastilleGrise.position, ccp(23, -79));
                [self addChild:grayResourceInCauldronLabel];
                
                //VERT
                greenResourceInCauldronLabel.contentSize = labelRessourceInCauldronSize;
                greenResourceInCauldronLabel = [[CCLabelAtlas alloc] initWithString:[NSString stringWithFormat:@"%i", greenResourceInCauldron]
                                                                        charMapFile:@"number_unit_small_vert.png"
                                                                          itemWidth:8
                                                                         itemHeight:11
                                                                       startCharMap:'.'];
                greenResourceInCauldronLabel.anchorPoint = ccp(.5, .5);
                greenResourceInCauldronLabel.position = ccpAdd(pastilleVerte.position, ccp(-31, -79));
                [self addChild:greenResourceInCauldronLabel];
                
            }
        }
		
        
    }
	return self;
}

-(void) accelerometer:(UIAccelerometer *)accelerometer didAccelerate:(UIAcceleration *)acceleration {
    
    float THRESHOLD = 2;
    
    if (acceleration.x > THRESHOLD || acceleration.x < -THRESHOLD ||
        acceleration.y > THRESHOLD || acceleration.y < -THRESHOLD ||
        acceleration.z > THRESHOLD || acceleration.z < -THRESHOLD) {
        
        if (!shake_once) {
            shake_once = YES;
        }
        
        [cauldronContent removeAllObjects];
        
    }
    else {
        shake_once = NO;
    }
    
}

- (void) optimumRelease:(NSNotification *)notification
{
    // Permet de récupérer toutes les informations concernant la ressource relâchée
    NSInteger tag = [[[notification object] objectForKey:@"tag"] intValue];
    NSInteger type = [[[notification object] objectForKey:@"type"] intValue];
//    CGPoint touchLocation = [[[notification object] objectForKey:@"touchLocation"] CGPointValue];
    CGPoint initPosition = [[[notification object] objectForKey:@"initPosition"] CGPointValue];
    
    CCNode *cauldronNode = [self getChildByTag:chaudronTag];
	CCSprite *cauldron = (CCSprite*)cauldronNode;

    CCNode *optimumNode = [self getChildByTag:tag];
    OptimumRessourceConstruct *optimumRessource = (OptimumRessourceConstruct*)optimumNode;
    
    CCAction *back2InitPosition = [CCMoveTo actionWithDuration:.2f
                                                      position: ccp(initPosition.x, initPosition.y)];
    
    //  Faire retourner discrètement la ressource à sa position initiale lorsqu'elle est bien posée
    CCAction *backInitPosition = [CCMoveTo actionWithDuration:0
                                                     position: ccp(initPosition.x, initPosition.y)];
    
    UnitBuilt *unitBuilt;
    unitBuilt.tag = unitBuiltTag;
    
    if (CGRectContainsRect(cauldron.boundingBox, optimumRessource.boundingBox))
    {
        switch (optimumRessource._type) {
            // Ressource verte
            case 0:
                greenResource--;
                greenResourceInCauldron++;
                if (greenResource <= 0) { //Le nombre d'unités ne peut être inférieur à 0
                    greenResource = 0;
                }
                [greenResourceLabel setString:[NSString stringWithFormat:@"%d", greenResource]];
                [greenResourceInCauldronLabel setString:[NSString stringWithFormat:@"%d", greenResourceInCauldron]];
                break;
            // Ressource grise
            case 1:
                grayResource--;
                grayResourceInCauldron++;
                if (grayResource <= 0) { //Le nombre d'unités ne peut être inférieur à 0
                    grayResource = 0;
                }
                [grayResourceLabel setString:[NSString stringWithFormat:@"%d", grayResource]];
                [grayResourceInCauldronLabel setString:[NSString stringWithFormat:@"%d", grayResourceInCauldron]];
                break;
            // Ressource rouge
            case 2:
                redResource--;
                redResourceInCauldron++;
                if (redResource <= 0) { //Le nombre d'unités ne peut être inférieur à 0
                    redResource = 0;
                }
                [redResourceLabel setString:[NSString stringWithFormat:@"%d", redResource]];
                [redResourceInCauldronLabel setString:[NSString stringWithFormat:@"%d", redResourceInCauldron]];
                break;
                
            default:
                break;
        }
        
        [cauldronContent addObject:[NSNumber numberWithInt:type]];
        optimumRessource.units--;
        [optimumRessource runAction:backInitPosition];

        
        CGSize size = [[CCDirector sharedDirector] winSize];
        CGPoint unitContructPosition = ccp(size.width/2, size.height/2 - 15);
        
        
        // On vérifie que le contenu du chaudron n'est pas égal à une recette et que son contenu n'est pas supérieur à la recette
        if ([cauldronContent isEqualToSet:unitLevelOneRecipe] && [cauldronContent count] == [unitLevelOneRecipe count]) {
            [self removeChild:unitBuilt cleanup:YES];
            CCLOG(@"Level one !");
            
            if (team == YES) {
                unitBuilt = [[UnitBuilt alloc] initWithUnitLevel:1 atPosition:unitContructPosition ofTeam:YES];
            }else{
                unitBuilt = [[UnitBuilt alloc] initWithUnitLevel:1 atPosition:unitContructPosition ofTeam:NO];
            }

            [self addChild:unitBuilt];
        }else if([cauldronContent isEqualToSet:unitLevelTwoRecipe] && [cauldronContent count] == [unitLevelTwoRecipe count]) {
            [self removeChild:unitBuilt cleanup:YES];

            if (team == YES) {
                unitBuilt = [[UnitBuilt alloc] initWithUnitLevel:2 atPosition:unitContructPosition ofTeam:YES];
            }else{
                unitBuilt = [[UnitBuilt alloc] initWithUnitLevel:2 atPosition:unitContructPosition ofTeam:NO];
            }

            [self addChild:unitBuilt];
        }else if ([cauldronContent isEqualToSet:unitLevelThreeRecipe] && [cauldronContent count] == [unitLevelThreeRecipe count]) {
            [self removeChild:unitBuilt cleanup:YES];
            CCLOG(@"Level three !");

            if (team == YES) {
                unitBuilt = [[UnitBuilt alloc] initWithUnitLevel:3 atPosition:unitContructPosition ofTeam:YES];
            }else{
                unitBuilt = [[UnitBuilt alloc] initWithUnitLevel:3 atPosition:unitContructPosition ofTeam:NO];
            }

            [self addChild:unitBuilt];
        }else if ([cauldronContent isEqualToSet:unitLevelFourRecipe] && [cauldronContent count] == [unitLevelFourRecipe count]) {
            [self removeChild:unitBuilt cleanup:YES];

            if (team == YES) {
                unitBuilt = [[UnitBuilt alloc] initWithUnitLevel:4 atPosition:unitContructPosition ofTeam:YES];
            }else{
                unitBuilt = [[UnitBuilt alloc] initWithUnitLevel:4 atPosition:unitContructPosition ofTeam:NO];
            }

            [self addChild:unitBuilt];
        }else if ([cauldronContent isEqualToSet:unitLevelFiveRecipe] && [cauldronContent count] == [unitLevelFiveRecipe count]) {
            [self removeChild:unitBuilt cleanup:YES];
            CCLOG(@"Level five !");
            if (team == YES) {
                unitBuilt = [[UnitBuilt alloc] initWithUnitLevel:5 atPosition:unitContructPosition ofTeam:YES];
            }else{
                unitBuilt = [[UnitBuilt alloc] initWithUnitLevel:5 atPosition:unitContructPosition ofTeam:NO];
            }

            [self addChild:unitBuilt];
        }
    }else{
        [optimumRessource runAction:back2InitPosition];
    }
}

- (void) optimumMove:(NSNotification *)notification{}

- (void) cancelCauldronContent: (id) sender
{
    redResource += redResourceInCauldron;
    redResourceInCauldron = 0;
    [redResourceLabel setString:[NSString stringWithFormat:@"%d", redResource]];
    [redResourceInCauldronLabel setString:[NSString stringWithFormat:@"%d", redResourceInCauldron]];
    
    CCNode *optimumNodeRed = [self getChildByTag:84];
    OptimumRessourceConstruct *optimumResourceRed = (OptimumRessourceConstruct*)optimumNodeRed;
    optimumResourceRed.units = redResource;
    
    
    greenResource += greenResourceInCauldron;
    greenResourceInCauldron = 0;
    [greenResourceLabel setString:[NSString stringWithFormat:@"%d", greenResource]];
    [greenResourceInCauldronLabel setString:[NSString stringWithFormat:@"%d", greenResourceInCauldron]];
    
    CCNode *optimumNodeGreen = [self getChildByTag:0];
    OptimumRessourceConstruct *optimumResourceGreen = (OptimumRessourceConstruct*)optimumNodeGreen;
    optimumResourceGreen.units = greenResource;
    

    grayResource += grayResourceInCauldron;
    grayResourceInCauldron = 0;
    [grayResourceLabel setString:[NSString stringWithFormat:@"%d", grayResource]];
    [grayResourceInCauldronLabel setString:[NSString stringWithFormat:@"%d", grayResourceInCauldron]];
    
    CCNode *optimumNodeGray = [self getChildByTag:42];
    OptimumRessourceConstruct *optimumResourceGray = (OptimumRessourceConstruct*)optimumNodeGray;
    optimumResourceGray.units = grayResource;
    
    CCNode *unitBuiltNode = [self getChildByTag:unitBuiltTag];
	CCSprite *unitBuilt = (CCSprite*)unitBuiltNode;
    
    [self removeChild:unitBuilt cleanup:YES];
    
    [cauldronContent removeAllObjects];
}

- (void) unitBuiltEnd:(NSNotification *)notification
{
    NSInteger tag = [[[notification object] objectForKey:@"tag"] intValue];
//    NSInteger type = [[[notification object] objectForKey:@"type"] intValue];
    CGPoint touchLocation = [[[notification object] objectForKey:@"touchLocation"] CGPointValue];
    CGPoint initPosition = [[[notification object] objectForKey:@"initPosition"] CGPointValue];
    
    CCNode *unitBuiltNode = [self getChildByTag:tag];
    CCLOG(@"tag : %i", tag);
    UnitBuilt *unitBuilt = (UnitBuilt*)unitBuiltNode;
    
    CCNode *iPadSenderNode = [self getChildByTag:unitToiPad];
    CCSprite *iPadSender = (CCSprite*)iPadSenderNode;
    
    CCAction *back2InitPosition = [CCMoveTo actionWithDuration:.2f
                                            position: ccp(initPosition.x, initPosition.y)];
    
    
    if (CGRectContainsPoint(iPadSender.boundingBox, touchLocation))
    {
        // On envoit les données vers l'iPad
        
        //Le bâtiment disparait
        [self removeChild:unitBuilt cleanup:YES];
        
        //Il n'y a plus rien dans le chaudron
        [cauldronContent removeAllObjects];
        redResourceInCauldron = 0;
        [redResourceInCauldronLabel setString:[NSString stringWithFormat:@"%d", redResourceInCauldron]];
        
        greenResourceInCauldron = 0;
        [greenResourceInCauldronLabel setString:[NSString stringWithFormat:@"%d", greenResourceInCauldron]];
        
        grayResourceInCauldron = 0;
        [grayResourceInCauldronLabel setString:[NSString stringWithFormat:@"%d", grayResourceInCauldron]];
    }else{
        [unitBuilt runAction:back2InitPosition];
    }
}



@end
