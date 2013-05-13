//
//  Game.m
//  optimum
//
//  Created by REY Morgan on 01/05/13.
//
//

#import "Game.h"
#import "Player.h"
#import "Packet.h"
#import "PacketSignInResponse.h"
#import "PacketServerReady.h"

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
			}
			break;
            
		default:
			NSLog(@"Client received unexpected packet: %@", packet);
			break;
	}
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
            
		default:
			NSLog(@"Server received unexpected packet: %@", packet);
			break;
	}
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

- (void)dealloc
{
#ifdef DEBUG
	NSLog(@"dealloc %@", self);
#endif
}

@end
