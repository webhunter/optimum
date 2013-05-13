//
//  Player.h
//  optimum
//
//  Created by REY Morgan on 02/05/13.
//
//

#import <Foundation/Foundation.h>


typedef enum
{
	PlayerPositionBottom,  // the user
	PlayerPositionLeft,
	PlayerPositionRight
}
PlayerPosition;

@interface Player : NSObject

@property (nonatomic, assign) PlayerPosition position;
@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSString *peerID;
@property (nonatomic, assign) BOOL receivedResponse;

@end