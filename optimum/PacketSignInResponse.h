//
//  PacketSignInResponse.h
//  optimum
//
//  Created by REY Morgan on 03/05/13.
//
//

#import "Packet.h"

@interface PacketSignInResponse : Packet

@property (nonatomic, copy) NSString *playerName;

+ (id)packetWithPlayerName:(NSString *)playerName;

@end