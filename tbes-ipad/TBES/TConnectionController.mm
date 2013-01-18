//
//  TConnectionController.m
//  TBES
//
//  Created by Danny Westfall on 12/4/12.
//  Copyright (c) 2012 TCU. All rights reserved.
//

#import "TConnectionController.h"
#import "TProgressHUD.h"

@interface TConnectionController(){
    TProgressHUD* hud;
}

@end

@implementation TConnectionController

-(void) viewWillAppear:(BOOL)animated{

}

-(void) viewDidAppear:(BOOL)animated{
    
}

-(BOOL) shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation{
    return (interfaceOrientation == UIInterfaceOrientationLandscapeLeft) || (interfaceOrientation == UIInterfaceOrientationLandscapeRight);
}

-(void) showConnectionError{
    [TProgressHUD hideAllHUDsForView: self.view animated: YES];
    [self showErrorMessage: @"Failed to Connect to Server."];
}

-(void) showConnecting{
    hud = [TProgressHUD showHUDAddedTo: self.view animated: YES];
    [hud setLabelText: @"Connecting..."];
    [hud setDetailsLabelText: @"Please wait while the server is contacted."];
}

-(void) showConnectionComplete{
    [TProgressHUD hideAllHUDsForView: self.view animated: YES];
}

-(void) showConnected{
    [hud setLabelText: @"Connected!"];
    [hud setDetailsLabelText: @"Waiting for Program to Start"];
}

@end
