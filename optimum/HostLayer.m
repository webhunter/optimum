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
        if((self=[super init]))
        {
            CGFloat scale = [[UIScreen mainScreen] scale];
            if (scale > 1.0)
            {
                // IPAD RETINA SCREEN
                // ask director for the window size
                CGSize size = [[CCDirector sharedDirector] winSize];
                
                // BackGround
                CCSprite *background = [CCSprite spriteWithFile:@"background-hd.jpg"];
                [background setPosition:ccp(size.width/2, size.height/2)];
                
                [self addChild:background];
                
                // Bouton back
                CCMenuItemImage *button_back = [CCMenuItemImage itemWithNormalImage:@"back_btn-hd.png" selectedImage:@"back_btn-hd.png" target:self selector:@selector(buttonPressedBack:)];
                
                CCMenu *menu_back = [CCMenu menuWithItems:button_back, nil];
                [menu_back setPosition:ccp( size.width/2 - 472, size.height/2 + 345)];
                
                // Add the menu to the layer
                [self addChild:menu_back];

                
                //titre
                CCLabelTTF *hostlabel = [CCLabelTTF labelWithString:@"CONNEXION ENTRE LES APPAREILS" fontName:@"Economica-Bold" fontSize:32];
                hostlabel.position = ccp( size.width/2, size.height/2 + 280);
                
                [self addChild:hostlabel];
                
                // your name label
                CCLabelTTF *name = [CCLabelTTF labelWithString:@"Nom de l'iPad" fontName:@"Economica-Bold" fontSize:26];
                name.position = ccp( size.width/2 - 260, size.height/2 + 139);
                
                [self addChild:name];
                
                CCSprite *champs = [CCSprite spriteWithFile:@"Connexion_champsTxt-hd.png"];
                [champs setPosition:ccp(size.width/2 +80 , size.height/2 + 138)];
                
                [self addChild:champs];
                
                //textfield
                textField = [[UITextField alloc]init];
                textField.frame = CGRectMake(size.width/2 - 140 , size.height/2 - 155 , 300, 80);
                textField.font = [UIFont fontWithName:@"Economica-Regular" size:26];
                textField.textColor = [UIColor whiteColor];
                textField.enabled = NO;
                textField.delegate = self;
                
                textFieldWrapper = [CCUIViewWrapper wrapperForUIView:textField];
                
                [self addChild:textFieldWrapper];
                
                //recherche de joueurs label
                CCLabelTTF *message = [CCLabelTTF labelWithString:@"RECHERCHE DES JOUEURS EN COURS..." fontName:@"Economica-Bold" fontSize:26];
                message.position = ccp( size.width/2, size.height/2);
                
                [self addChild:message];
                
                //message 2
                CCLabelTTF *message2 = [CCLabelTTF labelWithString:@"Veuillez allumer vos iPhones" fontName:@"Economica-Regular" fontSize:22];
                message2.position = ccp( size.width/2, size.height/2 - 50);
                
                [self addChild:message2];
                                
                // Nom des joueurs
                CCLabelTTF *name2 = [CCLabelTTF labelWithString:@"Joueur n°1" fontName:@"Economica-Bold" fontSize:26];
                name2.position = ccp( size.width/2 - 270, size.height/2 - 150);
                
                [self addChild:name2];
                
                CCLabelTTF *name3 = [CCLabelTTF labelWithString:@"Joueur n°2" fontName:@"Economica-Bold" fontSize:26];
                name3.position = ccp( size.width/2 - 270, size.height/2 - 220);
                
                [self addChild:name3];
                
                CCSprite *champs2 = [CCSprite spriteWithFile:@"Connexion_champsTxt-hd.png"];
                [champs2 setPosition:ccp(size.width/2 +80 , size.height/2 - 152)];
                
                [self addChild:champs2];
                
                CCSprite *champs3 = [CCSprite spriteWithFile:@"Connexion_champsTxt-hd.png"];
                [champs3 setPosition:ccp(size.width/2 +80 , size.height/2 - 222)];
                
                [self addChild:champs3];
                
                
                // Table View
                tableView = [[UITableView alloc]initWithFrame:CGRectMake( 332, 469, 450, 200) style:UITableViewStyleGrouped];
                tableView.backgroundColor = [UIColor clearColor];
                tableView.separatorColor = [UIColor clearColor];
                tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
                tableView.opaque = NO;
                tableView.backgroundView = nil;
                tableView.scrollEnabled = NO;
                
                tableView.delegate = self;
                tableView.dataSource = self;
                
                tableViewWrapper = [CCUIViewWrapper wrapperForUIView:tableView];
                
                [self addChild:tableViewWrapper];
                
                //bouton play
                CCMenuItemImage *button_play = [CCMenuItemImage itemWithNormalImage:@"jouer_btn-hd.png" selectedImage:@"jouer_btn-hd.png" target:self selector:@selector(buttonPressedPlay:)];
                
                CCMenu *menu_play = [CCMenu menuWithItems:button_play, nil];
                [menu_play setPosition:ccp( size.width/2, size.height/2 - 360)];
                
                
                // Add the menu to the layer
                [self addChild:menu_play];

            }
            else
            {
                // IPAD 
                // ask director for the window size
                CGSize size = [[CCDirector sharedDirector] winSize];
                
                // BackGround
                CCSprite *background = [CCSprite spriteWithFile:@"background.jpg"];
                [background setPosition:ccp(size.width/2, size.height/2)];
                
                [self addChild:background];
                
                // Bouton back
                CCMenuItemImage *button_back = [CCMenuItemImage itemWithNormalImage:@"back_btn.png" selectedImage:@"back_btn.png" target:self selector:@selector(buttonPressedBack:)];
                
                CCMenu *menu_back = [CCMenu menuWithItems:button_back, nil];
                [menu_back setPosition:ccp( size.width/2 - 472, size.height/2 + 345)];
                
                // Add the menu to the layer
                [self addChild:menu_back];
                
                
                //titre
                CCLabelTTF *hostlabel = [CCLabelTTF labelWithString:@"CONNEXION ENTRE LES APPAREILS" fontName:@"Economica-Bold" fontSize:32];
                hostlabel.position = ccp( size.width/2, size.height/2 + 280);
                
                [self addChild:hostlabel];
                
                // your name label
                CCLabelTTF *name = [CCLabelTTF labelWithString:@"Nom de l'iPad" fontName:@"Economica-Bold" fontSize:26];
                name.position = ccp( size.width/2 - 260, size.height/2 + 139);
                
                [self addChild:name];
                
                CCSprite *champs = [CCSprite spriteWithFile:@"Connexion_champsTxt.png"];
                [champs setPosition:ccp(size.width/2 +80 , size.height/2 + 138)];
                
                [self addChild:champs];
                
                //textfield
                textField = [[UITextField alloc]init];
                textField.frame = CGRectMake(size.width/2 - 140 , size.height/2 - 155 , 300, 80);
                textField.font = [UIFont fontWithName:@"Economica-Regular" size:26];
                textField.textColor = [UIColor whiteColor];
                textField.enabled = NO;
                textField.delegate = self;
                
                textFieldWrapper = [CCUIViewWrapper wrapperForUIView:textField];
                
                [self addChild:textFieldWrapper];
                
                //recherche de joueurs label
                CCLabelTTF *message = [CCLabelTTF labelWithString:@"RECHERCHE DES JOUEURS EN COURS..." fontName:@"Economica-Bold" fontSize:26];
                message.position = ccp( size.width/2, size.height/2);
                
                [self addChild:message];
                
                //message 2
                CCLabelTTF *message2 = [CCLabelTTF labelWithString:@"Veuillez allumer vos iPhones" fontName:@"Economica-Regular" fontSize:22];
                message2.position = ccp( size.width/2, size.height/2 - 50);
                
                [self addChild:message2];
                
                // Nom des joueurs
                CCLabelTTF *name2 = [CCLabelTTF labelWithString:@"Joueur n°1" fontName:@"Economica-Bold" fontSize:26];
                name2.position = ccp( size.width/2 - 270, size.height/2 - 150);
                
                [self addChild:name2];
                
                CCLabelTTF *name3 = [CCLabelTTF labelWithString:@"Joueur n°2" fontName:@"Economica-Bold" fontSize:26];
                name3.position = ccp( size.width/2 - 270, size.height/2 - 220);
                
                [self addChild:name3];
                
                CCSprite *champs2 = [CCSprite spriteWithFile:@"Connexion_champsTxt.png"];
                [champs2 setPosition:ccp(size.width/2 +80 , size.height/2 - 152)];
                
                [self addChild:champs2];
                
                CCSprite *champs3 = [CCSprite spriteWithFile:@"Connexion_champsTxt.png"];
                [champs3 setPosition:ccp(size.width/2 +80 , size.height/2 - 222)];
                
                [self addChild:champs3];
                
                
                // Table View
                tableView = [[UITableView alloc]initWithFrame:CGRectMake( 332, 469, 450, 200) style:UITableViewStyleGrouped];
                tableView.backgroundColor = [UIColor clearColor];
                tableView.separatorColor = [UIColor clearColor];
                tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
                tableView.opaque = NO;
                tableView.backgroundView = nil;
                tableView.scrollEnabled = NO;
                
                tableView.delegate = self;
                tableView.dataSource = self;
                
                tableViewWrapper = [CCUIViewWrapper wrapperForUIView:tableView];
                
                [self addChild:tableViewWrapper];
                
                //bouton play
                CCMenuItemImage *button_play = [CCMenuItemImage itemWithNormalImage:@"jouer_btn.png" selectedImage:@"jouer_btn.png" target:self selector:@selector(buttonPressedPlay:)];
                
                CCMenu *menu_play = [CCMenu menuWithItems:button_play, nil];
                [menu_play setPosition:ccp( size.width/2, size.height/2 - 360)];
                
                
                // Add the menu to the layer
                [self addChild:menu_play];
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
    return 70;
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
    cell.textLabel.font = [UIFont fontWithName:@"Economica-Regular" size:26];
    cell.textLabel.textColor = [UIColor whiteColor];
    cell.backgroundColor = [UIColor clearColor];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
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
