//
//  TConnectionController.h
//  TBES
//
//  Created by Danny Westfall on 12/4/12.
//  Copyright (c) 2012 TCU. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TViewController.h"

@interface TConnectionController : TViewController{

}

-(void) showConnecting;
-(void) showConnected;
-(void) showConnectionComplete;
-(void) showConnectionError;

@end
