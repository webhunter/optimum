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

// le node indique quel initialisateur est à utiliser
+ (id) nodeWithGameObject:(Game*)gameObject
{
    return [[self alloc] initWithGameObject:(Game*)gameObject];
}

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
        
        gameElement = gameObject;
        CCSpriteFrameCache* frameCache = [CCSpriteFrameCache sharedSpriteFrameCache];
        [frameCache addSpriteFramesWithFile:@"ConstructLayer.plist"];
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
        
        CCLOG(@"%@ %@ %@ %@ %@", unitLevelOneRecipe, unitLevelTwoRecipe, unitLevelThreeRecipe, unitLevelFourRecipe, unitLevelFiveRecipe);
        
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
                
                //Chaudron
                CCSprite *chaudron = [CCSprite spriteWithSpriteFrameName:@"chaudron.png"];
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
                
                for (int i = 0; i < 10; i++) {
                    OptimumRessourceConstruct *ressourceVerteDrag = [[OptimumRessourceConstruct alloc]
                                                                     initWithRessourceType:0
                                                                     atPosition:ccp(size.width/2 + 113 , size.height/2 + 92 )];
                    [self addChild:ressourceVerteDrag];
                }
                
                CCSprite *pastilleVerte = [CCSprite spriteWithSpriteFrameName:@"pastille_vert.png"];
                [pastilleVerte setPosition:ccp(size.width/2 + 92 , size.height/2 + 115 )];
                
                [self addChild:pastilleVerte];
                
                // Ressource grise complete
                CCSprite *ressourceGriseFull = [CCSprite spriteWithSpriteFrameName:@"ressource_bis_gris.png"];
                [ressourceGriseFull setPosition:ccp(size.width/2 - 113 , size.height/2 + 92 )];
                
                [self addChild:ressourceGriseFull];
                
                for (int i = 0; i < 10; i++) {
                    OptimumRessourceConstruct *ressourceGriseDrag = [[OptimumRessourceConstruct alloc]
                                                                     initWithRessourceType:1
                                                                     atPosition:ccp(size.width/2 - 113 , size.height/2 + 92 )];
                    [self addChild:ressourceGriseDrag];
                }
                
                CCSprite *pastilleGrise = [CCSprite spriteWithSpriteFrameName:@"pastille_gris.png"];
                [pastilleGrise setPosition:ccp(size.width/2 - 88 , size.height/2 + 111 )];
                
                [self addChild:pastilleGrise];
                
                // Ressource rouge complete
                CCSprite *ressourceRougeFull = [CCSprite spriteWithSpriteFrameName:@"ressource_bis_rouge.png"];
                [ressourceRougeFull setPosition:ccp(size.width/2 - 113 , size.height/2 - 170 )];
                
                [self addChild:ressourceRougeFull];
                
                for (int i = 0; i < 10; i++) {
                    OptimumRessourceConstruct *ressourceRougeDrag = [[OptimumRessourceConstruct alloc]
                                                                     initWithRessourceType:2
                                                                     atPosition:ccp(size.width/2 - 113 , size.height/2 - 170 )];
                    [self addChild:ressourceRougeDrag];
                }
                
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
                
            }
            else
            {
                // IPHONE RETINA SCREEN
                CGSize size = [[CCDirector sharedDirector] winSize];
                
                //Background
                CCSprite *background = [CCSprite spriteWithFile:@"background_01.jpg"];
                [background setPosition:ccp(size.width/2, size.height/2)];
                
                [self addChild:background];
                
                //Chaudron
                CCSprite *chaudron = [CCSprite spriteWithSpriteFrameName:@"chaudron.png"];
                [chaudron setPosition:ccp(size.width/2, size.height/2 - 40)];
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
                
                
                
                //Ressources dans le Chaudron
                redResource = 3;
                grayResource = 5;
                greenResource = 7;
                
                redResourceInCauldron = 0;
                grayResourceInCauldron = 0;
                greenResourceInCauldron = 0;

                
                // Ressource verte complete
                CCSprite *ressourceVerteFull = [CCSprite spriteWithSpriteFrameName:@"ressource_bis_vert.png"];
                [ressourceVerteFull setPosition:ccp(size.width/2 + 113 , size.height/2 + 92 )];
                
//                [self addChild:ressourceVerteFull];
                
                
                OptimumRessourceConstruct *resourceVerteDrag = [[OptimumRessourceConstruct alloc]
                                                                     initWithRessourceType:0
                                                                     atPosition:ccp(size.width/2 + 113 , size.height/2 + 92 )];
                resourceVerteDrag.units = greenResource;
                [self addChild:resourceVerteDrag];
                
                
                CCSprite *pastilleVerte = [CCSprite spriteWithSpriteFrameName:@"pastille_vert.png"];
                [pastilleVerte setPosition:ccp(size.width/2 + 92 , size.height/2 + 115 )];
                
                [self addChild:pastilleVerte];
                
                // Ressource grise complete
                CCSprite *ressourceGriseFull = [CCSprite spriteWithSpriteFrameName:@"ressource_bis_gris.png"];
                [ressourceGriseFull setPosition:ccp(size.width/2 - 113 , size.height/2 + 92 )];
                
                [self addChild:ressourceGriseFull];
            
            
                OptimumRessourceConstruct *ressourceGriseDrag = [[OptimumRessourceConstruct alloc]
                                                                     initWithRessourceType:1
                                                                     atPosition:ccp(size.width/2 - 113 , size.height/2 + 92 )];
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
                                                                     atPosition:ccp(size.width/2 - 113 , size.height/2 - 170 )];
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
                
                //Hors chaudron
                redResourceLabel = [[CCLabelTTF alloc] initWithString:[NSString stringWithFormat:@"%i", redResource]
                                                           dimensions:CGSizeMake(19, 19)
                                                           hAlignment:kCCTextAlignmentCenter
                                                             fontName:@"HelveticaNeue-CondensedBold"
                                                             fontSize:9];
                redResourceLabel.position = pastilleRouge.position;
                [self addChild:redResourceLabel];
                
                grayResourceLabel = [[CCLabelTTF alloc] initWithString:[NSString stringWithFormat:@"%i", grayResource]
                                                           dimensions:CGSizeMake(19, 19)
                                                           hAlignment:kCCTextAlignmentCenter
                                                             fontName:@"HelveticaNeue-CondensedBold"
                                                             fontSize:9];
                grayResourceLabel.position = pastilleGrise.position;
                [self addChild:grayResourceLabel];
                
                greenResourceLabel = [[CCLabelTTF alloc] initWithString:[NSString stringWithFormat:@"%i", greenResource]
                                                            dimensions:CGSizeMake(19, 19)
                                                            hAlignment:kCCTextAlignmentCenter
                                                              fontName:@"HelveticaNeue-CondensedBold"
                                                              fontSize:9];
                greenResourceLabel.position = pastilleVerte.position;
                [self addChild:greenResourceLabel];
                
                //In chaudron
                redResourceInCauldronLabel = [[CCLabelTTF alloc] initWithString:[NSString stringWithFormat:@"%i", redResourceInCauldron]
                                                           dimensions:CGSizeMake(19, 19)
                                                           hAlignment:kCCTextAlignmentCenter
                                                             fontName:@"HelveticaNeue-CondensedBold"
                                                             fontSize:9];
                redResourceInCauldronLabel.position = ccpAdd(pastilleRouge.position, ccp(26, 78));
                [self addChild:redResourceInCauldronLabel];
                
                grayResourceInCauldronLabel = [[CCLabelTTF alloc] initWithString:[NSString stringWithFormat:@"%i", grayResourceInCauldron]
                                                                  dimensions:CGSizeMake(19, 19)
                                                                  hAlignment:kCCTextAlignmentCenter
                                                                  fontName:@"HelveticaNeue-CondensedBold"
                                                                  fontSize:9];
                grayResourceInCauldronLabel.color = ccBLACK;
                grayResourceInCauldronLabel.position = ccpAdd(pastilleGrise.position, ccp(26, -78));
                [self addChild:grayResourceInCauldronLabel];
                
                greenResourceInCauldronLabel = [[CCLabelTTF alloc] initWithString:[NSString stringWithFormat:@"%i", greenResourceInCauldron]
                                                             dimensions:CGSizeMake(19, 19)
                                                             hAlignment:kCCTextAlignmentCenter
                                                               fontName:@"HelveticaNeue-CondensedBold"
                                                               fontSize:9];
                greenResourceInCauldronLabel.position = ccpAdd(pastilleVerte.position, ccp(26, -78));
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
        
        // On vérifie que le contenu du chaudron n'est pas égal à une recette et que son contenu n'est pas supérieur à la recette
        if ([cauldronContent isEqualToSet:unitLevelOneRecipe] && [cauldronContent count] == [unitLevelOneRecipe count]) {
            [self removeChild:unitBuilt cleanup:YES];
            CCLOG(@"Level one !");
//            unitBuilt = [CCSprite spriteWithSpriteFrameName:@"ressource_vert.png"];
//            unitBuilt = [CCSprite spriteWithFile:@"unit1.jpg"];
            unitBuilt = [[UnitBuilt alloc] initWithUnitLevel:1 atPosition:ccp(cauldron.position.x, cauldron.position.y) ofTeam:NO];
//            unitBuilt.position = ccp(cauldron.position.x, cauldron.position.y);
            [self addChild:unitBuilt];
        }else if([cauldronContent isEqualToSet:unitLevelTwoRecipe] && [cauldronContent count] == [unitLevelTwoRecipe count]) {
            [self removeChild:unitBuilt cleanup:YES];
            CCLOG(@"Level two !");
//            unitBuilt = [CCSprite spriteWithFile:@"unit2.jpg"];
//            unitBuilt = [CCSprite spriteWithSpriteFrameName:@"ressource_rouge.png"];
            unitBuilt = [[UnitBuilt alloc] initWithUnitLevel:2 atPosition:ccp(cauldron.position.x, cauldron.position.y) ofTeam:NO];

            [self addChild:unitBuilt];
        }else if ([cauldronContent isEqualToSet:unitLevelThreeRecipe] && [cauldronContent count] == [unitLevelThreeRecipe count]) {
            [self removeChild:unitBuilt cleanup:YES];
            CCLOG(@"Level three !");
//            unitBuilt = [CCSprite spriteWithSpriteFrameName:@"ressource_gris.png"];
//            unitBuilt = [CCSprite spriteWithFile:@"unit3.jpg"];
//            unitBuilt.position = ccp(cauldron.position.x, cauldron.position.y);
            unitBuilt = [[UnitBuilt alloc] initWithUnitLevel:3 atPosition:ccp(cauldron.position.x, cauldron.position.y) ofTeam:NO];

            [self addChild:unitBuilt];
        }else if ([cauldronContent isEqualToSet:unitLevelFourRecipe] && [cauldronContent count] == [unitLevelFourRecipe count]) {
            [self removeChild:unitBuilt cleanup:YES];
//            unitBuilt = [CCSprite spriteWithSpriteFrameName:@"ressource_rouge.png"];
//            unitBuilt = [CCSprite spriteWithFile:@"unit4.jpg"];
            CCLOG(@"Level four !");
//            unitBuilt.position = ccp(cauldron.position.x, cauldron.position.y);
            unitBuilt = [[UnitBuilt alloc] initWithUnitLevel:4 atPosition:ccp(cauldron.position.x, cauldron.position.y) ofTeam:NO];

            [self addChild:unitBuilt];
        }else if ([cauldronContent isEqualToSet:unitLevelFiveRecipe] && [cauldronContent count] == [unitLevelFiveRecipe count]) {
            [self removeChild:unitBuilt cleanup:YES];
//            unitBuilt = [CCSprite spriteWithFile:@"unit5.jpg"];
            CCLOG(@"Level five !");
            unitBuilt = [[UnitBuilt alloc] initWithUnitLevel:5 atPosition:ccp(cauldron.position.x, cauldron.position.y) ofTeam:NO];

//            unitBuilt.position = ccp(cauldron.position.x, cauldron.position.y);
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
    //    CGPoint touchLocation = [[[notification object] objectForKey:@"touchLocation"] CGPointValue];
    CGPoint initPosition = [[[notification object] objectForKey:@"initPosition"] CGPointValue];
    
    CCNode *unitBuiltNode = [self getChildByTag:tag];
    UnitBuilt *unitBuilt = (UnitBuilt*)unitBuiltNode;
    
    CCNode *iPadSenderNode = [self getChildByTag:unitToiPad];
    CCSprite *iPadSender = (CCSprite*)iPadSenderNode;
    
    CCAction *back2InitPosition = [CCMoveTo actionWithDuration:.2f
                                            position: ccp(initPosition.x, initPosition.y)];
    
    if (CGRectContainsRect(iPadSender.boundingBox, unitBuilt.boundingBox))
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
        
        CCLOG(@"send to iPhone");
    }else{
        [unitBuilt runAction:back2InitPosition];
    }
}



@end
