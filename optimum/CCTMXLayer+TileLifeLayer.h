//
//  CCTMXLayer+TileLifeLayer.h
//  Optimum-maquette
//
//  Created by Jean-Louis Danielo on 01/05/13.
//
//

#import "CCTMXLayer.h"
#import "UnitSpriteMap.h"

@class UnitSpriteMap;

@interface CCTMXLayer (TileLifeLayer)

-(UnitSpriteMap*) unitAt:(CGPoint)tileCoordinate;

@end
