//
//  JoinLayer.m
//  optimum
//
//  Created by REY Morgan on 28/04/13.
//  Copyright 2013 __MyCompanyName__. All rights reserved.
//

#import "JoinLayer.h"
#import "Game.h"


@implementation JoinLayer
{
    MatchmakingClient *_matchmakingClient;
    QuitReason _quitReason;
    CCMenuItemImage *button_rejoindre;
}

@synthesize delegate = _delegate;

// Helper class method that creates a Scene with the HelloWorldLayer as the only child.
+(CCScene *) scene
{
	// 'scene' is an autorelease object.
	CCScene *scene = [CCScene node];
	
	// 'layer' is an autorelease object.
	JoinLayer *layer = [JoinLayer node];
	
	// add layer as a child to scene
	[scene addChild: layer];
	
	// return the scene
	return scene;
}

- (void) onEnterTransitionDidFinish
{
    [super onEnterTransitionDidFinish];
    
    if (_matchmakingClient == nil)
	{
        _quitReason = QuitReasonConnectionDropped;
        _matchmakingClient = [[MatchmakingClient alloc] init];
        _matchmakingClient.delegate = self;
		[_matchmakingClient startSearchingForServersWithSessionID:SESSION_ID];
        textField.placeholder = _matchmakingClient.session.displayName;
        
		[tableView reloadData];
	}
}


-(id) init
{
    if( (self=[super init]) ) {
        if( UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone )
        {
            
            if ([UIScreen instancesRespondToSelector:@selector(scale)])
            {
                CGFloat scale = [[UIScreen mainScreen] scale];
                if (scale > 1.0)
                {
                    if ([[UIScreen mainScreen] bounds].size.height == 568)
                    {
                        // IPHONE 5
                        
                        // ask director for the window size
                        CGSize size = [[CCDirector sharedDirector] winSize];
                        
                        // BackGround
                        CCSprite *background = [CCSprite spriteWithFile:@"background_iph-hd.png"];
                        [background setPosition:ccp(size.width/2, size.height/2)];
                        
                        [self addChild:background];
                        
                        //titre
                        CCLabelTTF *hostlabel = [CCLabelTTF labelWithString:@"CONNEXION DES APPAREILS" fontName:@"Economica-Bold" fontSize:22];
                        hostlabel.position = ccp( size.width/2, size.height/2 + 200);
                        
                        [self addChild:hostlabel];
                        
                        // your name label
                        CCLabelTTF *name = [CCLabelTTF labelWithString:@"Nom de l'iPhone" fontName:@"Economica-Bold" fontSize:18];
                        name.position = ccp( size.width/2 - 100, size.height/2 + 100);
                        
                        [self addChild:name];
                        
                        CCSprite *champs = [CCSprite spriteWithFile:@"champs_txt-hd.png"];
                        [champs setPosition:ccp(size.width/2 + 60, size.height/2 + 99)];
                        
                        [self addChild:champs];
                        
                        //textfield
                        textField = [[UITextField alloc]init];
                        textField.frame = CGRectMake(size.width/2 - 15, size.height/2 - 111, 160, 40);
                        textField.font = [UIFont fontWithName:@"Economica-Regular" size:18];
                        textField.textColor = [UIColor whiteColor];
                        textField.enabled = NO;
                        textField.delegate = self;
                        
                        textFieldWrapper = [CCUIViewWrapper wrapperForUIView:textField];
                        
                        [self addChild:textFieldWrapper];
                        
                        //message
                        CCLabelTTF *message = [CCLabelTTF labelWithString:@"RECHERCHE D'UNE PARTIE EN COURS..." fontName:@"Economica-Bold" fontSize:22];
                        message.position = ccp( size.width/2, size.height/2 );
                        
                        [self addChild:message];
                        
                        //message2
                        CCLabelTTF *message2 = [CCLabelTTF labelWithString:@"Veuillez allumer votre iPad" fontName:@"Economica-Regular" fontSize:22];
                        message2.position = ccp( size.width/2, size.height/2 - 40 );
                        
                        [self addChild:message2];
                        
                        // your name label
                        CCLabelTTF *name2 = [CCLabelTTF labelWithString:@"Nom du plateau" fontName:@"Economica-Bold" fontSize:18];
                        name2.position = ccp( size.width/2 - 100, size.height/2 - 150);
                        
                        [self addChild:name2];
                        
                        CCSprite *champs2 = [CCSprite spriteWithFile:@"champs_txt-hd.png"];
                        [champs2 setPosition:ccp(size.width/2 + 60, size.height/2 - 151)];
                        
                        [self addChild:champs2];

                        // Bouton back
                        CCMenuItemImage *button_back = [CCMenuItemImage itemWithNormalImage:@"back_btn_iph-hd.png" selectedImage:@"back_btn_iph-hd.png" target:self selector:@selector(buttonPressedBack:)];
                        
                        CCMenu *menu_back = [CCMenu menuWithItems:button_back, nil];
                        [menu_back setPosition:ccp( size.width/2 - 128, size.height/2 + 252)];
                        
                        // Add the menu to the layer
                        [self addChild:menu_back];
                        
                        //tableview
                        tableView = [[UITableView alloc]initWithFrame:CGRectMake(size.width/2 - 24, size.height/2 + 135, 160, 40) style:UITableViewStylePlain ];
                        tableView.backgroundColor = [UIColor clearColor];
                        [tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
                        tableView.opaque = NO;
                        tableView.backgroundView = nil;
                        tableView.scrollEnabled = NO;
                        tableView.delegate = self;
                        tableView.dataSource = self;
                        
                        tableViewWrapper = [CCUIViewWrapper wrapperForUIView:tableView];
                        
                        [self addChild:tableViewWrapper];
                        
                        // Bouton rejoindre
                        button_rejoindre = [CCMenuItemImage itemWithNormalImage:@"rejoindre_btn_off-hd.png" selectedImage:@"rejoindre_btn_off-hd.png" target:self selector:@selector(buttonPressedBack:)];
                        
                        CCMenu *menu_rejoindre = [CCMenu menuWithItems:button_rejoindre, nil];
                        [menu_rejoindre setPosition:ccp( size.width/2, size.height/2 - 266)];
                        
                        // Add the menu to the layer
                        [self addChild:menu_rejoindre];
                        
                    }
                    else
                    {
                        // IPHONE RETINA SCREEN
                        
                        // ask director for the window size
                        CGSize size = [[CCDirector sharedDirector] winSize];
                        
                        // BackGround
                        CCSprite *background = [CCSprite spriteWithFile:@"background_iph.png"];
                        [background setPosition:ccp(size.width/2, size.height/2)];
                        
                        [self addChild:background];
                        
                        //titre
                        CCLabelTTF *hostlabel = [CCLabelTTF labelWithString:@"CONNEXION DES APPAREILS" fontName:@"Economica-Bold" fontSize:22];
                        hostlabel.position = ccp( size.width/2, size.height/2 + 160);
                        
                        [self addChild:hostlabel];
                        
                        // your name label
                        CCLabelTTF *name = [CCLabelTTF labelWithString:@"Nom de l'iPhone" fontName:@"Economica-Bold" fontSize:18];
                        name.position = ccp( size.width/2 - 100, size.height/2 + 80);
                        
                        [self addChild:name];
                        
                        CCSprite *champs = [CCSprite spriteWithFile:@"champs_txt-hd.png"];
                        [champs setPosition:ccp(size.width/2 + 60, size.height/2 + 79)];
                        
                        [self addChild:champs];
                        
                        //textfield
                        textField = [[UITextField alloc]init];
                        textField.frame = CGRectMake(size.width/2 - 15, size.height/2 - 91, 160, 40);
                        textField.font = [UIFont fontWithName:@"Economica-Regular" size:18];
                        textField.textColor = [UIColor whiteColor];
                        textField.enabled = NO;
                        textField.delegate = self;
                        
                        textFieldWrapper = [CCUIViewWrapper wrapperForUIView:textField];
                        
                        [self addChild:textFieldWrapper];
                        
                        //message
                        CCLabelTTF *message = [CCLabelTTF labelWithString:@"RECHERCHE D'UNE PARTIE EN COURS..." fontName:@"Economica-Bold" fontSize:22];
                        message.position = ccp( size.width/2, size.height/2 );
                        
                        [self addChild:message];
                        
                        //message2
                        CCLabelTTF *message2 = [CCLabelTTF labelWithString:@"Veuillez allumer votre iPad" fontName:@"Economica-Regular" fontSize:22];
                        message2.position = ccp( size.width/2, size.height/2 - 40 );
                        
                        [self addChild:message2];
                        
                        // your name label
                        CCLabelTTF *name2 = [CCLabelTTF labelWithString:@"Nom du plateau" fontName:@"Economica-Bold" fontSize:18];
                        name2.position = ccp( size.width/2 - 100, size.height/2 - 130);
                        
                        [self addChild:name2];
                        
                        CCSprite *champs2 = [CCSprite spriteWithFile:@"champs_txt-hd.png"];
                        [champs2 setPosition:ccp(size.width/2 + 60, size.height/2 - 131)];
                        
                        [self addChild:champs2];
                        
                        // Bouton back
                        CCMenuItemImage *button_back = [CCMenuItemImage itemWithNormalImage:@"back_btn_iph.png" selectedImage:@"back_btn_iph.png" target:self selector:@selector(buttonPressedBack:)];
                        
                        CCMenu *menu_back = [CCMenu menuWithItems:button_back, nil];
                        [menu_back setPosition:ccp( size.width/2 - 128, size.height/2 + 208)];
                        
                        // Add the menu to the layer
                        [self addChild:menu_back];
                        
                        //tableview
                        tableView = [[UITableView alloc]initWithFrame:CGRectMake(size.width/2 - 24, size.height/2 + 115, 160, 40) style:UITableViewStylePlain ];
                        tableView.backgroundColor = [UIColor clearColor];
                        [tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
                        tableView.opaque = NO;
                        tableView.backgroundView = nil;
                        tableView.scrollEnabled = NO;
                        tableView.delegate = self;
                        tableView.dataSource = self;
                        
                        tableViewWrapper = [CCUIViewWrapper wrapperForUIView:tableView];
                        
                        [self addChild:tableViewWrapper];
                        
                        // Bouton rejoindre
                        button_rejoindre = [CCMenuItemImage itemWithNormalImage:@"rejoindre_btn_off.png" selectedImage:@"rejoindre_btn_off.png" target:self selector:@selector(buttonPressedBack:)];
                        
                        CCMenu *menu_rejoindre = [CCMenu menuWithItems:button_rejoindre, nil];
                        [menu_rejoindre setPosition:ccp( size.width/2, size.height/2 - 224)];
                        
                        // Add the menu to the layer
                        [self addChild:menu_rejoindre];
                    }
                }
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
	if (_matchmakingClient != nil)
            return [_matchmakingClient availableServerCount];
	else
		return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
	static NSString *CellIdentifier = @"CellIdentifier";
    
	UITableViewCell *cell = [self->tableView dequeueReusableCellWithIdentifier:CellIdentifier];
	if (cell == nil)
		cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    
	NSString *peerID = [_matchmakingClient peerIDForAvailableServerAtIndex:indexPath.row];
	cell.textLabel.text = [_matchmakingClient displayNameForPeerID:peerID];
    cell.textLabel.font = [UIFont fontWithName:@"Economica-Regular" size:18];
    cell.textLabel.textColor = [UIColor whiteColor];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
	return cell;
}

- (void) buttonPressedBack: (id) sender
{
    //_quitReason = QuitReasonUserQuit;
    //[_matchmakingClient disconnectFromServer];
    [[CCDirector sharedDirector] replaceScene:[HelloWorldLayer node]];
}

#pragma mark - MatchmakingClientDelegate

- (void)matchmakingClient:(MatchmakingClient *)client serverBecameAvailable:(NSString *)peerID
{
	[tableView reloadData];
}

- (void)matchmakingClient:(MatchmakingClient *)client serverBecameUnavailable:(NSString *)peerID
{
	[tableView reloadData];
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
	[self->tableView deselectRowAtIndexPath:indexPath animated:YES];
    
	if (_matchmakingClient != nil)
	{
		[[CCDirector sharedDirector] pushScene:[WaitLayer node]];
        [self->tableView setHidden:YES];
        [self->textField setHidden:YES];
        
        NSString *peerID = [_matchmakingClient peerIDForAvailableServerAtIndex:indexPath.row];
		[_matchmakingClient connectToServerWithPeerID:peerID];
        
    }
}

- (void)matchmakingClient:(MatchmakingClient *)client didDisconnectFromServer:(NSString *)peerID
{
	_matchmakingClient.delegate = nil;
	_matchmakingClient = nil;
	[tableView reloadData];
    [[CCDirector sharedDirector] sendCleanupToScene];
    [[CCDirector sharedDirector] popScene];
    [[CCDirector sharedDirector] replaceScene:[HelloWorldLayer node]];
    // Mode avion
    /* if (_quitReason == QuitReasonNoNetwork)
	{
        [self showNoNetworkAlert];
	}*/
    //Si le serveur se deconnecte
    if (_quitReason == QuitReasonConnectionDropped)
	{
        if (tableView.hidden == YES) {
            [self showDisconnectedAlert];
        }
        else
        {
            //nothing
        }

	}
    
}

- (void)matchmakingClient:(MatchmakingClient *)client didConnectToServer:(NSString *)peerID
{
    NSString *name = [textField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
	if ([name length] == 0)
		name = _matchmakingClient.session.displayName;
    [[CCDirector sharedDirector] sendCleanupToScene];
    [[CCDirector sharedDirector] popScene];
    [self startGameWithBlock:^(Game *game)
     {
         [game startClientGameWithSession:_matchmakingClient.session playerName:name server:peerID];
     }];
    
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

#pragma mark - GameViewControllerDelegate

- (void)gameViewController:(GameView *)controller didQuitWithReason:(QuitReason)reason
{
	_matchmakingClient.delegate = nil;
	_matchmakingClient = nil;
	[tableView reloadData];
    [[CCDirector sharedDirector] sendCleanupToScene];
    [[CCDirector sharedDirector] popScene];
    [[CCDirector sharedDirector] replaceScene:[HelloWorldLayer node]];
    if (reason == QuitReasonConnectionDropped)
    {
        [self showDisconnectedAlert];
    }
}

- (void)showDisconnectedAlert
{
	UIAlertView *alertView = [[UIAlertView alloc]
                              initWithTitle:NSLocalizedString(@"Disconnected", @"Client disconnected alert title")
                              message:NSLocalizedString(@"You were disconnected from the game.", @"Client disconnected alert message")
                              delegate:nil
                              cancelButtonTitle:NSLocalizedString(@"OK", @"Button: OK")
                              otherButtonTitles:nil];
    
	[alertView show];
}

- (void)showNoNetworkAlert
{
	UIAlertView *alertView = [[UIAlertView alloc]
                              initWithTitle:NSLocalizedString(@"No Network", @"No network alert title")
                              message:NSLocalizedString(@"To use multiplayer, please enable Bluetooth or Wi-Fi in your device's Settings.", @"No network alert message")
                              delegate:nil
                              cancelButtonTitle:NSLocalizedString(@"OK", @"Button: OK")
                              otherButtonTitles:nil];
    
	[alertView show];
}

- (void)matchmakingClientNoNetwork:(MatchmakingClient *)client
{
	_quitReason = QuitReasonNoNetwork;
}

#pragma mark - UITextFieldDelegate

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
	[textField resignFirstResponder];
	return NO;
}

@end
