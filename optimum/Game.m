//
//  Game.m
//  optimum
//
//  Created by REY Morgan on 01/05/13.
//
//

#import "Game.h"
#import "Packet.h"
#import "PacketSignInResponse.h"
#import "PacketServerReady.h"
#import "TeamLayer.h"
#import "ConstructLayer.h"
#import "Archipelago.h"

typedef enum
{
	GameStateWaitingForSignIn,
	GameStateWaitingForReady,
	GameStateDealing,
	GameStatePlaying,
	GameStateGameOver,
	GameStateQuitting,
}
GameState;

@implementation Game
{
	GameState _state;
    
	GKSession *_session;
	NSString *_serverPeerID;
	NSString *_localPlayerName;
    NSMutableDictionary *_players;
}

@synthesize delegate = _delegate;
@synthesize isServer = _isServer;

- (id)init
{
	if ((self = [super init]))
	{
		_players = [NSMutableDictionary dictionaryWithCapacity:4];
	}
	return self;
    

}

#pragma mark - Game Logic

- (void)startClientGameWithSession:(GKSession *)session playerName:(NSString *)name server:(NSString *)peerID
{
    self.isServer = NO;
	_session = session;
	_session.available = NO;
	_session.delegate = self;
	[session setDataReceiveHandler:self withContext:nil];
    
	_serverPeerID = peerID;
    _localPlayerName = name;
	_state = GameStateWaitingForSignIn;
}

- (void)startServerGameWithSession:(GKSession *)session playerName:(NSString *)name clients:(NSArray *)clients
{
	self.isServer = YES;
    
	_session = session;
	_session.available = NO;
	_session.delegate = self;
	[_session setDataReceiveHandler:self withContext:nil];
    
	_state = GameStateWaitingForSignIn;
    
    // Create the Player object for the server.
	Player *player = [[Player alloc] init];
    player.name = name;
	player.peerID = _session.peerID;
	player.position = PlayerPositionBottom;
	[_players setObject:player forKey:player.peerID];
    
	// Add a Player object for each client.
	int index = 0;
	for (NSString *peerID in clients)
	{
		Player *player = [[Player alloc] init];
		player.peerID = peerID;
		[_players setObject:player forKey:player.peerID];
        
		if (index == 0)
			player.position = PlayerPositionLeft;
		else if (index == 1)
			player.position = PlayerPositionRight;
        
		index++;
	}
    
    Packet *packet = [Packet packetWithType:PacketTypeSignInRequest];
	[self sendPacketToAllClients:packet];
}

#pragma mark - Networking

- (void)sendPacketToAllClients:(Packet *)packet
{
	[_players enumerateKeysAndObjectsUsingBlock:^(id key, Player *obj, BOOL *stop)
     {
         obj.receivedResponse = [_session.peerID isEqualToString:obj.peerID];
     }];
    
    GKSendDataMode dataMode = GKSendDataReliable;
	NSData *data = [packet data];
	NSError *error;
	if (![_session sendDataToAllPeers:data withDataMode:dataMode error:&error])
	{
		NSLog(@"Error sending data to clients: %@", error);
	}
}

- (void) sendPacketToOneClient:(Packet *)packet andClient:(NSArray*)client
{
    NSError *error;
    NSData *data = [packet data];
    if (![_session sendData:data toPeers:client withDataMode:GKSendDataReliable error:&error])
    {
        NSLog(@"Error sending data to client: %@", error);
    }
}

- (void)sendPacketToServer:(Packet *)packet
{
	GKSendDataMode dataMode = GKSendDataReliable;
	NSData *data = [packet data];
	NSError *error;
	if (![_session sendData:data toPeers:[NSArray arrayWithObject:_serverPeerID] withDataMode:dataMode error:&error])
	{
		NSLog(@"Error sending data to server: %@", error);
	}
}

- (void)quitGameWithReason:(QuitReason)reason
{
	_state = GameStateQuitting;
    
	[_session disconnectFromAllPeers];
	_session.delegate = nil;
	_session = nil;
    
	[self.delegate game:self didQuitWithReason:reason];
}

#pragma mark - GKSessionDelegate

- (void)session:(GKSession *)session peer:(NSString *)peerID didChangeState:(GKPeerConnectionState)state
{
#ifdef DEBUG
	NSLog(@"Game: peer %@ changed state %d", peerID, state);
#endif
    
	if (state == GKPeerStateDisconnected)
	{
            [[CCDirector sharedDirector] replaceScene:[HelloWorldLayer scene]];
            [self showDisconnectedAlert];
            
	}
}

- (void)showDisconnectedAlert
{
	UIAlertView *alertView = [[UIAlertView alloc]
                              initWithTitle:NSLocalizedString(@"Disconnected", @"Client disconnected alert title")
                              message:NSLocalizedString(@"Vous avez été déconnecté", @"Client disconnected alert message")
                              delegate:nil
                              cancelButtonTitle:NSLocalizedString(@"OK", @"Button: OK")
                              otherButtonTitles:nil];
    
	[alertView show];
}

- (void)clientDidDisconnect:(NSString *)peerID
{
	if (_state != GameStateQuitting)
	{
		Player *player = [self playerWithPeerID:peerID];
		if (player != nil)
		{
			[_players removeObjectForKey:peerID];
			[self.delegate game:self playerDidDisconnect:player];
		}
	}
}

- (void)session:(GKSession *)session didReceiveConnectionRequestFromPeer:(NSString *)peerID
{
#ifdef DEBUG
	NSLog(@"Game: connection request from peer %@", peerID);
#endif
    
	[session denyConnectionFromPeer:peerID];
}

- (void)session:(GKSession *)session connectionWithPeerFailed:(NSString *)peerID withError:(NSError *)error
{
#ifdef DEBUG
	NSLog(@"Game: connection with peer %@ failed %@", peerID, error);
#endif
    
	// Not used.
}

- (void)session:(GKSession *)session didFailWithError:(NSError *)error
{
#ifdef DEBUG
	NSLog(@"Game: session failed %@", error);
#endif
}

#pragma mark - GKSession Data Receive Handler

- (void)receiveData:(NSData *)data fromPeer:(NSString *)peerID inSession:(GKSession *)session context:(void *)context
{
#ifdef DEBUG
	NSLog(@"Game: receive data from peer: %@, data: %@, length: %d", peerID, data, [data length]);
#endif
    
	Packet *packet = [Packet packetWithData:data];
	if (packet == nil)
	{
		NSLog(@"Invalid packet: %@", data);
		return;
	}
    
	Player *player = [self playerWithPeerID:peerID];
	if (player != nil)
	{
		player.receivedResponse = YES;  // this is the new bit
	}
    
	if (self.isServer)
		[self serverReceivedPacket:packet fromPlayer:player];
	else
		[self clientReceivedPacket:packet];
}


- (void)clientReceivedPacket:(Packet *)packet
{
	switch (packet.packetType)
	{
		case PacketTypeSignInRequest:
			if (_state == GameStateWaitingForSignIn)
			{
				_state = GameStateWaitingForReady;
                
				Packet *packet = [PacketSignInResponse packetWithPlayerName:_localPlayerName];
				[self sendPacketToServer:packet];
			}
			break;
        
        case PacketTypeServerReady:
			if (_state == GameStateWaitingForReady)
			{
				_players = ((PacketServerReady *)packet).players;
				NSLog(@"the players are: %@", _players);
                Packet *packet = [Packet packetWithType:PacketTypeClientReady];
                [self sendPacketToServer:packet];
                [self beginGame];
			}
			break;
            
        case PacketTypeTeam:
            if (_state == GameStateDealing) {
                [[CCDirector sharedDirector] pushScene:[TeamLayer sceneWithGameObject:self]];
            }
            break;
            
        case PacketTypeTeam2:
            if (_state == GameStateDealing) {
                [[CCDirector sharedDirector] pushScene:[TeamLayer sceneWithGameObject2:self]];
            }
            break;
            
        case PacketTypeMapGameStart:
            if (_state == GameStateDealing) {
                [[CCDirector sharedDirector] pushScene:[ConstructLayer sceneWithGameObject:self]];
            }
            break;
            
        case PacketTypeMapGameStart2:
            if (_state == GameStateDealing) {
                [[CCDirector sharedDirector] pushScene:[ConstructLayer sceneWithGameObject2:self]];
            }
            break;
         
        case PacketRessourceVert:
            if (_state == GameStateDealing) {
                [self envoieRessourceandParam:0];
            }
            break;
            
        case PacketRessourceRouge:
            if (_state == GameStateDealing) {
                [self envoieRessourceandParam:2];
            }
            break;
            
        case PacketRessourceGris:
            if (_state == GameStateDealing) {
                [self envoieRessourceandParam:1];
            }
            break;
        
        case PacketRessourceVert2:
            if (_state == GameStateDealing) {
                [self envoieRessourceandParam2:0];
            }
            break;
            
        case PacketRessourceRouge2:
            if (_state == GameStateDealing) {
                [self envoieRessourceandParam2:2];
            }
            break;
            
        case PacketRessourceGris2:
            if (_state == GameStateDealing) {
                [self envoieRessourceandParam2:1];
            }
            break;
            
        case PacketTypeBack:
            [[CCDirector sharedDirector] popScene];
            break;
            
        case PacketTypeArchipelago:
            [[CCDirector sharedDirector] pushScene:[Archipelago sceneWithGameObject:self]];
            break;
            
		default:
			NSLog(@"Client received unexpected packet: %@", packet);
			break;
	}
}

- (void)envoieRessourceandParam:(int)ressource
{
    [self.delegate playerReceiveRessource:self andParam:ressource];
}

- (void)envoieRessourceandParam2:(int)ressource
{
    [self.delegate player2ReceiveRessource:self andParam:ressource];
}

- (void)beginGame
{
    _state = GameStateDealing;
    [self.delegate gameDidBegin:self];
    
}


- (void)serverReceivedPacket:(Packet *)packet fromPlayer:(Player *)player
{
	switch (packet.packetType)
	{
		case PacketTypeSignInResponse:
			if (_state == GameStateWaitingForSignIn)
			{
				player.name = ((PacketSignInResponse *)packet).playerName;
                
				if ([self receivedResponsesFromAllPlayers])
				{
					_state = GameStateWaitingForReady;
                    
					Packet *packet = [PacketServerReady packetWithPlayers:_players];
					[self sendPacketToAllClients:packet];
				}
			}
			break;
        
        case PacketTypeClientReady:
            if (_state == GameStateWaitingForReady && [self receivedResponsesFromAllPlayers])
            {
                [self beginGame];
            }
            break;
            
        case PacketUnitLeft:
            if (_state == GameStateDealing)
            {
                [self sendUnitLeftandParam:1];
            }
            break;
            
        case PacketUnitLeft2:
            if (_state == GameStateDealing)
            {
                [self sendUnitLeftandParam:2];
            }
            break;
            
        case PacketUnitLeft3:
            if (_state == GameStateDealing)
            {
                [self sendUnitLeftandParam:3];
            }
            break;
            
        case PacketUnitLeft4:
            if (_state == GameStateDealing)
            {
                [self sendUnitLeftandParam:4];
            }
            break;
            
        case PacketUnitLeft5:
            if (_state == GameStateDealing)
            {
                [self sendUnitLeftandParam:5];
            }
            break;
        
        case PacketUnitRight:
            if (_state == GameStateDealing)
            {
                [self sendUnitRightandParam:1];
            }
            break;
            
        case PacketUnitRight2:
            if (_state == GameStateDealing)
            {
                [self sendUnitRightandParam:2];
            }
            break;
            
        case PacketUnitRight3:
            if (_state == GameStateDealing)
            {
                [self sendUnitRightandParam:3];
            }
            break;
            
        case PacketUnitRight4:
            if (_state == GameStateDealing)
            {
                [self sendUnitRightandParam:4];
            }
            break;
            
        case PacketUnitRight5:
            if (_state == GameStateDealing)
            {
                [self sendUnitRightandParam:5];
            }
            break;
        
            
		default:
			NSLog(@"Server received unexpected packet: %@", packet);
			break;
	}
}

- (void)sendUnitLeftandParam:(int)unit
{
    [self.delegate sendUnitToPlayer:self andParam:unit];
}

- (void)sendUnitRightandParam:(int)unit
{
    [self.delegate sendUnitToPlayer2:self andParam:unit];
}

- (BOOL)receivedResponsesFromAllPlayers
{
	for (NSString *peerID in _players)
	{
		Player *player = [self playerWithPeerID:peerID];
		if (!player.receivedResponse)
			return NO;
	}
	return YES;
}

- (Player *)playerWithPeerID:(NSString *)peerID
{
	return [_players objectForKey:peerID];
}


- (Player *)playerAtPosition:(PlayerPosition)position
{
	__block Player *player;
	[_players enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop)
     {
         player = obj;
         if (player.position == position)
             *stop = YES;
         else
             player = nil;
     }];
	return player;
}


- (void)dealloc
{
#ifdef DEBUG
	NSLog(@"dealloc %@", self);
#endif
}

@end
