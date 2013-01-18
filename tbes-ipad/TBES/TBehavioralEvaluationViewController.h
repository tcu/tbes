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
 ** TBehavioralEvaluationViewController.h
 ** TBES
 **
 ** Created on 12/4/12
 ** Kenneth Leising
 ** Catherine Urbano
 ** Danny Westfall
 ** 
 ** -------------------------------------------------------------------------*/

#import <UIKit/UIKit.h>
#import "TViewController.h"


@interface TBehavioralEvaluationViewController : TViewController<NSStreamDelegate>{

}

-(IBAction) OnCloseHelp :(id) sender;
-(IBAction) OnConnect :(id) sender;

-(IBAction) OnShowHelp :(id) sender;
-(IBAction) OnConnect :(id) sender;

-(IBAction) OnCloseConnectionDetails: (id)sender;
-(IBAction) OnCloseConnection: (id)sender;

-(IBAction) OnCompleteTouchTip: (id)sender;
-(IBAction) OnConnectToDemoServer: (id)sender;

-(void) SquareOne: (int) shapevalue;
-(void) SquareTwo: (int) shapevalue;
-(void) SquareThree: (int) shapevalue;
-(void) SquareFour: (int) shapevalue;
-(void) SquareFive: (int) shapevalue;
-(void) SquareSix: (int) shapevalue;

@end
