//
//  HostLayer.m
//  optimum
//
//  Created by REY Morgan on 28/04/13.
//  Copyright 2013 __MyCompanyName__. All rights reserved.
//

#import "HostLayer.h"
#import "Game.h"


@implementation HostLayer
{
    MatchmakingServer *_matchmakingServer;
    QuitReason _quitReason;
}

@synthesize delegate = _delegate;

// Helper class method that creates a Scene with the HelloWorldLayer as the only child.
+(CCScene *) scene
{
	// 'scene' is an autorelease object.
	CCScene *scene = [CCScene node];
	
	// 'layer' is an autorelease object.
	HostLayer *layer = [HostLayer node];
	
	// add layer as a child to scene
	[scene addChild: layer];
	
	// return the scene
	return scene;
}

- (void) onEnterTransitionDidFinish
{
    [super onEnterTransitionDidFinish];
    
	if (_matchmakingServer == nil)
	{
        _matchmakingServer = [[MatchmakingServer alloc] init];
        _matchmakingServer.delegate = self;
		_matchmakingServer.maxClients = 2;
		[_matchmakingServer startAcceptingConnectionsForSessionID:SESSION_ID];
        textField.placeholder = _matchmakingServer.session.displayName;
        
		[tableView reloadData];
	}
}


-(id) init
{
    if( UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad )
    {
        //Ecran Ipad
        if((self=[super init]))
        {
            CGFloat scale = [[UIScreen mainScreen] scale];
            if (scale > 1.0)
            {
                // IPAD RETINA SCREEN
                // ask director for the window size
                CGSize size = [[CCDirector sharedDirector] winSize];
                
                //titre
                CCLabelTTF *hostlabel = [CCLabelTTF labelWithString:@"HostGame" fontName:@"Marker Felt" fontSize:32];
                hostlabel.position = ccp( size.width/2, size.height/2 + 280);
                
                [self addChild:hostlabel];
                
                // your name label
                CCLabelTTF *name = [CCLabelTTF labelWithString:@"Your Name :" fontName:@"Marker Felt" fontSize:32];
                name.position = ccp( size.width/2 - 230, size.height/2 + 200);
                
                [self addChild:name];
                
                //recherche de joueurs label
                CCLabelTTF *message = [CCLabelTTF labelWithString:@"Recherche de joueurs en cours..." fontName:@"Marker Felt" fontSize:32];
                message.position = ccp( size.width/2, size.height/2 + 100);
                
                [self addChild:message];
                
                //bouton back
                CCMenuItemImage *button_back = [CCMenuItemImage itemWithNormalImage:@"button_back.png" selectedImage:@"button_back.png" target:self selector:@selector(buttonPressedBack:)];
                
                CCMenu *menu_back = [CCMenu menuWithItems:button_back, nil];
                [menu_back setPosition:ccp( size.width/2 - 450, size.height/2 + 300)];
                
                // Add the menu to the layer
                [self addChild:menu_back];
                
                //bouton play
                CCMenuItemImage *button_play = [CCMenuItemImage itemWithNormalImage:@"button_play.png" selectedImage:@"button_play.png" target:self selector:@selector(buttonPressedPlay:)];
                
                CCMenu *menu_play = [CCMenu menuWithItems:button_play, nil];
                [menu_play setPosition:ccp( size.width/2, size.height/2 - 250)];
                
                
                // Add the menu to the layer
                [self addChild:menu_play];
                
                // Table View
                tableView = [[UITableView alloc]initWithFrame:CGRectMake( 210, 350, 600, 200) style:UITableViewStyleGrouped];
                tableView.delegate = self;
                tableView.dataSource = self;
                
                tableViewWrapper = [CCUIViewWrapper wrapperForUIView:tableView];
                
                [self addChild:tableViewWrapper];
                
                //textfield
                textField = [[UITextField alloc]init];
                textField.frame = CGRectMake(size.width/2 - 140, size.height/2 - 220, 400, 40);
                [textField  setBackgroundColor:[UIColor grayColor]];
                textField.delegate = self;
                
                textFieldWrapper = [CCUIViewWrapper wrapperForUIView:textField];
                
                [self addChild:textFieldWrapper];

            }
            else
            {
                // IPAD 
                // ask director for the window size
                CGSize size = [[CCDirector sharedDirector] winSize];
                
                //titre
                CCLabelTTF *hostlabel = [CCLabelTTF labelWithString:@"HostGame" fontName:@"Marker Felt" fontSize:32];
                hostlabel.position = ccp( size.width/2, size.height/2 + 280);
                
                [self addChild:hostlabel];
                
                // your name label
                CCLabelTTF *name = [CCLabelTTF labelWithString:@"Your Name :" fontName:@"Marker Felt" fontSize:32];
                name.position = ccp( size.width/2 - 230, size.height/2 + 200);
                
                [self addChild:name];
                
                //recherche de joueurs label
                CCLabelTTF *message = [CCLabelTTF labelWithString:@"Recherche de joueurs en cours..." fontName:@"Marker Felt" fontSize:32];
                message.position = ccp( size.width/2, size.height/2 + 100);
                
                [self addChild:message];
                
                //bouton back
                CCMenuItemImage *button_back = [CCMenuItemImage itemWithNormalImage:@"button_back.png" selectedImage:@"button_back.png" target:self selector:@selector(buttonPressedBack:)];
                
                CCMenu *menu_back = [CCMenu menuWithItems:button_back, nil];
                [menu_back setPosition:ccp( size.width/2 - 450, size.height/2 + 300)];
                
                // Add the menu to the layer
                [self addChild:menu_back];
                
                //bouton play
                CCMenuItemImage *button_play = [CCMenuItemImage itemWithNormalImage:@"button_play.png" selectedImage:@"button_play.png" target:self selector:@selector(buttonPressedPlay:)];
                
                CCMenu *menu_play = [CCMenu menuWithItems:button_play, nil];
                [menu_play setPosition:ccp( size.width/2 - 260, size.height/2 -450)];
                menu_play.scale = 0.5;
                
                // Add the menu to the layer
                [self addChild:menu_play];
                
                // Table View
                tableView = [[UITableView alloc]initWithFrame:CGRectMake( 210, 350, 600, 200) style:UITableViewStyleGrouped];
                tableView.delegate = self;
                tableView.dataSource = self;
                
                tableViewWrapper = [CCUIViewWrapper wrapperForUIView:tableView];
                
                [self addChild:tableViewWrapper];
                
                //textfield
                textField = [[UITextField alloc]init];
                textField.frame = CGRectMake(size.width/2 - 140, size.height/2 - 220, 400, 40);
                [textField  setBackgroundColor:[UIColor grayColor]];
                textField.delegate = self;
                
                textFieldWrapper = [CCUIViewWrapper wrapperForUIView:textField];
                
                [self addChild:textFieldWrapper];
            }
        }

    }
    return self;
}

- (void) dealloc
{

}

//Taille de la cellule
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 30;
}

//Nombres de cellules
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
	if (_matchmakingServer != nil){
        
		return [_matchmakingServer connectedClientCount];
        
    }
	else{
		
        return 0;
    }
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
	static NSString *CellIdentifier = @"CellIdentifier";
    
	UITableViewCell *cell = [self->tableView dequeueReusableCellWithIdentifier:CellIdentifier];
	if (cell == nil)
		cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    
	NSString *peerID = [_matchmakingServer peerIDForConnectedClientAtIndex:indexPath.row];
	cell.textLabel.text = [_matchmakingServer displayNameForPeerID:peerID];
    
	return cell;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
	return YES;
}


- (void) buttonPressedBack: (id) sender
{
    _quitReason = QuitReasonUserQuit;
    [_matchmakingServer endSession];
    [[CCDirector sharedDirector] replaceScene:[PlayLayer scene]];
}

- (void) buttonPressedPlay: (id) sender
{
    if (_matchmakingServer != nil && [_matchmakingServer connectedClientCount] > 0)
	{
        NSString *name = [textField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
		if ([name length] == 0)
			name = _matchmakingServer.session.displayName;
		[_matchmakingServer stopAcceptingConnections];
        [self startGameWithBlock:^(Game *game)
         {
             [game startServerGameWithSession:_matchmakingServer.session playerName:name clients:_matchmakingServer.connectedClients];
         }];
	}
}

- (void)startGameWithBlock:(void (^)(Game *))block
{
    GameLayer *scene = [[GameLayer alloc]init];
    scene.delegate = self;
    [[CCDirector sharedDirector] replaceScene:scene];
    Game *game = [[Game alloc] init];
    scene.game = game;
    game.delegate = scene;
    block(game);
}



#pragma mark - MatchmakingServerDelegate

- (void)matchmakingServer:(MatchmakingServer *)server clientDidConnect:(NSString *)peerID
{
	[tableView reloadData];
}

- (void)matchmakingServer:(MatchmakingServer *)server clientDidDisconnect:(NSString *)peerID
{
	[tableView reloadData];
}

#pragma mark - UITableViewDelegate

- (NSIndexPath *)tableView:(UITableView *)tableView willSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
	return nil;
}

- (void)matchmakingServerSessionDidEnd:(MatchmakingServer *)server
{
	_matchmakingServer.delegate = nil;
	_matchmakingServer = nil;
	[tableView reloadData];
	[self.delegate hostViewController:nil didEndSessionWithReason:_quitReason];
}

- (void)matchmakingServerNoNetwork:(MatchmakingServer *)server
{
	_quitReason = QuitReasonNoNetwork;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
	[textField resignFirstResponder];
	return NO;
}


@end
