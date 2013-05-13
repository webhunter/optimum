//
//  PacketServerReady.h
//  optimum
//
//  Created by REY Morgan on 12/05/13.
//
//

#import "Packet.h"

@interface PacketServerReady : Packet

@property (nonatomic, strong) NSMutableDictionary *players;

+ (id)packetWithPlayers:(NSMutableDictionary *)players;

@end
