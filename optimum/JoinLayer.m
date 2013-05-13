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
                        
                        //titre
                        CCLabelTTF *hostlabel = [CCLabelTTF labelWithString:@"JoinGame" fontName:@"Marker Felt" fontSize:32];
                        hostlabel.position = ccp( size.width/2, size.height/2 + 220);
                        
                        [self addChild:hostlabel];
                        
                        // your name label
                        CCLabelTTF *name = [CCLabelTTF labelWithString:@"Your Name :" fontName:@"Marker Felt" fontSize:24];
                        name.position = ccp( size.width/2 - 80, size.height/2 + 150);
                        
                        [self addChild:name];
                        
                        CCLabelTTF *message = [CCLabelTTF labelWithString:@"Recherche de partie en cours..." fontName:@"Marker Felt" fontSize:24];
                        message.position = ccp( size.width/2, size.height/2 + 100 );
                        
                        [self addChild:message];
                        
                        // Bouton back
                        CCMenuItemImage *button_back = [CCMenuItemImage itemWithNormalImage:@"button_back.png" selectedImage:@"button_back.png" target:self selector:@selector(buttonPressedBack:)];
                        
                        CCMenu *menu_back = [CCMenu menuWithItems:button_back, nil];
                        //[menu alignItemsHorizontallyWithPadding:-10];
                        [menu_back setPosition:ccp( size.width/2 - 130, size.height/2 + 220)];
                        
                        // Add the menu to the layer
                        [self addChild:menu_back];
                        
                        //tableview
                        
                        tableView = [[UITableView alloc]initWithFrame:CGRectMake( 0, size.height/2 - 50 , size.width, 200) style:UITableViewStyleGrouped];
                        tableView.delegate = self;
                        tableView.dataSource = self;
                        
                        tableViewWrapper = [CCUIViewWrapper wrapperForUIView:tableView];
                        
                        [self addChild:tableViewWrapper];
                        
                        //textfield
                        textField = [[UITextField alloc]init];
                        textField.frame = CGRectMake(size.width/2 - 20, size.height/2 - 170, 160, 40);
                        [textField  setBackgroundColor:[UIColor grayColor]];
                        textField.delegate = self;
                        
                        textFieldWrapper = [CCUIViewWrapper wrapperForUIView:textField];
                        
                        [self addChild:textFieldWrapper];
                        
                    }
                    else
                    {
                        // IPHONE RETINA SCREEN
                        
                        // ask director for the window size
                        CGSize size = [[CCDirector sharedDirector] winSize];
                        
                        //titre
                        CCLabelTTF *hostlabel = [CCLabelTTF labelWithString:@"JoinGame" fontName:@"Marker Felt" fontSize:32];
                        hostlabel.position = ccp( size.width/2, size.height/2 + 190);
                        
                        [self addChild:hostlabel];
                        
                        // your name label
                        CCLabelTTF *name = [CCLabelTTF labelWithString:@"Your Name :" fontName:@"Marker Felt" fontSize:24];
                        name.position = ccp( size.width/2 - 80, size.height/2 + 120);
                        
                        [self addChild:name];
                        
                        CCLabelTTF *message = [CCLabelTTF labelWithString:@"Recherche de partie en cours..." fontName:@"Marker Felt" fontSize:24];
                        message.position = ccp( size.width/2, size.height/2 + 70 );
                        
                        [self addChild:message];
                        
                        // Bouton back
                        CCMenuItemImage *button_back = [CCMenuItemImage itemWithNormalImage:@"button_back.png" selectedImage:@"button_back.png" target:self selector:@selector(buttonPressedBack:)];
                        
                        CCMenu *menu_back = [CCMenu menuWithItems:button_back, nil];
                        //[menu alignItemsHorizontallyWithPadding:-10];
                        [menu_back setPosition:ccp( size.width/2 - 130, size.height/2 + 190)];
                        
                        // Add the menu to the layer
                        [self addChild:menu_back];
                        
                        //tableview
                        
                        tableView = [[UITableView alloc]initWithFrame:CGRectMake( 0, size.height/2 - 30 , size.width, 200) style:UITableViewStyleGrouped];
                        tableView.delegate = self;
                        tableView.dataSource = self;
                        
                        tableViewWrapper = [CCUIViewWrapper wrapperForUIView:tableView];
                        
                        [self addChild:tableViewWrapper];
                        
                        //textfield
                        textField = [[UITextField alloc]init];
                        textField.frame = CGRectMake(size.width/2 - 20, size.height/2 - 140, 160, 40);
                        [textField  setBackgroundColor:[UIColor grayColor]];
                        textField.delegate = self;
                        
                        textFieldWrapper = [CCUIViewWrapper wrapperForUIView:textField];
                        
                        [self addChild:textFieldWrapper];
                    }
                }
            }
            else
            {
                // IPHONE SCREEN
                
                // ask director for the window size
                CGSize size = [[CCDirector sharedDirector] winSize];
                
                //titre
                CCLabelTTF *hostlabel = [CCLabelTTF labelWithString:@"JoinGame" fontName:@"Marker Felt" fontSize:32];
                hostlabel.position = ccp( size.width/2, size.height/2 + 190);
                
                [self addChild:hostlabel];
                
                // your name label
                CCLabelTTF *name = [CCLabelTTF labelWithString:@"Your Name :" fontName:@"Marker Felt" fontSize:24];
                name.position = ccp( size.width/2 - 80, size.height/2 + 120);
                
                [self addChild:name];
                
                CCLabelTTF *message = [CCLabelTTF labelWithString:@"Recherche de partie en cours..." fontName:@"Marker Felt" fontSize:24];
                message.position = ccp( size.width/2, size.height/2 + 70 );
                
                [self addChild:message];
                
                // Bouton back
                CCMenuItemImage *button_back = [CCMenuItemImage itemWithNormalImage:@"button_back.png" selectedImage:@"button_back.png" target:self selector:@selector(buttonPressedBack:)];
                
                CCMenu *menu_back = [CCMenu menuWithItems:button_back, nil];
                //[menu alignItemsHorizontallyWithPadding:-10];
                [menu_back setPosition:ccp( size.width/2 - 130, size.height/2 + 190)];
                
                // Add the menu to the layer
                [self addChild:menu_back];
                
                //tableview
                
                tableView = [[UITableView alloc]initWithFrame:CGRectMake( 0, size.height/2 - 30 , size.width, 200) style:UITableViewStyleGrouped];
                tableView.delegate = self;
                tableView.dataSource = self;
                
                tableViewWrapper = [CCUIViewWrapper wrapperForUIView:tableView];
                
                [self addChild:tableViewWrapper];
                
                //textfield
                textField = [[UITextField alloc]init];
                textField.frame = CGRectMake(size.width/2 - 20, size.height/2 - 140, 160, 40);
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
    
	return cell;
}

- (void) buttonPressedBack: (id) sender
{
    _quitReason = QuitReasonUserQuit;
    [_matchmakingClient disconnectFromServer];
    [[CCDirector sharedDirector] replaceScene:[PlayLayer scene]];
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
