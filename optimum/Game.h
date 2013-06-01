//
//  Game.h
//  optimum
//
//  Created by REY Morgan on 01/05/13.
//
//

@class Game;

@protocol GameDelegate <NSObject>

- (void)game:(Game *)game didQuitWithReason:(QuitReason)reason;
- (void)gameDidBegin:(Game *)game;

@end

#import <Foundation/Foundation.h>
#import "Packet.h"
#import "Player.h"


@interface Game : NSObject <GKSessionDelegate>

@property (nonatomic, weak) id <GameDelegate> delegate;
@property (nonatomic, assign) BOOL isServer;

- (void)startClientGameWithSession:(GKSession *)session playerName:(NSString *)name server:(NSString *)peerID;
- (void)quitGameWithReason:(QuitReason)reason;
- (void)startServerGameWithSession:(GKSession *)session playerName:(NSString *)name clients:(NSArray *)clients;
- (void)sendPacketToAllClients:(Packet *)packet;
- (Player *)playerAtPosition:(PlayerPosition)position;
- (void) sendPacketToOneClient:(Packet *)packet andClient:(NSArray*)client;

@end