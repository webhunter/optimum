//
//  Packet.m
//  optimum
//
//  Created by REY Morgan on 02/05/13.
//
//

#import "Packet.h"
#import "NSData+Additions.h"
#import "PacketSignInResponse.h"
#import "PacketServerReady.h"

const size_t PACKET_HEADER_SIZE = 10;

@implementation Packet


@synthesize packetType = _packetType;

+ (id)packetWithType:(PacketType)packetType
{
	return [[[self class] alloc] initWithType:packetType];
}

- (id)initWithType:(PacketType)packetType
{
	if ((self = [super init]))
	{
		self.packetType = packetType;
	}
	return self;
}

- (NSData *)data
{
	NSMutableData *data = [[NSMutableData alloc] initWithCapacity:100];
    
	[data rw_appendInt32:'OPTI'];   // 0x534E4150
	[data rw_appendInt32:0];
	[data rw_appendInt16:self.packetType];
    
	[self addPayloadToData:data];
	return data;
}

- (NSString *)description
{
	return [NSString stringWithFormat:@"%@, type=%d", [super description], self.packetType];
}

+ (id)packetWithData:(NSData *)data
{
	if ([data length] < PACKET_HEADER_SIZE)
	{
		NSLog(@"Error: Packet too small");
		return nil;
	}
    
	if ([data rw_int32AtOffset:0] != 'OPTI')
	{
		NSLog(@"Error: Packet has invalid header");
		return nil;
	}
    
	int packetNumber = [data rw_int32AtOffset:4];
	PacketType packetType = [data rw_int16AtOffset:8];
    
	Packet *packet;
    
	switch (packetType)
	{
		case PacketTypeSignInRequest:
			packet = [Packet packetWithType:packetType];
			break;
            
        case PacketTypeClientReady:
            packet = [Packet packetWithType:packetType];
            break;
            
		case PacketTypeSignInResponse:
			packet = [PacketSignInResponse packetWithData:data];
			break;
            
        case PacketTypeServerReady:
			packet = [PacketServerReady packetWithData:data];
			break;
            
		default:
			NSLog(@"Error: Packet has invalid type");
			return nil;
	}
    
	return packet;
}

- (void)addPayloadToData:(NSMutableData *)data
{
	// base class does nothing
}

@end