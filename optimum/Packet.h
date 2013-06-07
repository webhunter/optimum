//
//  Packet.h
//  optimum
//
//  Created by REY Morgan on 02/05/13.
//
//

#import <Foundation/Foundation.h>

const size_t PACKET_HEADER_SIZE;

typedef enum
{
	PacketTypeSignInRequest = 0x64,    // server to client
	PacketTypeSignInResponse,          // client to server
    
	PacketTypeServerReady,             // server to client
	PacketTypeClientReady,             // client to server
    
	PacketTypeTeam,                     // server to client
    PacketTypeTeam2,
	PacketTypeClientTeam,               // client to server
    
	PacketTypeActivatePlayer,          // server to client
	PacketTypeClientTurnedCard,        // client to server
    
	PacketTypePlayerShouldSnap,        // client to server
	PacketTypePlayerCalledSnap,        // server to client
    
	PacketTypeOtherClientQuit,         // server to client
	PacketTypeServerQuit,              // server to client
	PacketTypeClientQuit,              // client to server
    
    PacketTypeMapGameStart,            // server to client
    PacketTypeMapGameStart2,
    
    PacketRessourceVert,
    PacketRessourceGris,
    PacketRessourceRouge,
    
    PacketRessourceVert2,
    PacketRessourceGris2,
    PacketRessourceRouge2,
    
    PacketUnitLeft,
    PacketUnitLeft2,
    PacketUnitLeft3,
    PacketUnitLeft4,
    PacketUnitLeft5,
    
    PacketUnitRight,
    PacketUnitRight2,
    PacketUnitRight3,
    PacketUnitRight4,
    PacketUnitRight5,
    
    PacketTypeBack,
}
PacketType;

@interface Packet : NSObject

@property (nonatomic, assign) PacketType packetType;

+ (id)packetWithType:(PacketType)packetType;
- (id)initWithType:(PacketType)packetType;
+ (id)packetWithData:(NSData *)data;

- (NSData *)data;

@end