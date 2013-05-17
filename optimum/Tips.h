//
//  Tips.h
//  optimum
//
//  Created by Jean-Louis Danielo on 17/05/13.
//  Copyright 2013 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"

@interface Tips : CCLayer {
    NSString *nextScene;
}

+ (CCScene *) sceneWithNextScene:(NSDictionary*)nextScene;
+ (CCScene *) scene;

@end
