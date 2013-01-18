//
//  TBehavioralEvaluationViewController.h
//  TBES
//
//  Created by Danny Westfall on 12/4/12.
//  Copyright (c) 2012 TCU. All rights reserved.
//

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
