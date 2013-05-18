//
//  UnitSpriteMap.m
//  Optimum-maquette
//
//  Created by Jean-Louis Danielo on 01/05/13.
//  Copyright 2013 __MyCompanyName__. All rights reserved.
//

#import "UnitSpriteMap.h"


@implementation UnitSpriteMap

-(id) initWithTexture:(CCTexture2D*)texture rect:(CGRect)rect WithUnitType:(int)unitType
{
    if( (self = [super init]))
    {
        int lastDigit = unitType % 10;

        switch (lastDigit) {
            case 1:
            case 2:
                self.HP = self.HPMax = 200;
                self.attackPoint = 10;
                self.frequency = 1;
                break;
                
            case 3:
            case 4:
                self.HP = self.HPMax = 400;
                self.attackPoint = 20;
                self.frequency = 2;
                break;
                
            case 5:
            case 6:
                self.HP = self.HPMax = 600;
                self.attackPoint = 35;
                self.frequency = 3;
                break;
                
            case 7:
            case 8:
                self.HP = self.HPMax = 750;
                self.attackPoint = 50;
                self.frequency = 3;
                break;
                
            case 9:
            case 0:
                self.HP = self.HPMax = 1000;
                self.attackPoint = 100;
                self.frequency = 4;
                break;
                
            default:
                break;
        }
        
        if (unitType % 2 == 0) { //team de droite
            self.team = YES;
        }else{
            self.team = NO;
        }
        
        self.opacity = 255;
        [self setDemi:NO];
        [self setTiers:NO];
        
        [self schedule: @selector(attackFrequency:) interval:1];
    }
	return [self initWithTexture:texture rect:rect rotated:NO];
}

- (id) initWithUnitType:(int)unitType
{
    if( (self = [super init]))
    {
        if (unitType % 2 == 0) { //team de droite
            self.team = YES;
            self.attackPoint = 10;
        }else{
            self.team = NO;
            self.attackPoint = 100;
        }
        
//        self.HP = self.HPMax = 200;
//        self.opacity = 255;
        
//        [self schedule: @selector(attackFrequency:) interval:1];
    }
        
    return self;
}

#pragma mark - Gestion de la vie
- (int) HP
{
    return HP;
}

- (void) setHP:(int)life
{
    HP = life;
}

- (int) HPMax
{
    return HPMax;
}

- (void) setHPMax:(int)lifeMax
{
    HPMax = lifeMax;
}

#pragma mark - Gestion de l'attaque
- (void) setAreaEffect:(NSArray *)area
{
    areaEffect = area;
}

- (NSArray*) areaEffect
{
    return areaEffect;
}

- (void) setFrequency:(int)frequence
{
    frequency = frequence;
}

- (int) frequency
{
    return frequency;
}

- (void) setAttackPoint:(int)pointPerSecond
{
    attackPoint = pointPerSecond;
}

- (int) attackPoint
{
    return attackPoint;
}

- (void) attackFrequency: (ccTime) dt
{
    if ((int)dt % 2 == 0){
        
        
    }else if ((int)dt % 3 == 0){
    
    }else if ((int)dt % 4 == 0) {
    
    }
}


#pragma mark - Divers
- (void) setTeam:(BOOL) equipe
{
    team = equipe;
}

- (BOOL) team
{
    return team;
}

- (void) setDemi:(BOOL) liveLevel
{
    demi = liveLevel;
}

- (BOOL) demi
{
    return demi;
}

- (void) setTiers:(BOOL) liveLevel
{
    tiers = liveLevel;
}

- (BOOL) tiers
{
    return tiers;
}

@end
