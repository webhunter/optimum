//
//  CCTMXLayer+TileLifeLayer.m
//  Optimum-maquette
//
//  Created by Jean-Louis Danielo on 01/05/13.
//
//

#import "CCTMXLayer+TileLifeLayer.h"

@implementation CCTMXLayer (TileLifeLayer)

-(UnitSpriteMap*) unitAt:(CGPoint)pos
{
	NSAssert( pos.x < layerSize_.width && pos.y < layerSize_.height && pos.x >=0 && pos.y >=0, @"TMXLayer: invalid position");
	NSAssert( tiles_ && atlasIndexArray_, @"TMXLayer: the tiles map has been released");
    
    UnitSpriteMap *tile = nil;
	uint32_t gid = [self tileGIDAt:pos];
    
    
    
	// if GID == 0, then no tile is present
    
    if( gid ) {
		int z = pos.x + pos.y * layerSize_.width;
		tile = (UnitSpriteMap*) [self getChildByTag:z];
        
		// tile not created yet. create it
		if( ! tile ) {
			CGRect rect = [tileset_ rectForGID:gid];
			rect = CC_RECT_PIXELS_TO_POINTS(rect);
      
            tile = [[UnitSpriteMap alloc] initWithTexture:self.texture rect:rect WithUnitType:gid];

			[tile setBatchNode:self];
            
            CGPoint p = [self positionAt:pos];
            [tile setPosition:p];
			[tile setVertexZ: [self vertexZForPos:pos]];
			tile.anchorPoint = CGPointZero;
			[tile setOpacity:opacity_];
            
			NSUInteger indexForZ = [self atlasIndexForExistantZ:z];
			[self addSpriteWithoutQuad:tile z:indexForZ tag:z];
		}
	}
    
	return tile;
}

@end
