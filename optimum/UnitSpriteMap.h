//
//  UnitSpriteMap.h
//  Optimum-maquette
//
//  Created by Jean-Louis Danielo on 01/05/13.
//  Copyright 2013 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"

@interface UnitSpriteMap : CCSprite {
    
    //Gestion de l'attaque
    int attackPoint;
    int frequency;
    NSArray *areaEffect;
    
    //Gestion de la vie
    float HP;
    float HPMax;
    
    //Divers
    BOOL team;
    BOOL tiers; //Permet de savoir s'il reste le tiers de l'énergie
    BOOL demi; //Permet de savoir s'il reste moitié de l'énergie
}

- (id) initWithUnitType:(int)unitType;
- (id) initWithTexture:(CCTexture2D*)texture rect:(CGRect)rect WithUnitType:(int)unitType;


- (int) HP;
- (void) setHP:(int)life;
- (int) HPMax;
- (void) setHPMax:(int)lifeMax;

- (int) attackPoint;
- (void) setAttackPoint:(int)pointPerSecond;
- (int) frequency;
- (void) setFrequency:(int)frequence;
- (NSArray*) areaEffect;
- (void) setAreaEffect:(NSArray*)area;

- (void) setTeam:(BOOL) equipe;
- (BOOL) team;
- (BOOL) tiers;
- (void) setTiers:(BOOL) liveLevel;
- (BOOL) demi;
- (void) setDemi:(BOOL) liveLevel;

@end
