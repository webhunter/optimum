//
//  JoinLayer.h
//  optimum
//
//  Created by REY Morgan on 28/04/13.
//  Copyright 2013 __MyCompanyName__. All rights reserved.
//

@class JoinView;

@protocol JoinViewDelegate <NSObject>

- (void)joinlayerDidCancel:(JoinView *)controller;
- (void)joinViewController:(JoinView *)controller startGameWithSession:(GKSession *)session playerName:(NSString *)name server:(NSString *)peerID;


@end

#import <Foundation/Foundation.h>
#import "cocos2d.h"
#import "CCUIViewWrapper.h"
#import "PlayLayer.h"
#import "MatchmakingClient.h"
#import "WaitLayer.h"
#import "GameLayer.h"



@interface JoinLayer : CCLayer<UITableViewDataSource, UITableViewDelegate, MatchmakingClientDelegate> {
    UITableView *tableView;
    CCUIViewWrapper *tableViewWrapper;
    UITextField *textField;
    CCUIViewWrapper *textFieldWrapper;
}

@property (nonatomic, weak) id <JoinViewDelegate> delegate;


+(CCScene *) scene;

@end
