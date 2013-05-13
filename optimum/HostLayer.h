//
//  HostLayer.h
//  optimum
//
//  Created by REY Morgan on 28/04/13.
//  Copyright 2013 __MyCompanyName__. All rights reserved.
//

@class HostView;

@protocol HostViewDelegate <NSObject>

- (void)hostLayerDidCancel:(HostView *)controller;
- (void)hostViewController:(HostView *)controller didEndSessionWithReason:(QuitReason)reason;
- (void)hostViewController:(HostView *)controller startGameWithSession:(GKSession *)session playerName:(NSString *)name clients:(NSArray *)clients;

@end


#import <Foundation/Foundation.h>
#import "cocos2d.h"
#import "CCUIViewWrapper.h"
#import "PlayLayer.h"
#import "MatchmakingServer.h"
#import "GameLayer.h"



@interface HostLayer : CCLayer<UITableViewDataSource, UITableViewDelegate,UITextFieldDelegate, MatchmakingServerDelegate> {
    UITableView *tableView;
    CCUIViewWrapper *tableViewWrapper;
    UITextField *textField;
    CCUIViewWrapper *textFieldWrapper;
}

@property (nonatomic, weak) id <HostViewDelegate> delegate;

+(CCScene *) scene;

@end
