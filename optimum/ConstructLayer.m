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
    if( (self=[super init]) ) {
        gameElement = gameObject;
        CCSpriteFrameCache* frameCache = [CCSpriteFrameCache sharedSpriteFrameCache];
        [frameCache addSpriteFramesWithFile:@"ConstructLayer.plist"];
        
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
                        
                        //Background
                        CCSprite *background = [CCSprite spriteWithFile:@"background_01_iPhone5.jpg"];
                        [background setPosition:ccp(size.width/2, size.height/2)];
                        
                        [self addChild:background];
                        
                        //Chaudron
                        CCSprite *chaudron = [CCSprite spriteWithSpriteFrameName:@"chaudron.png"];
                        [chaudron setPosition:ccp(size.width/2, size.height/2 - 40)];
                        
                        [self addChild:chaudron];
                        
                        //Envoi Ipad
                        CCSprite *envoiIpad = [CCSprite spriteWithSpriteFrameName:@"envoi_iPad.png"];
                        [envoiIpad setPosition:ccp(size.width/2 + 118, size.height/2 - 243)];
                        
                        [self addChild:envoiIpad];
                        
                        //Bouton annuler
                        CCSprite *cancel = [CCSprite spriteWithSpriteFrameName:@"btn_supp.png"];
                        [cancel setPosition:ccp(size.width/2, size.height/2 - 266)];
                        
                        [self addChild:cancel];
                        
                        // Ressource verte complete
                        CCSprite *ressourceVerteFull = [CCSprite spriteWithSpriteFrameName:@"ressource_bis_vert.png"];
                        [ressourceVerteFull setPosition:ccp(size.width/2 + 113 , size.height/2 + 92 )];
                        
                        [self addChild:ressourceVerteFull];
                        
                        CCSprite *ressourceVerteDrag = [CCSprite spriteWithSpriteFrameName:@"ressource_vert.png"];
                        [ressourceVerteDrag setPosition:ccp(size.width/2 + 113 , size.height/2 + 92 )];
                        
                        [self addChild:ressourceVerteDrag];
                        
                        CCSprite *pastilleVerte = [CCSprite spriteWithSpriteFrameName:@"pastille_vert.png"];
                        [pastilleVerte setPosition:ccp(size.width/2 + 92 , size.height/2 + 115 )];
                        
                        [self addChild:pastilleVerte];
                        
                        
                        // Ressource grise complete
                        CCSprite *ressourceGriseFull = [CCSprite spriteWithSpriteFrameName:@"ressource_bis_gris.png"];
                        [ressourceGriseFull setPosition:ccp(size.width/2 - 113 , size.height/2 + 92 )];
                        
                        [self addChild:ressourceGriseFull];
                        
                        CCSprite *ressourceGriseDrag = [CCSprite spriteWithSpriteFrameName:@"ressource_gris.png"];
                        [ressourceGriseDrag setPosition:ccp(size.width/2 - 113 , size.height/2 + 92 )];
                        
                        [self addChild:ressourceGriseDrag];
                        
                        CCSprite *pastilleGrise = [CCSprite spriteWithSpriteFrameName:@"pastille_gris.png"];
                        [pastilleGrise setPosition:ccp(size.width/2 - 88 , size.height/2 + 111 )];
                        
                        [self addChild:pastilleGrise];
                        
                        // Ressource rouge complete
                        CCSprite *ressourceRougeFull = [CCSprite spriteWithSpriteFrameName:@"ressource_bis_rouge.png"];
                        [ressourceRougeFull setPosition:ccp(size.width/2 - 113 , size.height/2 - 170 )];
                        
                        [self addChild:ressourceRougeFull];
                        
                        CCSprite *ressourceRougeDrag = [CCSprite spriteWithSpriteFrameName:@"ressource_rouge.png"];
                        [ressourceRougeDrag setPosition:ccp(size.width/2 - 113 , size.height/2 - 170 )];
                        
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
                        
                        
                    }
                    else
                    {
                        // IPHONE RETINA SCREEN
                        
                    }
                }
            }
            
        }
		
        
    }
	return self;
}

@end
