//
//  OptimumRessource.h
//  Optimum-maquette
//
//  Created by Jean-Louis Danielo on 25/04/13.
//  Copyright 2013 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"

@interface OptimumRessource : CCSprite <CCTargetedTouchDelegate> {
	
	BOOL isDrag;
	CGPoint touchLocation;
    
    int optimumType;
    int randNum;
    float speedFall; //Vitesse de chute de la ressource
}

- (id) init;

- (BOOL) isTouchOnSprite:(CGPoint)touch;
- (int) optimumType;
- (void) setOptimumType:(int)type;
- (float) speedFall;
- (void) setSpeedFall:(float)speed;

@end
