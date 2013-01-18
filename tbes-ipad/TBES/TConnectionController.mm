/*
 
 This program is free software; you can redistribute it and/or modify
 it under the terms of the GNU General Public License as published by
 the Free Software Foundation; either version 2 of the License, or
 (at your option) any later version.
 
 This program is distributed in the hope that it will be useful,
 but WITHOUT ANY WARRANTY; without even the implied warranty of
 MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 GNU General Public License for more details.
 
 You should have received a copy of the GNU General Public License
 along with this program; if not, write to the Free Software
 Foundation, Inc., 675 Mass Ave, Cambridge, MA 02139, USA.
 
*/

/* ---------------------------------------------------------------------------
 ** Texas Christian University
 **
 ** TConnectionController.mm
 ** TBES
 **
 ** Created on 12/4/12
 ** Kenneth Leising
 ** Catherine Urbano
 ** Danny Westfall
 ** 
 ** -------------------------------------------------------------------------*/

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
