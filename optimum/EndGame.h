//
//  EndGame.h
//  optimum
//
//  Created by Jean-Louis Danielo on 19/05/13.
//  Copyright 2013 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"

@interface EndGame : CCLayer {
    
}

+ (CCScene *) sceneWithParameters:(NSDictionary*)parameters;
- (id) initWithParameters:(NSDictionary*)parameters;
+ (id) nodeWithParameters:(NSDictionary*)parameters;

@end